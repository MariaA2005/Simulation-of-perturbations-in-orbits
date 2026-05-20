function [] = plotDifRadial(r_sat_ideal, r_sat_j2, tJ2, t)
r_norm_ideal_vec = vecnorm(r_sat_ideal, 2, 2);
r_norm_j2_vec = vecnorm(r_sat_j2, 2, 2);

% El truco: interpolamos el radio con J2 para que use los mismos tiempos 't' que la ideal
r_norm_j2_interp = interp1(tJ2, r_norm_j2_vec, t, 'linear', 'extrap');

% Ahora sí miden exactamente lo mismo y se pueden restar
diferencia_radial = r_norm_ideal_vec - r_norm_j2_interp;

figure('Color', 'w');
plot(t/3600, diferencia_radial, 'r', 'LineWidth', 1.5, 'DisplayName', 'Perturbación J_2 (Error)');
hold on;
plot(t/3600, zeros(size(t)), 'k--', 'LineWidth', 1.2, 'DisplayName', 'Referencia Ideal (Kepler)');
title('Diferencia Radial: Desviación respecto al Modelo Teórico');
xlabel('Tiempo (horas)'); ylabel('\Delta Radio (km)');
legend('Location', 'best'); grid on;

% Ajustamos los límites del gráfico dinámicamente
ylim([min(diferencia_radial)*1.2, max(diferencia_radial)*1.2]);
end