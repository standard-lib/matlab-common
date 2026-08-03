function ellip = conf_ellipse(stats, P)
%CONF_MAHALA 与えられた条件での信頼楕円のマハラノビス距離を返す
%   多変量正規分布を仮定した場合の平均ベクトルの信頼楕円の半径（マハラノビス距離）は
%   標本平均ベクトル\vect{m}と真の平均ベクトル\vect{\mu}の不偏共分散Sから計算されるマハラノビス距離
%   D^2=(\vect{m}-\vect{\mu})^\top S (\vect{m}-\vect{\mu})はホテリングのT^2分布に従う．
%   ホテリングT^2分布はF分布をスケーリングして得られるので，最終的にはF分布の累積確率密度の逆関数を求めれば良い．
%   
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
    % 次元数 k と有効自由度 nu の取得
    k = size(stats.m,1);
    nu = stats.nu;

    % F分布の自由度の設定
    % ホテリングの T^2 分布と F 分布の関係に基づく
    d1 = k;
    d2 = nu - k + 1;

    if d2 <= 0
        error('自由度が不足しています。信頼楕円を計算するには N > k である必要があります。');
    end

    % F分布のパーセント点からマハラノビス距離 c を算出
    if(k~=2)
        % F分布の累積確率密度関数FcumがPになるxを探す．
        FP = fzero(@(x) Fcum(x,d1,d2)-P, 1);
    else
        %次元が2のときは上の式を使わなくても良い
        FP = (d2/2).*((1-P).^(-(2/d2))-1);
    end
    c = sqrt((d1 * nu ./ d2) .* FP);
    
    ellip.m = stats.m;
    ellip.cov = stats.V;
    ellip.c = c;
end