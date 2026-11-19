function h = new_figure(w, ht)
%NEW_FIGURE  Dark figure of w x ht pixels that prints with its own colours.
c = palette();
h = figure('visible', 'off', 'position', [50 50 w ht], 'color', c.bg, 'inverthardcopy', 'off');
end
