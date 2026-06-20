function A2 = perturbationLunisolar(t, rel_pos, constant, A2)
    % PERTURBATIONLUNISOLAR Calculates Third-Body perturbations from Sun and Moon
    
    % --- 1. SUN POSITION APPROXIMATION (Ecliptic Plane) ---
    % Earth's obliquity (23.44 degrees)
    obliquity = deg2rad(constant.earthInc); 
    % Sun's mean angular velocity around Earth
    omega_sun = 2 * pi / (365.25 * 86400); 
    theta_sun = omega_sun * t; % Current angle
    
    r_sun_vec = constant.dist_sun * [
        cos(theta_sun);
        sin(theta_sun) * cos(obliquity);
        sin(theta_sun) * sin(obliquity)
    ];

    % --- 2. MOON POSITION APPROXIMATION (Inclined Orbit) ---
    % Average Moon orbit inclination relative to Earth's equator (~28 degrees)
    inc_moon = deg2rad(28.5);
    % Moon's mean angular velocity around Earth
    omega_moon = 2 * pi / (27.32 * 86400); 
    theta_moon = omega_moon * t;
    
    r_moon_vec = constant.dist_moon * [
        cos(theta_moon);
        sin(theta_moon) * cos(inc_moon);
        sin(theta_moon) * sin(inc_moon)
    ];

    % --- 3. THIRD-BODY ACCELERATION CALCULATION ---
    % Sun Acceleration
    r_sat_sun = r_sun_vec - rel_pos; % Position of Sun relative to satellite
    a_sun = constant.mu_sun * ( (r_sat_sun / norm(r_sat_sun)^3) - (r_sun_vec / norm(r_sun_vec)^3) );
    
    % Moon Acceleration
    r_sat_moon = r_moon_vec - rel_pos; % Position of Moon relative to satellite
    a_moon = constant.mu_moon * ( (r_sat_moon / norm(r_sat_moon)^3) - (r_moon_vec / norm(r_moon_vec)^3) );

    % --- 4. ADD TO TOTAL SATELLITE ACCELERATION ---
    A2 = A2 + a_sun + a_moon;
end