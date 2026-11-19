function s2 = noise_var(p, Pr)
%NOISE_VAR  Shot + thermal noise variance (A^2) for received optical power Pr (W).
shot = 2 * p.q * p.R * Pr * p.B + 2 * p.q * p.Ibg * p.I2 * p.B;
th = 8*pi*p.kB*p.TK / p.G_ol * p.eta * p.A * p.I2 * p.B^2 + ...
     16*pi^2*p.kB*p.TK * p.Gam / p.gm * p.eta^2 * p.A^2 * p.I3 * p.B^3;
s2 = shot + th;
end
