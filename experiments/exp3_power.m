function r = exp3_power()
%EXP3_POWER  Accuracy vs LED power: the estimators against the Cramer-Rao bound.
%   Line of sight only, so the only error is noise.
p0 = vlc_params();  c = palette();
randn('seed', 4);
rx = test_grid(p0, 0.25);
Pt = [0.05 0.1 0.2 0.5 1 2 5 10];
out = zeros(numel(Pt), 4);
for i = 1:numel(Pt)
    p = p0;  p.Pt = Pt(i);
    H = los_gain(p, rx);
    e1 = [];  e2 = [];
    for t = 1:8
        Hm = measure_rss(p, H);
        x1 = est_lls(p, Hm);  x2 = est_nlls(p, Hm, x1);
        e1 = [e1; sum((x1 - rx(:, 1:2)).^2, 2)];
        e2 = [e2; sum((x2 - rx(:, 1:2)).^2, 2)];
    end
    cr = crlb_rss(p, rx);
    out(i, :) = [Pt(i) sqrt(mean(e1)) sqrt(mean(e2)) sqrt(mean(cr.^2))];
end
h = new_figure(900, 600);
ax = axes();
loglog(Pt, 100 * out(:, 4), '-', 'color', c.white, 'linewidth', 3);  hold on;
loglog(Pt, 100 * out(:, 2), 'o-', 'color', c.amber, 'markerfacecolor', c.amber, 'linewidth', 2);
loglog(Pt, 100 * out(:, 3), 's-', 'color', c.rose, 'markerfacecolor', c.rose, 'linewidth', 2);
xlabel('optical power per LED (W)');  ylabel('RMS position error (cm)');
title('Noise-limited accuracy (direct light only)');
style_axes(ax, c);
dark_legend(ax, {'Cramer-Rao bound', 'RSS trilateration', 'RSS maximum likelihood'}, 'northeast');
save_figure(h, 'fig4_power_vs_crlb');
write_csv('exp3_power', 'Pt_W,rmse_lls_m,rmse_ml_m,crlb_m', out);
r.out = out;
end
