function r = exp1_channel()
%EXP1_CHANNEL  Received power, SNR and the share of light that comes off the walls.
p = vlc_params();  c = palette();
[rx, gx, gy] = test_grid(p, 0.05);
Hl = los_gain(p, rx);
Hn = nlos_gain(p, rx, 0.1);
Pr = p.Pt * sum(Hl, 2);
snr = 10*log10((p.R * p.Pt * Hl).^2 ./ noise_var(p, p.Pt * Hl));
ratio = sum(Hn, 2) ./ sum(Hl, 2);
sz = [numel(gy) numel(gx)];
h = new_figure(1700, 560);
ax = subplot(1, 3, 1);
imagesc(gx, gy, reshape(10*log10(Pr) + 30, sz));  axis xy equal tight;  colormap(ax, c.map);
cb = colorbar;  set(cb, 'color', c.muted);  hold on;
plot(p.led(:, 1), p.led(:, 2), 'p', 'markersize', 18, 'color', c.white, 'markerfacecolor', c.amber);
xlabel('x (m)');  ylabel('y (m)');
title(sprintf('Line-of-sight power, dBm (%.1f to %.1f)', min(10*log10(Pr) + 30), max(10*log10(Pr) + 30)));
style_axes(ax, c);
ax = subplot(1, 3, 2);
imagesc(gx, gy, reshape(min(snr, [], 2), sz));  axis xy equal tight;  colormap(ax, c.map);
cb = colorbar;  set(cb, 'color', c.muted);  hold on;
plot(p.led(:, 1), p.led(:, 2), 'p', 'markersize', 18, 'color', c.white, 'markerfacecolor', c.amber);
xlabel('x (m)');  ylabel('y (m)');
title(sprintf('Weakest LED: SNR in %g MHz, dB', p.B / 1e6));
style_axes(ax, c);
ax = subplot(1, 3, 3);
imagesc(gx, gy, reshape(100 * ratio, sz));  axis xy equal tight;  colormap(ax, c.map);
cb = colorbar;  set(cb, 'color', c.muted);  hold on;
plot(p.led(:, 1), p.led(:, 2), 'p', 'markersize', 18, 'color', c.white, 'markerfacecolor', c.amber);
xlabel('x (m)');  ylabel('y (m)');
title(sprintf('Wall reflections / direct light, %% (%.0f to %.0f)', 100*min(ratio), 100*max(ratio)));
style_axes(ax, c);
save_figure(h, 'fig1_channel');
r.Pr_dBm = [min(Pr) max(Pr)];  r.Pr_dBm = 10*log10(r.Pr_dBm) + 30;
r.snr = [min(min(snr, [], 2)) max(max(snr, [], 2))];
r.ratio = [min(ratio) median(ratio) max(ratio)];
write_csv('exp1_channel_summary', 'Pr_min_dBm,Pr_max_dBm,snr_min_dB,snr_max_dB,nlos_ratio_min,nlos_ratio_median,nlos_ratio_max', [r.Pr_dBm r.snr r.ratio]);
end
