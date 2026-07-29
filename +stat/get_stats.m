function stats = get_stats(X)
% GET_STATS $k \times N$ のデータ行列から統計量構造体を生成する
%
% 入力:
%   X : [k x N] のデータ行列
%       k は次元数、N はサンプルサイズ
%
% 出力:
%   stats : 以下のフィールドを持つ構造体
%       .m  : 標本平均ベクトル (k x 1)
%       .S  : 不偏共分散行列 (k x k)
%       .V  : 平均の分散行列 (k x k) --- S/N
%       .nu : 自由度 (scalar) --- N-1

    N = size(X,2);

    if N < 2
        error('不偏統計量を計算するには、サンプルサイズ N は 2 以上である必要があります。');
    end

    % 1. 標本平均ベクトルの算出
    % mean(X, 2) により、各行（各次元）の平均を計算
    m = mean(X, 2);

    % 2. 不偏共分散行列の算出
    % MATLABのcov関数は、引数が行列の場合、デフォルトで分母を N-1 とした不偏分散を計算する
    % cov(X') とすることで [k x k] の行列を得る
    % 標本共分散
    diff = X - m;
    S = pagemtimes(diff, 'none', diff, 'ctranspose')/(N-1);

    % 3. 自由度の設定
    nu = N - 1;

    % 4. 平均の分散行列の算出
    % 母平均の推定誤差を表す行列 V = S / N
    V = S / N;

    % 構造体にまとめて返却
    stats.m = m;
    stats.S = S;
    stats.V = V;
    stats.nu = nu;
end