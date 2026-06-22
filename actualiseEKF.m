function [x_est, P] = actualiseEKF(sensorData, H, P_pred, R_gps, x_pred, k)
z_k = sensorData.gpsPos(k, :)'; 
    
    if sensorData.gpsNewData(k)
        % Innovación
        y_k = z_k - H * x_pred;
        
        % s
        S = H * P_pred * H' + R_gps;
        
        % ganancia K
        K = P_pred * H' / S ; 
        
        % Actualizar
        x_est = x_pred + K * y_k;
        P = (eye(6) - K * H) * P_pred;
    else
        x_est = x_pred;
        P = P_pred;
    end