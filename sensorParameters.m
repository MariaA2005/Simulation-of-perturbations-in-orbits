
% GPS
gps.sigmaPos = 0.002;   % Desviación estándar: 5 metros (0.005 km)
gps.sigmaVel = 0.00005; % Desviación estándar: 0.05 m/s (0.00005 km/s)

% Acc IMU
imu.noise = 150; 
imu.BW=8; 
imu.sigmaAcc = imu.noise*sqrt(imu.BW)*9.80665e-9;   %white noise in SI
imu.biasAcc = 80* 0.00981/1000; 
% Giro IMU
imu.sigmaGyro = 0.1;     % white noise
imu.biasGyro = 1;%grado por segundo
imu.omega= [0, 0, 0];
    
   
