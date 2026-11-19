function write_csv(name, header, data)
%WRITE_CSV  Write a numeric matrix with a header line to results/<name>.csv.
here = fileparts(mfilename('fullpath'));
out = fullfile(here, '..', 'results');
if ~exist(out, 'dir'), mkdir(out); end
fid = fopen(fullfile(out, [name '.csv']), 'w');
fprintf(fid, '%s\n', header);
fmt = [repmat('%.6g,', 1, size(data, 2) - 1) '%.6g\n'];
fprintf(fid, fmt, data.');
fclose(fid);
end
