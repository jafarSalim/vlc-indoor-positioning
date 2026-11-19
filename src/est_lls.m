function xy = est_lls(p, Hm)
%EST_LLS  RSS trilateration: invert the Lambertian model to a distance per LED
%   (receiver assumed level, height known), then linear least squares.
%   The result is clipped to the room: a lost LED (out of the field of view)
%   would otherwise send the estimate kilometres away.
h = p.h_led - p.h_rx;
C = (p.m + 1) * p.A * p.Ts * p.g / (2*pi);
d = (C * h^(p.m + 1) ./ max(Hm, 1e-12)).^(1 / (p.m + 3));
r2 = max(d.^2 - h^2, 0);
L = p.led;
A = 2 * (L(2:end, :) - L(1, :));
K = size(Hm, 1);  xy = zeros(K, 2);
for k = 1:K
    b = r2(k, 1) - r2(k, 2:end).' + sum(L(2:end, :).^2, 2) - sum(L(1, :).^2);
    xy(k, :) = min(max((A \ b).', 0), p.room(1:2));
end
end
