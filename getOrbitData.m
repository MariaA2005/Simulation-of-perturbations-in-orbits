function orbitData =  getOrbitData(states_m, t, acc)
    orbitData.t= t; 
    orbitData.acc =acc; 
    orbitData.radius = (states_m(:, 7:9) - states_m(:, 1:3)) / 1000;
    orbitData.radiusNorm = vecnorm(orbitData.radius, 2, 2);
    orbitData.vel = (states_m(:, 10:12) - states_m(:, 4:6)) / 1000;
     orbitData.velNorm = vecnorm(orbitData.vel, 2, 2);
    orbitData.n = length(t);
    orbitData.inc= zeros(orbitData.n, 1);
    orbitData.hVec   = zeros(orbitData.n, 3);
    for i = 1: orbitData.n
     orbitData.hVec(i, :) = cross(orbitData.radius(i,:), orbitData.vel(i,:));
     orbitData.inc(i) = rad2deg(acos(orbitData.hVec(i, 3) / norm(orbitData.hVec(i, :))));
    end

end