function r = exp2_methods()
%EXP2_METHODS  Error maps of four positioning methods, with and without wall reflections.
%   Model-based methods (trilateration, ML, AOA) assume line of sight only.
%   Fingerprinting uses a survey database measured in the same room on a
%   10 cm grid, averaged over 20 readings per point.
p = vlc_params();  c = palette();
randn('seed', 3);  rand('seed', 3);
[rx, gx, gy] = test_grid(p, 0.2);
K = size(rx, 1);  trials = 10;
Hl = los_gain(p, rx);  Hn = nlos_gain(p, rx, 0.1);
[dbx, dgx, dgy] = test_grid(p, 0.1);
dbL = los_gain(p, dbx);  dbN = nlos_gain(p, dbx, 0.1);
names = {'RSS trilateration', 'RSS maximum likelihood', 'AOA (1 deg sensor)', 'Fingerprint k-NN (k = 4)'};
E = zeros(K, 4, 2);  allerr = cell(4, 2);
for env = 1:2                                     % 1 = line of sight only, 2 = with reflections
    Htrue = Hl + (env == 2) * Hn;
    % the survey is done in the same room as the test (20 readings per point)
    dbHm = zeros(size(dbL));
    for t = 1:20, dbHm = dbHm + measure_rss(p, dbL + (env == 2) * dbN) / 20; end
    e2 = zeros(K, 4);  ae = cell(1, 4);
    for t = 1:trials
        Hm = measure_rss(p, Htrue);
        x1 = est_lls(p, Hm);
        x2 = est_nlls(p, Hm, x1);
        x3 = est_aoa(p, rx, 1);
        x4 = est_knn(dbx(:, 1:2), dbHm, Hm, 4);
        X = {x1, x2, x3, x4};
        for m = 1:4
            d = sqrt(sum((X{m} - rx(:, 1:2)).^2, 2));
            e2(:, m) = e2(:, m) + d.^2 / trials;
            ae{m} = [ae{m}; d];
        end
    end
    E(:, :, env) = sqrt(e2);
    allerr(:, env) = ae.';
end
crb = crlb_rss(p, rx);
sz = [numel(gy) numel(gx)];
h = new_figure(1800, 900);
for env = 1:2
    for m = 1:4
        ax = subplot(2, 4, (env - 1) * 4 + m);
        imagesc(gx, gy, reshape(100 * E(:, m, env), sz));  axis xy equal tight;
        colormap(ax, c.map);  caxis([0 30]);  hold on;
        plot(p.led(:, 1), p.led(:, 2), 'p', 'markersize', 13, 'color', c.white, 'markerfacecolor', c.amber);
        if env == 1, ttl = 'direct light only'; else, ttl = 'with wall reflections'; end
        title({names{m}, sprintf('%s: mean %.1f cm', ttl, 100 * mean(E(:, m, env)))});
        style_axes(ax, c);  set(ax, 'xtick', 0:1:5, 'ytick', 0:1:5);
        if m == 4, cb = colorbar;  set(cb, 'color', c.muted);  ylabel(cb, 'RMS error (cm)'); end
    end
end
save_figure(h, 'fig2_error_maps');
% CDF figure
h = new_figure(1500, 560);
for env = 1:2
    ax = subplot(1, 2, env);  hold on;
    for m = 1:4
        d = sort(allerr{m, env});
        plot(100 * d, (1:numel(d)) / numel(d), 'color', c.meth{m}, 'linewidth', c.lw);
    end
    plot(100 * sort(crb), (1:K) / K, '--', 'color', c.white, 'linewidth', 1.6);
    set(ax, 'xscale', 'log');  xlim([0.05 100]);  ylim([0 1]);
    xlabel('position error (cm)');  ylabel('CDF');
    if env == 1, title('Direct light only'); else, title('With first-order wall reflections (\rho = 0.8)'); end
    style_axes(ax, c);
    dark_legend(ax, [names, {'Cramer-Rao bound (RSS)'}], 'northwest');
end
save_figure(h, 'fig3_error_cdf');
r.names = names;
for env = 1:2
    for m = 1:4
        d = allerr{m, env};
        r.tab(m, :, env) = [100*mean(d) 100*median(d) 100*prctile_(d, 90)];
    end
end
r.crb = 100 * [mean(crb) median(crb) max(crb)];
write_csv('exp2_errors_los', 'method,mean_cm,median_cm,p90_cm', [(1:4).' r.tab(:, :, 1)]);
write_csv('exp2_errors_nlos', 'method,mean_cm,median_cm,p90_cm', [(1:4).' r.tab(:, :, 2)]);
end

function q = prctile_(x, pc)
x = sort(x(:));  q = x(max(1, round(pc / 100 * numel(x))));
end
