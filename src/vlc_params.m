function p = vlc_params()
%VLC_PARAMS  Room, LEDs and receiver (noise model of Komine and Nakagawa, 2004).
p.room   = [5 5 3];                         % length, width, height (m)
p.led    = [1.25 1.25; 1.25 3.75; 3.75 1.25; 3.75 3.75];   % ceiling positions (x, y)
p.h_led  = 3.0;                             % LED height (m)
p.h_rx   = 0.85;                            % desk height (m)
p.Pt     = 2.0;                             % optical power per LED (W)
p.phi12  = 60;                              % LED half-power semi-angle (deg)
p.m      = -log(2) / log(cosd(p.phi12));    % Lambertian order
p.A      = 1e-4;                            % photodiode area (1 cm^2)
p.FOV    = 70;                              % receiver field of view (deg, half angle)
p.Ts     = 1;                               % optical filter gain
p.n_c    = 1.5;                             % concentrator refractive index
p.g      = p.n_c^2 / sind(p.FOV)^2;         % concentrator gain
p.R      = 0.54;                            % responsivity (A/W)
p.B      = 1e6;                             % noise bandwidth of the positioning signal (Hz)
p.q      = 1.602e-19;  p.kB = 1.381e-23;  p.TK = 295;
p.Ibg    = 5.1e-3;                          % background current (A)
p.I2     = 0.562;  p.I3 = 0.0868;
p.G_ol   = 10;  p.eta = 112e-12;  p.Gam = 1.5;  p.gm = 30e-3;   % FET preamplifier
p.rho    = 0.8;                             % wall reflectivity
end
