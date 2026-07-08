function [hannWinHandle] = hann(~)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    n_step = @(v) (sign(v)+1)*0.5;
    n_rect = @(v) n_step(1-v).*n_step(1+v);
    hannWinHandle = @(v) (cos(v*pi)+1)*0.5.*n_rect(v);
end