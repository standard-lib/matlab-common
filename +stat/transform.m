function [new_stats] = transform(stats,A)
% TRANSFORM 統計量セット(stats)に行列Aによる線形変換を施す
%
% 入力:
%   stats : 以下のフィールドを持つ構造体
%       .m  : 平均ベクトル (k x 1)
%       .S  : 不偏共分散行列 (k x k) 母分散の推定
%       .V  : 平均ベクトルの分散行列 (k x k) 平均ベクトルの分散の
%       .nu : 自由度 (scalar, N-1)
%   A     : 変形・座標変換行列 (m x k)
%
% 出力:
%   new_stats : 変換後の平均、共分散、自由度を格納した構造体
    % 平均ベクトルの変換: m_y = A * m_x
    new_stats.m = A * stats.m;

    % 不偏共分散行列の変換: S_y = A * S_x * A'
    % 線形変換の性質 Var(AX) = A * Var(X) * A' に基づく
    new_stats.S = A * stats.S * A';

    % 自由度の継承: nu_y = nu_x
    % 自由度は標本の情報量（サンプルサイズ）に依存するため、
    % 既存のデータに対する線形変換によって変化することはない。
    new_stats.nu = stats.nu;
end