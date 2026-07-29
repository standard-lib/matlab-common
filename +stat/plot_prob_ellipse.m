function [h,ellip] = plot_prob_ellipse(stats, P, varargin)
%SD_ELLIPSE 標準偏差楕円の描画
%   cov (required) 2x2 covariance matrix
%   mu  (optional) 1x2 mean of distribution
%   LineSpec (optional) line spec 
%   
arguments(Input)
    stats struct
    P double = 0.95
end
arguments(Repeating)
    varargin % Linespecや，plot関数のName-Valueペアオプションに対応する．
end
    ellip = stat.prob_ellipse(stats,P);
    h = stat.plot_ellipse(ellip, varargin{:});
end