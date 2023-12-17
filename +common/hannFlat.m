function [winHandle] = hannFlat(ratio)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if(ratio>0.5)
        warning('hann with flat head window has flat area when ratio < 0.5.');
    end
    winHandle = @(v) core_hannFlat(v,ratio);
end

function val = core_hannFlat(v, ratio)
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