function plotSensorVsReal(orbitData, sensorData)
    % Tiempo en horas para que el eje X sea más intuitivo
    t_hrs = orbitData.t / 3600;
    
    % Crear figura con fondo blanco y buen tamaño
    figure('Name', 'Comparativa: Datos Reales vs Sensores', ...
           'Color', 'w', 'Position', [100, 100, 900, 700]);
       
    % ---------------------------------------------------------------------
    % SUBPLOT 1: POSICIÓN (Eje X) - Real (km) vs GPS (convertido a km)
    % ---------------------------------------------------------------------
    subplot(2, 2, 1);
    plot(t_hrs, orbitData.radius(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t_hrs, sensorData.gpsPos(:,1), 'r.', 'MarkerSize', 4);
    grid on;
    title('Posición Orbital (Componente X)');
    xlabel('Tiempo (horas)');
    ylabel('Posición (km)');
    legend('Real (Órbita)', 'Medición GPS', 'Location', 'best');
    
    % ---------------------------------------------------------------------
    % SUBPLOT 2: VELOCIDAD (Eje X) - Real (km/s) vs GPS (convertido a km/s)
    % ---------------------------------------------------------------------
    subplot(2, 2, 2);
    plot(t_hrs, orbitData.vel(:,1), 'b', 'LineWidth', 2);
    hold on;
    plot(t_hrs, sensorData.gpsVel(:,1), 'r.', 'MarkerSize', 4);
    grid on;
    title('Velocidad Orbital (Componente X)');
    xlabel('Tiempo (horas)');
    ylabel('Velocidad (km/s)');
    legend('Real (Órbita)', 'Medición GPS', 'Location', 'best');
    
    % ---------------------------------------------------------------------
    % SUBPLOT 3: ACELERÓMETRO IMU (Eje X) - Real (m/s²) vs IMU (m/s²)
    % ---------------------------------------------------------------------
    subplot(2, 2, 3);
    plot(t_hrs, orbitData.acc(:,1), 'b', 'LineWidth', 1.5);
    hold on;
    plot(t_hrs, sensorData.imuAccel(:,1), 'g', 'MarkerSize', 2);
    grid on;
    title('Acelerómetro de la IMU (Componente X)');
    xlabel('Tiempo (horas)');
    ylabel('Aceleración (m/s^2)');
    legend('Real (Física)', 'Lectura IMU', 'Location', 'best');
    
    % ---------------------------------------------------------------------
    % SUBPLOT 4: GIROSCOPIO IMU (Eje Z) - Real (rad/s) vs IMU (rad/s)
    % ---------------------------------------------------------------------
    subplot(2, 2, 4);
    % Reconstruimos el vector de la velocidad angular real usada en la simulación (0.02 rad/s)
    omega_z_real = ones(size(t_hrs)) * 0.02; 
    
    plot(t_hrs, omega_z_real, 'b', 'LineWidth', 2);
    hold on;
    plot(t_hrs, sensorData.imuGyro(:,3), 'g');
    grid on;
    title('Giroscopio de la IMU (Eje Z)');
    xlabel('Tiempo (horas)');
    ylabel('Velocidad Angular (rad/s)');
    legend('Real (Rotación)', 'Lectura IMU', 'Location', 'best');
    
    % Ajustar espaciado entre gráficas automáticamente
    sgtitle('Simulación de Telemetría de Sensores a Bordo', 'FontSize', 14, 'FontWeight', 'bold');
end