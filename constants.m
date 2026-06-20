constant.Gr = 6.6743e-11;      
constant.m1 = 5.972e24;        
constant.m2 = 4;  
constant.altitude = 500e3;
constant.Re = 6378137; 
constant.radio_orbita = constant.Re+constant.altitude; 
constant.inc0=97.4; 
%%  Perturbations
J2 =  1.08263e-3;
constant.mu_sun  = 1.32712440018e20; % Sun gravitational parameter [m^3/s^2]
constant.mu_moon = 4.9027779e12;     % Moon gravitational parameter [m^3/s^2]
constant.earthInc=23.4; 
constant.dist_sun  = 1.496e11;       % Average Earth-Sun distance (1 AU) [m]
constant.dist_moon = 3.844e8;        % Average Earth-Moon distance [m]