function [rx,step] = niceround(x,direction)
%NICEROUND Returns a nice round value that is larger than the specified
%value if the `direction` is +1, and is smaller than the specified value if the
%`direction` is -1.
%   Detailed explanation goes here
tbl = [...
    3.0 0.5;...
    5.0 1.0;...
    10.0 2.0];
if(x<0)
    [rx,step] = common.niceround(-x,-direction);
    rx = -rx;
elseif(x==0)
    rx = 0;
    step = 0;
else
    if(direction > 0)
        x = x*0.999;
    else
        x = x*1.001;
    end
    digits = floor(log10(x));
    significand = x/(10^digits);
    idx = find(tbl(:,1) >= significand,1);
    step = tbl(idx,2)*10^digits;
    rx = common.stepround(x,direction,step);
end

end