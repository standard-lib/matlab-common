function [ellip] = sd_ellipse(stats)
%SD_ELLIPSE 統計量から標準偏差楕円の要素を返す
%   小標本時のc4補正を入れて、標準偏差として不偏となるようにしてある
arguments (Input)
    stats struct
end
arguments (Output)
    ellip struct
end
ellip.m = stats.m;
ellip.cov = stats.S;
ellip.c = 1/stat.c4(stats.nu + 1);
end