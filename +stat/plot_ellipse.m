function h = plot_ellipse(ellip, varargin)
%PLOT_ELLIPSE 等マハラノビス距離の楕円の描画
%   c   (required) 1x1 Mahalanobis distance
%   cov (required) 2x2 Xの分布の共分散Sあるいは平均ベクトルの分布の共分散V
%   mu  (required) 1x2 mean of distribution
%   LineSpec (optional) line spec 
%   points  (optional) 楕円を構成する点数（多いと滑らかな楕円） 
arguments(Input)
    ellip struct
end
arguments (Repeating)
    varargin
end
    % 独自オプション 'points' の抽出処理
    % デフォルト値を設定
    num_pts = 100;
    
    % plot に渡すための引数リストをコピー
    plot_args = varargin;
    
    % 'points' というキーワードが varargin に含まれているか探す
    idx = find(cellfun(@(x) ischar(x) && strcmpi(x, 'points'), plot_args));
    
    if ~isempty(idx)
        % 値を取得し，plot_args からそのペアを削除する
        num_pts = plot_args{idx + 1};
        plot_args(idx : idx+1) = [];
    end

    mu = reshape(ellip.m,[],1);
    theta = linspace(0,1,num_pts)*2*pi;
    L = chol(ellip.cov)';
    c = ellip.c;
    xy = mu + c*L*[cos(theta);sin(theta)];
    h = plot(xy(1,:), xy(2,:), plot_args{:});
    
end