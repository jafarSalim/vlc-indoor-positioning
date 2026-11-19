function H = nlos_gain(p, rx, dA)
%NLOS_GAIN  First-order diffuse wall reflections (Lambertian walls, reflectivity rho).
%   Walls are cut into dA x dA patches; each patch is lit by every LED and
%   re-emits as a first-order Lambertian source toward the receiver (facing up).
if nargin < 3, dA = 0.1; end
W = p.room;
xs = dA/2:dA:W(1);  ys = dA/2:dA:W(2);  zs = dA/2:dA:W(3);
P = [];  N = [];
[a, b] = meshgrid(ys, zs);  P = [P; zeros(numel(a),1) a(:) b(:)];   N = [N; repmat([1 0 0], numel(a), 1)];
P = [P; W(1)*ones(numel(a),1) a(:) b(:)];  N = [N; repmat([-1 0 0], numel(a), 1)];
[a, b] = meshgrid(xs, zs);  P = [P; a(:) zeros(numel(a),1) b(:)];   N = [N; repmat([0 1 0], numel(a), 1)];
P = [P; a(:) W(2)*ones(numel(a),1) b(:)];  N = [N; repmat([0 -1 0], numel(a), 1)];
K = size(rx, 1);  L = size(p.led, 1);
H = zeros(K, L);
for l = 1:L
    s = [p.led(l, :) p.h_led];
    v1 = P - s;  d1 = sqrt(sum(v1.^2, 2));
    cphi = -v1(:, 3) ./ d1;                       % emission angle from the LED (pointing down)
    cin = -sum(v1 .* N, 2) ./ d1;                 % incidence on the wall
    g1 = max(cphi, 0).^p.m .* max(cin, 0) * (p.m + 1) / (2*pi) ./ d1.^2 * dA^2;   % power fraction on patch
    for k = 1:K
        v2 = rx(k, :) - P;  d2 = sqrt(sum(v2.^2, 2));
        cout = sum(v2 .* N, 2) ./ d2;             % emission from the wall
        cpsi = v2(:, 3) ./ d2 * -1;               % incidence at the receiver facing up
        ok = cpsi >= cosd(p.FOV) & cout > 0;
        H(k, l) = sum(ok .* g1 * p.rho .* cout / pi .* p.A ./ d2.^2 * p.Ts * p.g .* cpsi);
    end
end
end
