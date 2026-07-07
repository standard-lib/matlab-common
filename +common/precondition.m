function [beforeFFT] = precondition(y,x,expandPts, zeroRange,windowRange, window)
%UNTITLED2 この関数の概要をここに記述
%   詳細説明をここに記述
arguments (Input)
    y (:,:) double {mustBeNumeric, mustBeNonNan, mustBeFinite}
    x (:,:) double {mustBeVector, mustBeReal}
    expandPts double {mustBeScalarOrEmpty, mustBeInteger}
    zeroRange double {mustBeReal}
    windowRange double
    window  {common.mustBeWindowFunction};
end

arguments (Output)
    beforeFFT
end

window = common.getWindowFunByName(window);

if(~isempty(zeroRange))
    if(isscalar(zeroRange))
        zeroRange = [-inf zeroRange];
    end
    timevec_ave_idx = find(x>=zeroRange(1) & x<=zeroRange(2));
    assert(~isempty(timevec_ave_idx),...
        'ゼロ調整用の指定時間範囲 [%.1f, %.1f] \\mus がデータ内に存在しません。処理を中断します。', ...
        zeroRange(1)*1e6, zeroRange(2)*1e6);
    y = y - mean(y(timevec_ave_idx,:), 1);
end

n_windowFun = options.Window;
windowCenter = (xEnd + xStart ) /2.0;
windowWidth  = (xEnd - xStart ) /2.0;
windowFun = @(t) n_windowFun((t-windowCenter)/windowWidth);

windowVect = windowFun(x);

beforeFFT = zeros(max( size(y,1), expandPts), size(y, 2));
beforeFFT(1:numel(x), :) = y.*windowVect;

outputArg1 = inputArg1;
outputArg2 = inputArg2;
end