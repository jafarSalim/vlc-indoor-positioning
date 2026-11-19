function xy = est_aoa(p, rx, sigma_deg)
%EST_AOA  Angle-of-arrival positioning with an angle sensor of accuracy sigma_deg.
%   Each LED gives a position estimate led - h tan(theta) (cos az, sin az);
%   they are combined with weights 1 / var (var grows as h / cos^2 theta).
h = p.h_led - p.h_rx;
K = size(rx, 1);  L = size(p.led, 1);
xy = zeros(K, 2);
for k = 1:K
    num = [0 0];  den = 0;
    for l = 1:L
        v = [p.led(l, :) - rx(k, 1:2), h];
        th = atan2(norm(v(1:2)), v(3)) + sigma_deg * pi/180 * randn;
        az = atan2(v(2), v(1)) + sigma_deg * pi/180 * randn / max(sin(th), 0.05);
        if th > p.FOV * pi/180, continue; end
        e = p.led(l, :) - h * tan(th) * [cos(az) sin(az)];
        w = (cos(th)^2 / h)^2;
        num = num + w * e;  den = den + w;
    end
    xy(k, :) = num / max(den, eps);
end
end
