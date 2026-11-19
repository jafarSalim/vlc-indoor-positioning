function c = palette()
%PALETTE  "Daylight" colours: warm LED white and amber on a deep indigo room.
c.bg     = [0.07 0.06 0.13];
c.panel  = [0.10 0.09 0.18];
c.fg     = [0.97 0.95 0.90];
c.grid   = [0.26 0.24 0.38];
c.muted  = [0.66 0.63 0.76];
c.amber  = [1.00 0.71 0.20];
c.white  = [1.00 0.96 0.85];
c.rose   = [1.00 0.40 0.55];
c.cyan   = [0.30 0.85 1.00];
c.mint   = [0.40 0.95 0.65];
c.violet = [0.70 0.55 1.00];
c.meth   = {c.amber, c.rose, c.cyan, c.mint, c.violet};
c.lw     = 2.4;
k = [0 0.07 0.06 0.13; 0.2 0.25 0.10 0.40; 0.45 0.75 0.20 0.45; 0.7 1.00 0.55 0.25; 0.88 1.00 0.85 0.45; 1 1.00 0.99 0.90];
x = linspace(0, 1, 256)';
c.map = [interp1(k(:,1),k(:,2),x) interp1(k(:,1),k(:,3),x) interp1(k(:,1),k(:,4),x)];
end
