function [winHandle] = gaussRect(sigma)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
arguments
    sigma double {mustBePositive} = 3;
end
    n_step = @(v) (sign(v)+1)*0.5;
    rect = @(v) n_step(1-v).*n_step(1+v);
    gauss = @(v) exp(-(v*sigma).^2);
    winHandle = @(v) rect(v).*gauss(v);
end