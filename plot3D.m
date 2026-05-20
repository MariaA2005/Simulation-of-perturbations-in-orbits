function [] = plot3D(r_sat_ideal, r_sat_j2)
figure('Color', 'w');
hold on;
plot3(r_sat_ideal(:,1), r_sat_ideal(:,2), r_sat_ideal(:,3), 'b', 'LineWidth', 1.5, 'DisplayName', 'Ideal (Kepler)');
plot3(r_sat_j2(:,1), r_sat_j2(:,2), r_sat_j2(:,3), 'r--', 'LineWidth', 1.2, 'DisplayName', 'Perturbada (J2)');

% Graficar la Tierra a escala (en km)
[unitX, unitY, unitZ] = sphere(20);
surf(unitX*6378, unitY*6378, unitZ*6378, 'EdgeColor', 'none', 'FaceAlpha', 0.1);

axis equal; grid on; legend('Location', 'best');
title('Comparación de Órbitas: Ideal vs Perturbación J_2 (24h)');
xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
view(3); % Forzar vista 3D
end