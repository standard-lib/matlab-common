function [rxy] = niceouter(x,y)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
if(abs(x) > abs(y))
    idxX = 1;
    idxY = 2;
else
    idxX = 2;
    idxY = 1;
end
val=zeros(1,2);
rval = val;
val(idxX) = x;
val(idxY) = y;
if( val(1) > val(2) )
    [rval(1),step] = common.niceround(val(1),1);
    rval(2) = common.stepround(val(2),-1,step);
else
    [rval(1),step] = common.niceround(val(1),-1);
    rval(2) = common.stepround(val(2),1,step);
end
rxy = [rval(idxX),rval(idxY)];
end