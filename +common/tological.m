function [tf] = tological(a)
arguments
    a {common.mustBeASwitch}
end
if(isa(a,'string') || isa(a,'char'))
    tf = strcmpi(string(a),"on");
else
    tf = a;
end
end