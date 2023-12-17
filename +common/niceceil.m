function [ceilx] = niceceil(x)
%NICECEIL Returns a nice round value that is larger than the specified value.
% When drawing a graph, the maximum and minimum values of the axes must be 
% rounded to "a nice round value". For example, if 8.4 is the highest 
% value on an axis, the maximum value on the graph should be 10, rounded up
% from 8.4. The function returns a good cutoff value that is larger than the 
% specified value and suitable for the edge of the graph.
%   Detailed explanation goes here
    [ceilx,~] = common.niceround(x,1);
end
