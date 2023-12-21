function [winHandle] = hannFlat(ratio)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    winHandle = common.tukey(ratio);
end
