function [R, Q, P, H, ekf_pos,ekf_vel, acc_func, x_est] = initialiseEKF(t, state0, sensorData, sigmaPos)
num_steps = length(t);
x_est = [state0.R20/1000; state0.V20/1000]; 

R = eye(3) * (sigmaPos^2)*10^-3; 

P = blkdiag(eye(3) * 1e-6, eye(3) * 1e-9); 

Q = blkdiag(eye(3) * 1e-3, eye(3) * 1e-4); 

H = [eye(3), zeros(3, 3)];
ekf_pos = zeros(3, num_steps);
ekf_vel = zeros(3, num_steps);
ekf_pos(:, 1) = x_est(1:3);
ekf_vel(:, 1) = x_est(4:6);

acc_func = @(tiempo) interp1(t, sensorData.imuAccel, tiempo, 'linear', 'extrap');
end