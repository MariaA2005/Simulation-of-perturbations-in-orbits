function plotSensorError(orbitData, sensorData)
    % Tiempo en horas para que el eje X sea más intuitivo
    t_hrs = orbitData.t / 3600;
    
    % Crear figura con fondo blanco y buen tamaño
    figure('Name', 'Análisis de Errores: Diferencia Sensor vs Real', ...
           'Color', 'w', 'Position', [100, 100, 900, 700]);
       
    % ---------------------------------------------------------------------
    % SUBPLOT 1: ERROR DE POSICIÓN GPS (Convertido a metros)
    % ---------------------------------------------------------------------
    subplot(2, 2, 1);
    % Multiplicamos por 1000 para pasar la diferencia de km a metros
    error_pos = (sensorData.gpsPos(:,1) - orbitData.radius(:,1)) * 1000;
    
    plot(t_hrs, error_pos, 'r', 'LineWidth', 1);
    grid on;
    title('Error de Posición GPS (Componente X)');
    xlabel('Tiempo (horas)');
    ylabel('Error (metros)');
    legend('Error (GPS - Real)', 'Location', 'best');
    
    % ---------------------------------------------------------------------
    % SUBPLOT 2: ERROR DE VELOCIDAD GPS (Convertido a m/s)
    % ---------------------------------------------------------------------
    subplot(2, 2, 2);
    % Multiplicamos por 1000 para pasar de km/s a m/s
    error_vel = (sensorData.gpsVel(:,1) - orbitData.vel(:,1)) * 1000;
    
    plot(t_hrs, error_vel, 'r', 'LineWidth', 1);
    grid on;
    title('Error de Velocidad GPS (Componente X)');
    xlabel('Tiempo (horas)');
    ylabel('Error (m/s)');
    legend('Error (GPS - Real)', 'Location', 'best');
    
    % ---------------------------------------------------------------------
    % SUBPLOT 3: ERROR DEL ACELERÓMETRO IMU (m/s²)
    % ---------------------------------------------------------------------
    subplot(2, 2, 3);
    error_acc = sensorData.imuAccel(:,1) - orbitData.acc(:,1);
    
    plot(t_hrs, error_acc, 'g', 'LineWidth', 1);
    grid on;
    title('Error del Acelerómetro de la IMU (Componente X)');
    xlabel('Tiempo (horas)');
    ylabel('Error (m/s^2)');
    legend('Error (IMU - Real)', 'Location', 'best');
    
    % ---------------------------------------------------------------------
    % SUBPLOT 4: ERROR DEL GIROSCOPIO IMU (rad/s)
    % ---------------------------------------------------------------------
    subplot(2, 2, 4);
    % Restamos el valor nominal de rotación (0.02 rad/s) para aislar el error
    error_gyro = sensorData.imuGyro(:,3) - 0.02; 
    
    plot(t_hrs, error_gyro, 'g', 'LineWidth', 1);
    grid on;
    title('Error del Giroscopio de la IMU (Eje Z)');
    xlabel('Tiempo (horas)');
    ylabel('Error (rad/s)');
    legend('Error (IMU - Real)', 'Location', 'best');
    
    % Ajustar espaciado entre gráficas automáticamente
    sgtitle('Análisis de Residuos y Errores de los Sensores a Bordo', 'FontSize', 14, 'FontWeight', 'bold');
end