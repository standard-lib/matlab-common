function [C] = compcovs(z)
%COMPCOV 複素数ベクトルの実部と虚部を2つの確率変数とする共分散行列の不偏推定
%   実部と虚部がそれぞれ非独立な正規分布であることを仮定している．
    E = @(x) sum(x)/numel(x);    
    CovS = @(x,y) numel(x)/(numel(x)-1)*((E(x.*y) - E(x)*E(y)));
    VS = @(x) CovS(x,x);
    x = real(z);
    y = imag(z);
    C = [VS(x), CovS(x,y);CovS(x,y), VS(y)];
end
