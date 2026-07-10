function [cinv] = invcdf(p, pdf, xmin)
%INVCDF 与えられた確率密度関数の累積分布関数の逆関数
%   p：下側確率 0.025などを入れる
%   pdf: 累積分布関数
%   xmin:累積分布関数の

    cinv = fzero(@(x) cdf(x, pdf, xmin)-p, 1);

end
