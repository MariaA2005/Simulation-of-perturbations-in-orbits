function [t, Y, R1sol, V1sol, R2sol, V2sol] = two_body_integration(Gr, m1, m2, R10, V10, R20, V20, tf, Re, J2)
    Y0 = [R10; V10; R20; V20];
    
    % 3. Define Time Span
    tspan = [0, tf]; 
    
    % 4. Perform the Numerical Integration using ode45 (Ahora pasando Re y J2)
    options = odeset('RelTol', 1e-8, 'AbsTol', 1e-8); 
    [t, Y] = ode45(@(t, Y) equations_of_motion(t, Y, Gr, m1, m2, Re, J2), tspan, Y0, options);
    
    % 5. Extract the solutions
    R1sol = Y(:, 1:3); % Columns 1, 2, 3 are the x,y,z positions of Mass 1
    V1sol = Y(:, 4:6); % Columns 4, 5, 6 are the velocities of Mass 1
    R2sol = Y(:, 7:9); % Columns 7, 8, 9 are the x,y,z positions of Mass 2
    V2sol = Y(:, 10:12); % Columns 10, 11, 12 are the velocities of Mass 2
end

% -------------------------------------------------------------------------
% FUNCTION DEFINING THE DIFFERENTIAL EQUATIONS WITH J2 PERTURBATION
% -------------------------------------------------------------------------
function dYdt = equations_of_motion(t, Y, Gr, m1, m2, Re, J2)
    % Unpack the state vector into current positions and velocities
    R1 = Y(1:3); % Posición Mass 1 (Tierra)
    V1 = Y(4:6);
    R2 = Y(7:9); % Posición Mass 2 (Satélite)
    V2 = Y(10:12);
    
    % Vector pointing from m1 to m2
    rel_pos = R2 - R1;
    
    % Norm (distance between the two masses)
    dist = norm(rel_pos); 
    
    % --- Calculate Base Newtonian Accelerations ---
    A1 =  Gr * m2 * rel_pos / (dist^3);
    A2 = -Gr * m1 * rel_pos / (dist^3);
    
    % --- J2 PERTURBATION CALCULATION ---
    % Componentes cartesianas de la posición relativa
    x = rel_pos(1);
    y = rel_pos(2);
    z = rel_pos(3);
    
    % Parámetro gravitacional estándar del cuerpo central (mu = G * m1)
    mu = Gr * m1;
    
    % Factor común de la aceleración J2
    factor = (3 * J2 * mu * Re^2) / (2 * dist^5);
    
    % Aceleración perturbadora en componentes X, Y, Z
    a_J2_x = factor * x * ((5 * (z^2) / (dist^2)) - 1);
    a_J2_y = factor * y * ((5 * (z^2) / (dist^2)) - 1);
    a_J2_z = factor * z * ((5 * (z^2) / (dist^2)) - 3);
    
    A_J2 = [a_J2_x; a_J2_y; a_J2_z];
    
    % Se añade el efecto J2 a la aceleración del satélite (Mass 2)
    A2 = A2 + A_J2;
    
    % Repack the derivatives into a column vector
    dYdt = [V1; A1; V2; A2]; 
end
