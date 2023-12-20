function [n_windowFun] = getWindowFunByName(window)
%UNTITLED19 Summary of this function goes here
%   Detailed explanation goes here
hannWindowStr = "hann";
rectWindowStr = "rect";

if(ischar(window))
    window = string(window);
end
if(isstring(window))
    if(strcmpi(window,hannWindowStr))
        n_windowFun = common.hann();
    elseif(strcmpi(window,rectWindowStr))
        n_windowFun = common.rect();
    end
else
    n_windowFun = window;
end

end