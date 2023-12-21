function [winHandle] = tukey(ratio)
%TUKEY テューキー窓
% 正規化されたコサインテーパー窓の関数ハンドルを返す．
% tukey窓：
%   Hannで立ち上がり，中央部がフラットで，Hannで立ち下がる窓．
%   たとえばratio=0.1は，cos関数部分が10%でフラット部分が90%，
%   すなわち全体の幅の5%で立ち上がり，5%でたち下がることを示す．
%   tukey(0.0)は方形窓と一致し，tukey(1.0)はハン窓と一致する．
arguments
    ratio (1,1) double {mustBeInRange(ratio,0.0,1.0)} = 0.1
end
    winHandle = @(v) core_tukey(v,ratio);
end

function val = core_tukey(v, ratio)
    n_hann = @(v) (cos(v*pi)+1)*0.5;
    val = zeros(size(v));
    left = n_hann((v+(1-ratio*2))/(ratio*2));
    left_idx = -1<v & v<=(-(1-ratio*2));
    right = n_hann((v-(1-ratio*2))/(ratio*2));
    right_idx =  1>v & v>=  (1-ratio*2);
    val(left_idx)  = left(left_idx);
    val(right_idx) = right(right_idx);
    val( v >= (-(1-ratio*2)) & v <= (1-ratio*2)) = 1.0;
end