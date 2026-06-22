function sensorData = simulateSatSensors(gps, imu, orbitData)
    N = orbitData.n;
   
    if isfield(gps, 'step')
        gps_step = gps.step;
    else
        gps_step = 20; % Se actualiza cada 10 pasos por defecto
    end
    
    % Inicializamos matrices normales (sin NaNs)
    sensorData.gpsPos = zeros(N, 3);
    sensorData.gpsVel = zeros(N, 3);
    sensorData.gpsNewData = false(N, 1); % <--- BANDERA BOOLEANA PARA EL EKF
    
    % Primer dato inicial
    current_pos = orbitData.radius(1, :) + gps.sigmaPos * randn(1, 3);
    current_vel = orbitData.vel(1, :) + gps.sigmaVel * randn(1, 3);
    
    % Bucle para simular el comportamiento del GPS (Sample & Hold)
    for k = 1:N
        if mod(k-1, gps_step) == 0
            % Solo aquí se genera un dato NUEVO del GPS
            current_pos = orbitData.radius(k, :) + gps.sigmaPos * randn(1, 3);
            current_vel = orbitData.vel(k, :) + gps.sigmaVel * randn(1, 3);
            sensorData.gpsNewData(k) = true; % Avisamos que este dato es fresco
        end
        % El resto del tiempo el sensor mantiene el valor anterior
        sensorData.gpsPos(k, :) = current_pos;
        sensorData.gpsVel(k, :) = current_vel;
    end
    
    % ---------------------------------------------------------------------
    % EL RESTO DE LA IMU SE QUEDA IGUAL
    % ---------------------------------------------------------------------
    accel_random_walk = cumsum(imu.biasAcc * randn(N, 3));
    sensorData.imuAccel = orbitData.acc + imu.sigmaAcc * randn(N, 3) + accel_random_walk;
    
    gyro_random_walk = cumsum(imu.biasGyro * randn(N, 3));
    gyro_base = repmat(imu.omega, N, 1);
    sensorData.imuGyro = gyro_base + imu.sigmaGyro * randn(N, 3) + gyro_random_walk;
end