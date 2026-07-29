function [h,ellip] = plot_conf_ellipse(stats, P, varargin)
% PLOT_CONF_ELLIPSE 多変量正規分布を仮定した平均ベクトルの信頼楕円の描画
%
% 入力:
%   stats : 統計量構造体 (.m, .V, .nu を含む)
%   P     : 包含確率 (0 < P < 1)
%   varargin : stat.plot_ellipse に渡される描画オプション (Color, LineWidth 等)
    ellip = stat.conf_ellipse(stats, P);
    h = stat.plot_ellipse(ellip, varargin{:});

end