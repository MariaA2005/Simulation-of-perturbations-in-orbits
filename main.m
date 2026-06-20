%% 1. Configuración de constantes y condiciones iniciales
Gr = 6.6743e-11;      
m1 = 5.972e24;        
m2 = 10;            
radio_orbita = 6800e3; 
Re = 6378137;         
%% 2. Perturbaciones
J2 =  1.08263e-3;      
%% 3.Cond. iniciales
v_orbital = sqrt(Gr * m1 / radio_orbita); 

R10 = [0; 0; 0];                    
R20 = [radio_orbita; 0; 0];         
V10 = [0; 0; 0];                    
V20 = [0; v_orbital * cos(deg2rad(45)); v_orbital * sin(deg2rad(45))]; 

% Aumentamos el tiempo a 24 horas (varias órbitas) para ver la precesión de la órbita
tf = 3*24 * 3600; 

%% 2. Integración Numérica

[t, states_m] = two_body_integration(Gr, m1, m2, R10, V10, R20, V20, tf, Re, 0); 
[tJ2, statesJ2_m] = two_body_integration(Gr, m1, m2, R10, V10, R20, V20, tf, Re, J2);

%% 3. Extracción del Satélite y conversión a Kilómetros
% Si tu función devuelve 12 columnas, el satélite está en las columnas 7:12.
% Si calculamos la posición RELATIVA (Satélite - Tierra), nos aseguramos de centrar todo en la Tierra.

r_sat_ideal = (states_m(:, 7:9) - states_m(:, 1:3)) / 1000;
v_sat_ideal = (states_m(:, 10:12) - states_m(:, 4:6)) / 1000;

r_sat_j2 = (statesJ2_m(:, 7:9) - statesJ2_m(:, 1:3)) / 1000;
v_sat_j2 = (statesJ2_m(:, 10:12) - statesJ2_m(:, 4:6)) / 1000;

%% 4. Visualización y Comparación 3D
plot3D(r_sat_ideal, r_sat_j2); 

%% 5. Diferencia Radial (Corregido con Interpolación)
plotDifRadial(r_sat_ideal, r_sat_j2, tJ2, t); 

%% 6. Análisis de Inclinación y Radio
n_ideal = length(t);
n_j2 = length(tJ2);
inc_ideal = zeros(n_ideal, 1);
inc_j2 = zeros(n_j2, 1);

for i = 1:n_ideal
    h_vec = cross(r_sat_ideal(i,:), v_sat_ideal(i,:));
    inc_ideal(i) = rad2deg(acos(h_vec(3) / norm(h_vec)));
end

for i = 1:n_j2
    h_vec = cross(r_sat_j2(i,:), v_sat_j2(i,:));
    inc_j2(i) = rad2deg(acos(h_vec(3) / norm(h_vec)));
end

figure('Name', 'Análisis de Perturbaciones', 'Color', 'w');
subplot(2,1,1);
plot(t/3600, inc_ideal, 'b', 'LineWidth', 1.5, 'DisplayName', 'Ideal');
hold on;
plot(tJ2/3600, inc_j2, 'r--', 'LineWidth', 1.2, 'DisplayName', 'Con J2');
title('Evolución de la Inclinación');
ylabel('i (grados)'); xlabel('Tiempo (horas)'); legend; grid on;
% Calcular la norma (magnitud) de los vectores de posición en km
r_norm_ideal_vec = sqrt(sum(r_sat_ideal.^2, 2));
r_norm_j2_vec = sqrt(sum(r_sat_j2.^2, 2));
subplot(2,1,2);
plot(t/3600, r_norm_ideal_vec, 'b', 'LineWidth', 1.5, 'DisplayName', 'Ideal');
hold on;
plot(tJ2/3600, r_norm_j2_vec, 'r--', 'LineWidth', 1.2, 'DisplayName', 'Con J2');
title('Evolución del Radio Orbital');
ylabel('|r| (km)'); xlabel('Tiempo (horas)'); legend; grid on;