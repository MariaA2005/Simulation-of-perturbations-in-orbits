%% 1. Configuración de constantes y condiciones iniciales
mu = 398600.44; 
r0 = [7000; 0; 0];    % km
v0 = [0; 7.5; 0.5];   % km/s (añado un poco en Z para ver la inclinación)
initial_state = [r0; v0];

% Un periodo orbital aprox es 1.5h, simulemos 24 horas para ver la diferencia
% En lugar de [0 24*3600], creamos un vector con pasos de 10 segundos
tspan = 0:10:24*3600; 

% Ahora ambas simulaciones devolverán la misma cantidad de filas
% Definir tolerancias estrictas
options = odeset('RelTol', 1e-9, 'AbsTol', 1e-12);

% Usar las opciones en el integrador
[t, states] = ode45(@(t, y) orbit_ode(t, y, mu), tspan, initial_state, options);
[tJ2, statesJ2] = ode45(@(t, y) orbit_perturbed_ode(t, y, mu), tspan, initial_state, options);

% Graficar la Tierra para escala
[unitX, unitY, unitZ] = sphere(20);
surf(unitX*6378, unitY*6378, unitZ*6378, 'EdgeColor', 'none', 'FaceAlpha', 0.2);

%% 4. Visualización y Comparación
figure;
hold on;
plot3(states(:,1), states(:,2), states(:,3), 'b', 'DisplayName', 'Ideal (Kepler)');
plot3(statesJ2(:,1), statesJ2(:,2), statesJ2(:,3), 'r--', 'DisplayName', 'Perturbada (J2)');
axis equal; grid on; legend;
title('Comparación de Órbitas: Ideal vs Perturbación J_2');
xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');

% Zoom opcional para ver la diferencia al final del tiempo
figure;
plot(t/3600, vecnorm(states(:,1:3), 2, 2) - vecnorm(statesJ2(:,1:3), 2, 2));
title('Diferencia de posición radial a lo largo del tiempo');
xlabel('Tiempo (horas)'); ylabel('Diferencia (km)');