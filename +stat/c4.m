function val = c4(N)
%C4 小標本における標準偏差のバイアスを補正するための有限標本不偏係数
%   (Finite-sample unbiasing factor for estimating the standard deviation)
%   参考：R Documentation Finite-sample unbiasing factor unbiasing.factor {rQCC} 
%   https://search.r-project.org/CRAN/refmans/rQCC/html/unbiasing.factor.html
%入力：
%   N　サンプルサイズ．自由度ではないよ．infを与えると，c4は1を返します．
%出力：
%   c4：有限標本不偏係数．小標本の場合，カイ自乗分布に従う変数X^2の期待値の平方根sqrt(E[X^2])は，Xの期待値に対してc4倍だけ小さくなってしまう．
%       そのため，Xを推定する場合，sqrt(E[X^2])/c4 で推定することで小標本でもXを不偏に推定できる．
arguments (Input)
    N double
end
arguments (Output)
    val double
end
if(isinf(N))
    val = 1;
else
    % sz = size(N);
    % N = squeeze(N);
    % 普通にΓ関数の割り算をするとNが数百くらいでdouble型をオーバーフローする．
    % val = sqrt(2/(N-1))*gamma(N/2)/gamma((N-1)/2);
    % gammaの対数を返す関数を使って，計算した後に指数関数でもどす．
    val = sqrt(2./(N-1)).*exp(gammaln(N/2)-gammaln((N-1)/2));
    % val = reshape(val,sz);
end