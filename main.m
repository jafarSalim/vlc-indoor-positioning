%MAIN  Runs every VLC positioning experiment and writes figures/ and results/.
%   Works in MATLAB (R2016b or newer, no toolboxes) and GNU Octave (6 or newer).
clear; close all;
here = fileparts(mfilename('fullpath'));
if isempty(here), here = pwd; end
addpath(fullfile(here, 'src'), fullfile(here, 'experiments'));
t0 = tic;
r1 = exp1_channel();
r2 = exp2_methods();
r3 = exp3_power();
r4 = exp4_robustness();
make_frames();
fid = fopen(fullfile(here, 'results', 'summary.txt'), 'w');
fprintf(fid, 'Received LOS power %.1f to %.1f dBm; per-LED SNR %.1f to %.1f dB; reflections/direct min %.3f median %.3f max %.3f\n', r1.Pr_dBm, r1.snr, r1.ratio);
for env = 1:2
    fprintf(fid, 'Errors (%s) [mean median p90] cm:\n', ternary(env == 1, 'direct only', 'with reflections'));
    for m = 1:4, fprintf(fid, '  %-26s %s\n', r2.names{m}, mat2str(r2.tab(m, :, env), 3)); end
end
fprintf(fid, 'CRLB [mean median max] cm: %s\n', mat2str(r2.crb, 3));
fprintf(fid, 'Power sweep [Pt lls ml crlb] (m):\n%s\n', mat2str(r3.out, 3));
fprintf(fid, 'Tilt %s deg -> RMSE [lls ml knn] m:\n%s\n', mat2str(r4.tilts), mat2str(r4.T, 3));
fprintf(fid, 'Height error %s m -> RMSE [lls ml knn] m:\n%s\n', mat2str(r4.dh), mat2str(r4.D, 3));
fprintf(fid, 'Run time: %.0f s\n', toc(t0));
fclose(fid);
type(fullfile(here, 'results', 'summary.txt'));
