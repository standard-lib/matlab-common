function [rectWinHandle] = rect(~)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    n_step = @(v) (sign(v)+1)*0.5;
    rectWinHandle = @(v) n_step(1-v).*n_step(1+v);
end