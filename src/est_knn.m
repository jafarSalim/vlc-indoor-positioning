function xy = est_knn(db_xy, db_H, Hm, k)
%EST_KNN  Fingerprinting: weighted k nearest neighbours in log-RSS space.
if nargin < 4, k = 4; end
F = log10(max(db_H, 1e-12));
Q = log10(max(Hm, 1e-12));
xy = zeros(size(Hm, 1), 2);
for i = 1:size(Hm, 1)
    d = sqrt(sum((F - Q(i, :)).^2, 2));
    [ds, j] = sort(d);
    w = 1 ./ (ds(1:k) + 1e-6);
    xy(i, :) = (w.' * db_xy(j(1:k), :)) / sum(w);
end
end
