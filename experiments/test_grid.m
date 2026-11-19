function [rx, gx, gy] = test_grid(p, step)
%TEST_GRID  Receiver positions on the desk plane (0.1 m from the walls).
if nargin < 2, step = 0.2; end
gx = 0.1:step:p.room(1) - 0.1;  gy = 0.1:step:p.room(2) - 0.1;
[X, Y] = meshgrid(gx, gy);
rx = [X(:) Y(:) p.h_rx * ones(numel(X), 1)];
end
