function [h,ellip] = plot_sd_ellipse(stats, varargin)
%PLOT_SD_ELLIPSE 標準偏差楕円の描画
%   統計量を得て標準偏差楕円を描く関数。返り値としてプロットした線のハンドラと楕円要素を返す
%   
arguments(Input)
    stats struct
end
arguments(Input, Repeating)
    varargin
end
arguments(Output)
    h
    ellip struct
end
    ellip = stat.sd_ellipse(stats);
    h = stat.plot_ellipse(ellip, varargin{:});
end