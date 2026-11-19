function xy = est_nlls(p, Hm, x0)
%EST_NLLS  Maximum likelihood on the received currents (Gauss-Newton),
%   weighted by the shot + thermal noise of each LED, started from x0.
K = size(Hm, 1);  xy = x0;  e = 1e-4;
for k = 1:K
    x = x0(k, :);
    for it = 1:12
        rx = [x p.h_rx];
        f0 = los_gain(p, rx);
        J = [(los_gain(p, rx + [e 0 0]) - f0) / e; (los_gain(p, rx + [0 e 0]) - f0) / e].';
        w = (p.R * p.Pt)^2 ./ noise_var(p, p.Pt * max(f0, 1e-12));
        r = (Hm(k, :) - f0).';
        W = diag(w);
        dx = (J.' * W * J + 1e-9 * eye(2)) \ (J.' * W * r);
        x = x + dx.';
        x = min(max(x, 0), p.room(1:2));
        if norm(dx) < 1e-6, break; end
    end
    xy(k, :) = x;
end
end
