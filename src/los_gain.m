function H = los_gain(p, rx, nrm)
%LOS_GAIN  Line-of-sight DC gain from every LED to receivers at rx (K x 3).
%   nrm: receiver normals (K x 3, default facing up). Returns K x nLED.
%   H = (m+1) A / (2 pi d^2) cos^m(phi) Ts g cos(psi), 0 outside the FOV.
K = size(rx, 1);  L = size(p.led, 1);
if nargin < 3, nrm = repmat([0 0 1], K, 1); end
H = zeros(K, L);
for l = 1:L
    v = [p.led(l, 1) - rx(:, 1), p.led(l, 2) - rx(:, 2), p.h_led - rx(:, 3)];
    d = sqrt(sum(v.^2, 2));
    cphi = v(:, 3) ./ d;                          % LED points down
    cpsi = sum(v .* nrm, 2) ./ d;                 % incidence at the receiver
    ok = cpsi >= cosd(p.FOV) & cpsi > 0;
    H(:, l) = ok .* (p.m + 1) * p.A ./ (2*pi*d.^2) .* cphi.^p.m * p.Ts * p.g .* cpsi;
end
end
