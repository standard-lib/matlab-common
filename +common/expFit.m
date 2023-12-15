function [ A, lambda ] = ExpFit( xdata, ydata )
%ExpFit y = A e^(λx)の形にフィッティングする．
%   まず対数を取って線形フィッティングした後，その値を初期値とした非線形フィッティング（fminsearchを使用）を行う．
p = polyfit( xdata, log(ydata), 1); % 線形フィッティング
model = @expfun;
estimates = fminsearch(model, [exp(p(2)), p(1)]);
A = estimates(1);
lambda = estimates(2);
% expfun accepts curve parameters as inputs, and outputs sse,
% the sum of squares error for A*exp(lambda*xdata)-ydata,
% and the FittedCurve. FMINSEARCH only needs sse, but we want
% to plot the FittedCurve at the end.
    function [sse, FittedCurve] = expfun(params)
        estA = params(1);
        estLambda = params(2);
        FittedCurve = estA .* exp(estLambda * xdata);
        ErrorVector = FittedCurve - ydata;
        sse = sum(ErrorVector .^ 2);
    end


end

