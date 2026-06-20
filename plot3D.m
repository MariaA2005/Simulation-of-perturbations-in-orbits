function [] = plot3D(r_sat_ideal, varargin)
figure('Color', 'w');
hold on;
plot3(r_sat_ideal(:,1), r_sat_ideal(:,2), r_sat_ideal(:,3), 'b', 'LineWidth', 1.5, 'DisplayName', 'Ideal (Kepler)');

colors = ["#D95319", "#EDB120", "#7E2F8E", "#77AC30", "#4DBEEE", "#A2142F"];
numOrbits = length(varargin);
for i = 1:numOrbits
    r_perturbed = varargin{i};
    color_idx = mod(i-1, length(colors)) + 1;
    label_name = sprintf('Perturbed Orbit %d', i);
    plot3(r_perturbed(:,1), r_perturbed(:,2), r_perturbed(:,3), '--','Color', colors{color_idx}, 'LineWidth', 1.2, 'DisplayName', label_name);
end
% Graficar la Tierra a escala (en km)
[unitX, unitY, unitZ] = sphere(20);
surf(unitX*6378, unitY*6378, unitZ*6378, 'EdgeColor', 'none', 'FaceAlpha', 0.1);

axis equal; grid on; legend('Location', 'best');
title('Comparación de Órbitas: Ideal vs Perturbaciones');
xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
view(3); % Forzar vista 3D
end