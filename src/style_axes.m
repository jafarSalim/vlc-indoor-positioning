function style_axes(ax, c)
%STYLE_AXES  Dark "reef" look for an axes.
if nargin < 2, c = palette(); end
set(ax, 'color', c.panel, 'xcolor', c.muted, 'ycolor', c.muted, 'gridcolor', c.grid, ...
    'fontsize', 11, 'linewidth', 1, 'box', 'on');
grid(ax, 'on');
t = get(ax, 'title');  set(t, 'color', c.fg, 'fontweight', 'bold', 'fontsize', 12.5);
set(get(ax, 'xlabel'), 'color', c.fg, 'fontsize', 11.5);
set(get(ax, 'ylabel'), 'color', c.fg, 'fontsize', 11.5);
end
