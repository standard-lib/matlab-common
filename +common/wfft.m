function [ Fy, Fx, beforeFFT, windowFun ] = wfft( y,  x, xStart, xEnd, expandPts, options)
%wfft 窓関数付きのフーリエ変換
%   Usage
%   Fy = wfft(y, x)
%   Fy = wfft(y, x, xStart, xEnd)
%   Fy = wfft(__, Name=Value)
%   [Fy, Fx] = wfft(__)
%   [Fy, Fx, beforeFFT] = wfft(__)
%   [Fy, Fx, beforeFFT, windowFun] = wfft(__)
%   wfft(__)
arguments
    y
    x
    xStart = x(1)
    xEnd = x(end)
    expandPts = 0;
    options.ZeroAdjustment logical = false;
    options.ZeroRange = [-inf inf];
    options.Window {mustBeWindowFunction} = 'hann';
    options.AmpCompensate logical = true;
    options.Complex logical = false;
end
hannWindowStr = "hann";
rectWindowStr = "rect";

if(ischar(options.Window))
    options.Window = string(options.Window);
end
if(isstring(options.Window))
    if(strcmpi(options.Window,hannWindowStr))
        n_windowFun = common.hann();
    elseif(strcmpi(options.Window,rectWindowStr))
        n_windowFun = common.rect();
    end
else
    n_windowFun = options.Window;
end
windowCenter = (xEnd + xStart ) /2.0;
windowWidth  = (xEnd - xStart ) /2.0;
windowFun = @(t) n_windowFun((t-windowCenter)/windowWidth);

windowVect = windowFun(x);

beforeFFT = zeros(1, max( numel(y), expandPts) );
beforeFFT(1:numel(x)) = y.*windowVect;

Fy = fft(beforeFFT);

if(options.AmpCompensate)
    integral = sum(windowVect);
    Fy = Fy / integral * 2.0;
end
if(~options.Complex)
    Fy = abs(Fy);
end
if(nargout>=2 || nargout == 0)
    N = numel(beforeFFT);
    Fx = linspace(0,(numel(x)-1)/(x(end)-x(1))*(N-1)/N, N);
end
if(nargout == 0)
    fh = gcf;
    fh.Position = [10 90 550 600];
    tiledlayout(fh,2,1);
    ax1=nexttile;
    ax2=nexttile;
    
    [px,mx]=common.SIprefix(max(abs(x)));
    [py,my]=common.SIprefix(max(abs(y)));
    plot(ax1,x/mx,y/my,x/mx,y.*windowVect/my,x/mx,windowVect*max(abs(y))/my);
    xlim(common.niceouter(x(1),x(end))/mx);
    axes(ax1);
    common.myPlotStyle(['Time [',px,'s]'],['Voltage [',py,'V]'],'Time domain');

    aFy = abs(Fy);
    [pFx,mFx]=common.SIprefix(max(abs(Fx)));
    plot(ax2,Fx/mFx,aFy);
    axes(ax2);
    common.myPlotStyle(['Frequency [',pFx,'Hz]'],'','Frequecy domain');
    N = numel(aFy);
    wholeIntegral = sum(aFy(1:round(N/2)));
    partIntegral = 0.0;
    toPlotF = 0;
    for n = round(N/2):-1:1
        partIntegral = partIntegral+aFy(n);
        if(partIntegral>0.1*wholeIntegral)
            toPlotF = Fx(n);
            break;
        end
    end
    xlim([0 common.niceceil(toPlotF)/mFx]);
end
end

function mustBeWindowFunction(a)
    windowNameList = ["hann", "rect"];
    if ~(isa(a,'function_handle') || ismember(lower(a),windowNameList))
        eidType = 'mustBeWindowFunction:notWindowFunction';
        msgType = 'Input must be a function handle of normalized window function, or window function name.';
        throwAsCaller(MException(eidType,msgType))
    end
end