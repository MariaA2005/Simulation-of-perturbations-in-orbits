function [x_pred, P_pred] = predictEKF(t, dt, acc_func, P, Q_base, x_est, k)
    dyn = @(x, tiempo_actual) [x(4:6); acc_func(tiempo_actual)' / 1000];
    
    % Integración RK4:
    k1 = dyn(x_est, t(k-1));
    k2 = dyn(x_est + 0.5 * dt * k1, t(k-1) + 0.5 * dt);
    k3 = dyn(x_est + 0.5 * dt * k2, t(k-1) + 0.5 * dt);
    k4 = dyn(x_est + dt * k3, t(k));
    
    x_pred = x_est + (dt / 6) * (k1 + 2*k2 + 2*k3 + k4);
    
    % Covarianza
    I3 = eye(3);
    
    % F correccion
    F = eye(6) + [zeros(3,3), I3; zeros(3,3), zeros(3,3)] * dt;
    
    % Propagación de la Covarianza
    P_pred = F * P * F' + Q_base * dt;
end