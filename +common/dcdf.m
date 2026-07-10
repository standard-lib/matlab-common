function [h] = dcdf(x)
%DCDF Plot discrete cumulative distribution function
%   詳細説明をここに記述
arguments (Input)
    x
end

arguments (Output)
    h
end
n = numel(x);
h = plot(sort(x), (1:n)/n );
end