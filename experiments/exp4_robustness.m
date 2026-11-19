function r = exp4_robustness()
%EXP4_ROBUSTNESS  What the model assumes: a level receiver at a known height.
%   (a) the phone is tilted by up to 20 deg in a random direction;
%   (b) the receiver height is wrong by up to 20 cm (hand-held vs desk).
p = vlc_params();  c = palette();
randn('seed', 5);  rand('seed', 5);
rx = test_grid(p, 0.25);
K = size(rx, 1);
[dbx] = test_grid(p, 0.1);
dbH = los_gain(p, dbx);
tilts = [0 2 5 10 15 20];
T = zeros(numel(tilts), 3);
for i = 1:numel(tilts)
    e = zeros(K, 3);
    for t = 1:5
        az = 2*pi*rand(K, 1);
        nrm = [sind(tilts(i)) * cos(az), sind(tilts(i)) * sin(az), cosd(tilts(i)) * ones(K, 1)];
        Hm = measure_rss(p, los_gain(p, rx, nrm));
        x1 = est_lls(p, Hm);  x2 = est_nlls(p, Hm, x1);  x4 = est_knn(dbx(:, 1:2), dbH, Hm, 4);
        e = e + [sum((x1 - rx(:,1:2)).^2, 2) sum((x2 - rx(:,1:2)).^2, 2) sum((x4 - rx(:,1:2)).^2, 2)] / 5;
    end
    T(i, :) = sqrt(mean(e));
end
dh = [-0.2 -0.1 -0.05 0 0.05 0.1 0.2];
D = zeros(numel(dh), 3);
for i = 1:numel(dh)
    rr = rx;  rr(:, 3) = p.h_rx + dh(i);
    e = zeros(K, 3);
    for t = 1:5
        Hm = measure_rss(p, los_gain(p, rr));
        x1 = est_lls(p, Hm);  x2 = est_nlls(p, Hm, x1);  x4 = est_knn(dbx(:, 1:2), dbH, Hm, 4);
        e = e + [sum((x1 - rx(:,1:2)).^2, 2) sum((x2 - rx(:,1:2)).^2, 2) sum((x4 - rx(:,1:2)).^2, 2)] / 5;
    end
    D(i, :) = sqrt(mean(e));
end
h = new_figure(1500, 560);
ax = subplot(1, 2, 1);  hold on;
cols = {c.amber, c.rose, c.mint};
for m = 1:3, plot(tilts, 100 * T(:, m), 'o-', 'color', cols{m}, 'markerfacecolor', cols{m}, 'linewidth', 2.2); end
xlabel('receiver tilt (deg, random direction)');  ylabel('RMS error (cm)');
title('A tilted phone breaks the RSS model');
style_axes(ax, c);  dark_legend(ax, {'trilateration', 'maximum likelihood', 'fingerprint k-NN'}, 'northwest');
ax = subplot(1, 2, 2);  hold on;
for m = 1:3, plot(100 * dh, 100 * D(:, m), 'o-', 'color', cols{m}, 'markerfacecolor', cols{m}, 'linewidth', 2.2); end
xlabel('height error (cm, + = receiver higher than assumed)');  ylabel('RMS error (cm)');
title('Height mismatch');
style_axes(ax, c);
save_figure(h, 'fig5_robustness');
write_csv('exp4_tilt', 'tilt_deg,rmse_lls_m,rmse_ml_m,rmse_knn_m', [tilts.' T]);
write_csv('exp4_height', 'height_error_m,rmse_lls_m,rmse_ml_m,rmse_knn_m', [dh.' D]);
r.T = T;  r.D = D;  r.tilts = tilts;  r.dh = dh;
end
