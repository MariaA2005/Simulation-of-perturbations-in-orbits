function sensorData = simulateSatSensors(gps, imu, orbitData)
    N = orbitData.n;
   
   
    sensorData.gpsPos = orbitData.radius + gps.sigmaPos * randn(N, 3);
    sensorData.gpsVel = orbitData.vel + gps.sigmaVel * randn(N, 3);
    
  
    accel_random_walk = cumsum(imu.biasAcc * randn(N, 3));
    sensorData.imuAccel = orbitData.acc + imu.sigmaAcc * randn(N, 3) + accel_random_walk;
    
   
    gyro_random_walk = cumsum(imu.biasGyro * randn(N, 3));
    gyro_base = repmat(imu.omega, N, 1);
    sensorData.imuGyro = gyro_base + imu.sigmaGyro * randn(N, 3) + gyro_random_walk;
end