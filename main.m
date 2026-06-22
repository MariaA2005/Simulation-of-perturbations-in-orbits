% -------------------------------------------------------------------------
%% IMPORTS
% -------------------------------------------------------------------------
run("constants.m"); 
run("sensorParameters.m"); 
% -------------------------------------------------------------------------
%% DEFINITIONS
% -------------------------------------------------------------------------
 
%% Initial conditions
v_orbital = sqrt(constant.Gr * constant.m1 / constant.radio_orbita); 
state0.R10 = [0; 0; 0];                    
state0.R20 = [constant.radio_orbita; 0; 0];         
state0.V10 = [0; 0; 0];                    
state0.V20 = [0; v_orbital * cos(deg2rad(constant.inc0)); v_orbital * sin(deg2rad(constant.inc0))]; 
tf = 1*24 * 3600; 
% -------------------------------------------------------------------------
%% OBTAIN DATA
% -------------------------------------------------------------------------
%% Orbits
[t, states_m, acc] = two_body_integration(constant, state0, tf); 
[tJ2, statesJ2_m, accJ2] = two_body_integration(constant, state0, tf, J2);
[tLS, statesLS_m, accLS] = two_body_integration(constant, state0, tf, 0, true);
orbitNominal = getOrbitData(states_m, t, acc); 
orbitJ2 = getOrbitData(statesJ2_m, tJ2, accJ2);
orbitLS = getOrbitData(statesLS_m, tLS, accLS); 
%% Sensors
% -------------------------------------------------------------------------
sensorData=simulateSatSensors(gps, imu, orbitNominal); 
sensorData.imuAccel = movmean(sensorData.imuAccel, 5, 1);
% -------------------------------------------------------------------------
%% KALMAN FILTER (EKF) MULTI-RATE (Unidades: km y km/s)
% -------------------------------------------------------------------------
[R_gps, Q_base, P, H, ekf_pos,ekf_vel, acc_func, x_est]=initialiseEKF(t, state0, sensorData, gps.sigmaPos); 

% Bucle Principal del EKF
[ekf_pos, ekf_vel] = runEKF(num_steps, t, acc_func, P, Q_base, H, R_gps, x_est, sensorData, ekf_pos,ekf_vel); 

orbitEFK = getOrbitDataKF((ekf_pos'), (ekf_vel'), orbitNominal.t, sensorData.imuAccel); 
orbitGPS = getOrbitDataKF(sensorData.gpsPos, sensorData.gpsVel, orbitNominal.t, sensorData.imuAccel); 

% -------------------------------------------------------------------------
%% RECORTE DE TRANSITORIO INICIAL
% -------------------------------------------------------------------------
puntos_a_saltar = 150; 
orbitas_lista = {orbitNominal, orbitJ2, orbitLS, orbitEFK, orbitGPS, sensorData};
for i = 1:length(orbitas_lista)
    campos = fieldnames(orbitas_lista{i});
    for j = 1:length(campos)
        data_temporal = orbitas_lista{i}.(campos{j});
        if size(data_temporal, 1) == num_steps
            orbitas_lista{i}.(campos{j}) = data_temporal(puntos_a_saltar:end, :);
        elseif size(data_temporal, 2) == num_steps 
            orbitas_lista{i}.(campos{j}) = data_temporal(:, puntos_a_saltar:end);
        end
    end
end

orbitNominal = orbitas_lista{1};
orbitJ2      = orbitas_lista{2};
orbitLS      = orbitas_lista{3};
orbitEFK     = orbitas_lista{4};
orbitGPS     = orbitas_lista{5};
sensorData   = orbitas_lista{6};

% -------------------------------------------------------------------------
%% GRAFICAS
% -------------------------------------------------------------------------
plotSensorVsReal(orbitNominal, sensorData);
plotSensorError(orbitNominal, sensorData);
plot3D(orbitNominal.radius, orbitJ2.radius, orbitLS.radius, orbitEFK.radius, orbitGPS.radius); 
plotDifRadial(orbitNominal, orbitJ2, orbitLS, orbitEFK, orbitGPS); 
plotIncRadius(orbitNominal, orbitJ2, orbitLS, orbitEFK, orbitGPS);