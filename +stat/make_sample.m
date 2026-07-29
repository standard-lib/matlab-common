function X = make_sample(mu,Sigma,N,samples)
%MAKE_SAMPLE 平均ベクトルmu, 共分散行列Sigmaに従う多変量ガウス分布乱数の作成
%    多変量ガウス分布の次元数をkとすると，k行を1セットの乱数として，N列samplesページのN×samples数分のベクトルを作成する．
arguments (Input)
    mu
    Sigma
    N
    samples
end
arguments (Output)
    X (:,:,:) double 
end
dimension = numel(mu);
L = chol(Sigma,'lower');
%ガウス分布変数の作成．
Z = randn(dimension,N,samples);
%独立ガウス分布から（依存性のある）多変量正規分布に従う仮想実験データの作成
X = mu + pagemtimes(L,Z);
end