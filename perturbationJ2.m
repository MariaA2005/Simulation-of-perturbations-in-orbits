function [A2] = perturbationJ2(rel_pos, J2, dist, constant, A2)
 % --- J2 PERTURBATION CALCULATION ---
    
    x = rel_pos(1);
    y = rel_pos(2);
    z = rel_pos(3);
    
    % Parámetro gravitacional estándar del cuerpo central (mu = G * m1)
    mu = constant.Gr * constant.m1;
    
    % Factor común de la aceleración J2
    factor = (3 * J2 * mu * constant.Re^2) / (2 * dist^5);
    
    % Aceleración perturbadora en componentes X, Y, Z
    a_J2_x = factor * x * ((5 * (z^2) / (dist^2)) - 1);
    a_J2_y = factor * y * ((5 * (z^2) / (dist^2)) - 1);
    a_J2_z = factor * z * ((5 * (z^2) / (dist^2)) - 3);
    
    A_J2 = [a_J2_x; a_J2_y; a_J2_z];
    
    % Se añade el efecto J2 a la aceleración del satélite (Mass 2)
    A2 = A2 + A_J2;
end   
    