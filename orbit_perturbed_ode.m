function dstate = orbit_perturbed_ode(t, state, mu)
    r_vec = state(1:3);
    v_vec = state(4:6);
    r = norm(r_vec);
    z = state(3);
    
    % Constantes J2
    J2 = 1.08263e-3;
    R_earth = 6378.137;
    
    % Aceleración Ideal
    a_ideal = -mu * r_vec / r^3;
    
    % Aceleración J2 (Fórmula simplificada por componentes)
    factor = (1.5 * J2 * mu * R_earth^2) / (r^5);
    ax_j2 = factor * r_vec(1) * (5 * (z^2 / r^2) - 1);
    ay_j2 = factor * r_vec(2) * (5 * (z^2 / r^2) - 1);
    az_j2 = factor * r_vec(3) * (5 * (z^2 / r^2) - 3);
    a_j2 = [ax_j2; ay_j2; az_j2];
    
    % Estado final
    dstate = [v_vec; a_ideal + a_j2];
end