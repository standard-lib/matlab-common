function [ maxVal, idx ] = gatedMax( object, vec, gateStart, gateEnd )
%UNTITLED4 ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

idxGateStart = floor( (gateStart - vec(1) ) / (vec(2) - vec(1))) - 1;
idxGateEnd   = floor( (gateEnd   - vec(1) ) / (vec(2) - vec(1))) + 1;

[maxVal,idx] = max( object(idxGateStart:idxGateEnd));
idx = idx+idxGateStart-1;
end

