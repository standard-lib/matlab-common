function [rx] = stepround(x,direction,step)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
if(x==0)
    rx = 0;
elseif(x<0)
    rx = -common.stepround(-x,-direction,step);
else
    if(direction > 0)
        rx = ceil(x/step)*step;
    else
        rx = floor(x/step)*step;
    end
end
