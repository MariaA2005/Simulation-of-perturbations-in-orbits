function dstate = orbit_ode(t, state, mu)
    r_vec = state(1:3); % Posición x, y, z
    v_vec = state(4:6); % Velocidad vx, vy, vz
    r = norm(r_vec);
    
    % Aceleración ideal
    a_ideal = -mu * r_vec / r^3;
    
    % Derivada del estado: [velocidad; aceleración]
    dstate = [v_vec; a_ideal];
end