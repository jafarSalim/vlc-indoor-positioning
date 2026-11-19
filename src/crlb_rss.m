function s = crlb_rss(p, rx)
%CRLB_RSS  Cramer-Rao bound (RMS position error, m) for RSS positioning at points rx.
%   FIM = sum_l (d mu_l / d theta)(d mu_l / d theta)' / sigma_l^2, mu_l = R Pt H_l.
K = size(rx, 1);  s = zeros(K, 1);  e = 1e-5;
H0 = los_gain(p, rx);
Hx = (los_gain(p, rx + [e 0 0]) - H0) / e;
Hy = (los_gain(p, rx + [0 e 0]) - H0) / e;
for k = 1:K
    w = (p.R * p.Pt)^2 ./ noise_var(p, p.Pt * H0(k, :));
    F = [sum(w .* Hx(k, :).^2) sum(w .* Hx(k, :) .* Hy(k, :)); ...
         sum(w .* Hx(k, :) .* Hy(k, :)) sum(w .* Hy(k, :).^2)];
    s(k) = sqrt(trace(inv(F)));
end
end
