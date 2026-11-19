function d = make_frames()
%MAKE_FRAMES  Frames for assets/walk.gif: a person walks through the room with a
%   phone held level. Left: top view with the light pools of the four LEDs,
%   the true track, maximum likelihood (model) and fingerprint estimates, both
%   in the real room with wall reflections. Right: the four received powers.
p = vlc_params();  c = palette();
randn('seed', 9);
d = fullfile(tempdir, 'vlc_frames');
if ~exist(d, 'dir'), mkdir(d); end
old = dir(fullfile(d, '*.png'));
for k = 1:numel(old), delete(fullfile(d, old(k).name)); end
nf = 48;  t = linspace(0, 2*pi, nf + 1);  t(end) = [];
trk = [2.5 + 1.9 * sin(t).', 2.5 + 1.9 * sin(2*t).' / 1.3, p.h_rx * ones(nf, 1)];
[dbx] = test_grid(p, 0.1);
dbH = los_gain(p, dbx) + nlos_gain(p, dbx, 0.1);
[bg, gx, gy] = test_grid(p, 0.05);
P = reshape(sum(los_gain(p, bg), 2), numel(gy), numel(gx));
H = los_gain(p, trk) + nlos_gain(p, trk, 0.1);
Hm = measure_rss(p, H);
xm = est_nlls(p, Hm, est_lls(p, Hm));
xk = est_knn(dbx(:, 1:2), dbH, Hm, 4);
for f = 1:nf
    h = figure('visible', 'off', 'position', [0 0 1100 520], 'color', c.bg);
    ax = axes('position', [0.03 0.08 0.5 0.84]);
    imagesc(gx, gy, P);  axis xy equal tight;  colormap(ax, c.map);  hold on;
    plot(trk(:, 1), trk(:, 2), ':', 'color', c.white, 'linewidth', 1);
    plot(trk(1:f, 1), trk(1:f, 2), '-', 'color', c.white, 'linewidth', 2.5);
    plot(xm(1:f, 1), xm(1:f, 2), '.', 'color', c.rose, 'markersize', 12);
    plot(xk(1:f, 1), xk(1:f, 2), '.', 'color', c.mint, 'markersize', 12);
    for l = 1:4
        plot([p.led(l, 1) trk(f, 1)], [p.led(l, 2) trk(f, 2)], '-', 'color', c.amber, 'linewidth', 0.8);
    end
    plot(trk(f, 1), trk(f, 2), 'o', 'markersize', 12, 'color', c.white, 'markerfacecolor', c.white);
    plot(xm(f, 1), xm(f, 2), 's', 'markersize', 11, 'color', c.rose, 'linewidth', 2.5);
    plot(xk(f, 1), xk(f, 2), 'd', 'markersize', 11, 'color', c.mint, 'linewidth', 2.5);
    plot(p.led(:, 1), p.led(:, 2), 'p', 'markersize', 16, 'color', c.white, 'markerfacecolor', c.amber);
    set(ax, 'xtick', [], 'ytick', [], 'xcolor', c.bg, 'ycolor', c.bg, 'color', c.bg);  xlim([0 p.room(1)]);  ylim([0 p.room(2)]);
    em = 100 * norm(xm(f, :) - trk(f, 1:2));  ek = 100 * norm(xk(f, :) - trk(f, 1:2));
    title(sprintf('ML (model) %4.1f cm   |   fingerprint %4.1f cm', em, ek), 'color', c.fg, 'fontsize', 13);
    ax = axes('position', [0.62 0.14 0.34 0.72]);
    b = bar(1:4, 1e6 * p.Pt * Hm(f, :), 0.6);  set(b, 'facecolor', c.amber, 'edgecolor', 'none');
    ylim([0 1e6 * p.Pt * max(Hm(:)) * 1.05]);
    set(ax, 'xticklabel', {'LED 1', 'LED 2', 'LED 3', 'LED 4'});
    ylabel('received optical power (\muW)');
    title('one tone per LED', 'color', c.fg);
    style_axes(ax, c);
    set(h, 'inverthardcopy', 'off', 'PaperPositionMode', 'auto');
    print(h, fullfile(d, sprintf('f%03d.png', f)), '-dpng', '-r90');
    close(h);
end
end
