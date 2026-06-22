function [] = plot3D(orbitNominalStruct, varargin)
    figure('Color', 'w');
    hold on;
    
    % --- 1. Obtener el nombre de la estructura ideal automáticamente ---
    nombreIdeal = inputname(1);
    if isempty(nombreIdeal)
        nombreIdeal = 'Ideal (Kepler)'; 
    end
    
    % Extraer la matriz de posiciones (Nx3) de la estructura ideal
    r_sat_ideal = orbitNominalStruct.radius;
    
    plot3(r_sat_ideal(:,1), r_sat_ideal(:,2), r_sat_ideal(:,3), 'b', 'LineWidth', 1.5, 'DisplayName', nombreIdeal);
    
    colors = ["#D95319", "#EDB120", "#7E2F8E", "#77AC30", "#4DBEEE", "#A2142F"];
    numOrbits = length(varargin);
    
    for i = 1:numOrbits
        % Extraer la estructura perturbada actual
        orbitP = varargin{i};
        
        % Extraer la matriz de posiciones de esta estructura
        r_perturbed = orbitP.radius;
        
        color_idx = mod(i-1, length(colors)) + 1;
        
        % --- 2. Obtener el nombre de la variable de la estructura ---
        nombreVariable = inputname(i + 1);
        if isempty(nombreVariable)
            nombreVariable = sprintf('Perturbed Orbit %d', i);
        end
        
        plot3(r_perturbed(:,1), r_perturbed(:,2), r_perturbed(:,3), '--', ...
              'Color', colors{color_idx}, 'LineWidth', 1.2, 'DisplayName', nombreVariable);
    end
    
    % Graficar la Tierra a escala (en km) y ocultarla de la leyenda
    [unitX, unitY, unitZ] = sphere(20);
    surf(unitX*6378, unitY*6378, unitZ*6378, 'EdgeColor', 'none', 'FaceAlpha', 0.1, 'HandleVisibility', 'off');
    
    axis equal; grid on; legend('Location', 'best');
    xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
    view(3); % Forzar vista 3D
    
    % Título arriba para que no lo tapen los botones de MATLAB
    sgtitle('Comparación de Órbitas: Ideal vs Perturbaciones', 'FontSize', 12, 'FontWeight', 'bold');
end