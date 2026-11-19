function save_figure(h, name)
%SAVE_FIGURE  Save a figure as a 200-dpi PNG in figures/ (works in MATLAB and Octave).
here = fileparts(mfilename('fullpath'));
out = fullfile(here, '..', 'figures');
if ~exist(out, 'dir'), mkdir(out); end
set(h, 'PaperPositionMode', 'auto');
print(h, fullfile(out, [name '.png']), '-dpng', '-r200');
close(h);
end
