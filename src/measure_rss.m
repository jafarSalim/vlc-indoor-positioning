function Hm = measure_rss(p, H)
%MEASURE_RSS  Noisy gain estimates: photocurrent R Pt H + N(0, sigma^2) per LED,
%   divided back by R Pt. LEDs are told apart by frequency (one tone each).
I = p.R * p.Pt * H;
s = sqrt(noise_var(p, p.Pt * H));
Hm = (I + s .* randn(size(I))) / (p.R * p.Pt);
end
