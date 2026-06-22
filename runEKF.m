function [ekf_pos, ekf_vel] = runEKF(num_steps, t, acc_func, P, Q_base,H, R_gps, x_est, sensorData, ekf_pos, ekf_vel)
    for k = 2:num_steps
        
        dt = t(k) - t(k-1); 
        
        % --- PASO DE PREDICCIÓN ---    
        [x_pred, P_pred] = predictEKF(t, dt, acc_func, P, Q_base, x_est, k); 
        % --- PASO DE ACTUALIZACIÓN ---
         [x_est, P] = actualiseEKF(sensorData, H, P_pred, R_gps, x_pred, k); 
        
        % --- GUARDAR RESULTADOS ---
        ekf_pos(:, k) = x_est(1:3);
        ekf_vel(:, k) = x_est(4:6);
    end
end