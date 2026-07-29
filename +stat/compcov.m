function [S] = compcov(z)
%COMPCOV 複素数ベクトルの実部と虚部を2つの確率変数とする共分散行列の不偏推定
%   実部と虚部がそれぞれ非独立な正規分布であることを仮定している．
    z = reshape(z,[],1);
    zarr = [real(z),imag(z)];
    S = cov(zarr);
end
