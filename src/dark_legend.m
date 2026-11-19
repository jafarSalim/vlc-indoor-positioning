function lg = dark_legend(ax, labels, loc)
%DARK_LEGEND  Legend styled for dark panels.
c = palette();
if nargin < 3, loc = 'northeast'; end
lg = legend(ax, labels, 'location', loc);
set(lg, 'color', c.bg, 'textcolor', c.fg, 'edgecolor', c.grid, 'fontsize', 10);
end
