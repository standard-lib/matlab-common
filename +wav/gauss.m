function [winHandle] = gauss(sigma)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
arguments
    sigma double {mustBePositive} = 3;
end
    winHandle = @(v) exp(-(v*sigma).^2);
end