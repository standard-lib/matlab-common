function ellip = prob_ellipse(stats, P)
%PROB_MAHALA 確率楕円のマハラノビス距離を返す
%   多変量正規分布を仮定した場合のHDR領域の累積確率がPとなる楕円の半径（マハラノビス距離）を返す．
%   母集団分布として多変量正規分布を仮定すると，分布は平均ベクトル$\vect{\mu}$と共分散行列$\mat{\Sigma}$によって一意に決定される．
%   そこで標本平均ベクトル $\vect{m}$ と不偏共分散行列 $\mat{S}$をそれぞれ平均ベクトル$\vect{\mu}$と共分散行列$\mat{\Sigma}$の推定値として採用する．
%   この推定された多変量正規分布に基づく95\%HDRを「95\%確率楕円」と呼ぶ．
%   この「95\%確率楕円」は，本質的には母集団パラメータの推定に基づいた領域であるため、厳密には「95\%確率領域の推定値」と解釈すべきものである。
%   多変量正規分布において，マハラノビス自乗距離は自由度N-1のカイ自乗分布に
%入力
%   k: 多変量解析における次元．
%   N: サンプルサイズ
%   P: 指定するHDR領域の累積確率
    arguments (Input)
        stats
        P
    end
    
    arguments (Output)
        ellip
    end
    k = size(stats.m,1);
    if(k~=2)
        % マハラノビス自乗距離はカイ自乗分布に従う．
        % カイ自乗分布の累積確率がPになる距離が知りたい．
        % カイ自乗分布の累積分布関数はgammaincで，その逆関数がgammaincinvなので関数一発書き．
        chi2 = gammaincinv(P, k);
    else
        % ただし次元が２のときはgammaincinvは-log(1-P)と簡単になる．
        chi2 = -2*log(1-P); 
    end

    ellip.m = stats.m;
    ellip.cov = stats.S;
    ellip.c = sqrt(chi2)/stat.c4(stats.nu+1);
end