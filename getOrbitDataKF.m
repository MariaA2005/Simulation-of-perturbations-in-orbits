function orbitData =  getOrbitDataKF(radius, vel, t, acc)
    orbitData.t= t; 
    orbitData.acc =acc; 
    orbitData.radius = radius; 
    orbitData.radiusNorm = vecnorm(orbitData.radius, 2, 2);
    orbitData.vel = vel; 
     orbitData.velNorm = vecnorm(orbitData.vel, 2, 2);
    orbitData.n = length(t);
    orbitData.inc= zeros(orbitData.n, 1);
    orbitData.hVec   = zeros(orbitData.n, 3);
    for i = 1: orbitData.n
     orbitData.hVec(i, :) = cross(orbitData.radius(i,:), orbitData.vel(i,:));
     orbitData.inc(i) = rad2deg(acos(orbitData.hVec(i, 3) / norm(orbitData.hVec(i, :))));
    end

end