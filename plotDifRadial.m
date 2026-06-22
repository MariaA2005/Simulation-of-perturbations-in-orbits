function [] = plotDifRadial(orbitNominal, varargin)
    numOrbits = length(varargin);
    colors = {'#D95319', '#EDB120', '#7E2F8E', '#77AC30', '#4DBEEE', '#A2142F'};
    
    figure('Color', 'w');
    
    for i = 1:numOrbits
        % Crear un subgráfico vertical para cada órbita perturbadora
        subplot(numOrbits, 1, i);
        
        orbitP = varargin{i}; 
        r_norm_j2_interp = interp1(orbitP.t, orbitP.radiusNorm, orbitNominal.t, 'linear', 'extrap');
        
        diferencia_radial = orbitNominal.radiusNorm - r_norm_j2_interp;
        
        % Línea de referencia en cero
        plot(orbitNominal.t/3600, zeros(size(orbitNominal.t)), 'k--', 'LineWidth', 1.2, 'DisplayName', 'Reference (Kepler)');
        hold on;
        
        color_idx = mod(i-1, length(colors)) + 1;
        
        % --- OBTENER EL NOMBRE DE LA VARIABLE ---
        % inputname(1) es 'orbitNominal'. Los de varargin empiezan en el índice 2.
        nombreVariable = inputname(i + 1); 
        
        % Si pasan un argumento directo sin nombre (ej: un struct inline), evitamos que quede vacío
        if isempty(nombreVariable)
            nombreVariable = sprintf('Orbit %d', i);
        end
        
        label_name = sprintf('Perturbed: %s', nombreVariable);
        % ----------------------------------------
        
        % Gráfica de la diferencia
        plot(orbitNominal.t/3600, diferencia_radial, '-', 'Color', colors{color_idx}, 'LineWidth', 1.5, 'DisplayName', label_name);
        
        % Ajuste independiente del eje Y para cada subgráfico
        localMin = min(diferencia_radial);
        localMax = max(diferencia_radial);
        yRange = localMax - localMin;
        if yRange == 0
            ylim([-1, 1]);
        else
            ylim([localMin - 0.1*yRange, localMax + 0.1*yRange]);
        end
        
        grid on;
        legend('Location', 'best');
        xlabel('Time (hours)');
        ylabel('\Delta Radio (km)');
        title(['Radial Distance Error Analysis - ', nombreVariable]);
    end
end