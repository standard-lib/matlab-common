function [ A, lambda ] = ExpFit( xdata, ydata )
%ExpFit y = A e^(��x)�̌`�Ƀt�B�b�e�B���O����D
%   �܂��ΐ�������Đ��`�t�B�b�e�B���O������C���̒l�������l�Ƃ�������`�t�B�b�e�B���O�ifminsearch���g�p�j���s���D
p = polyfit( xdata, log(ydata), 1); % ���`�t�B�b�e�B���O
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

