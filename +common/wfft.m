function [ Fy, Fx, beforeFFT, windowFun ] = wfft( y,  x, xStart, xEnd, expandPts, options)
%wfft Fourier transform with window function
%   
% Fy = wfft(y, x)
% Fy = wfft(y, x, xStart, xEnd)
% Fy = wfft(y, x, xStart, xEnd, expandPts)
% Fy = wfft( ___, Name=Value)
% [Fy, Fx] = wfft( ___ )
% [Fy, Fx, beforeFFT] = wfft( ___ )
% [Fy, Fx, beforeFFT, windowFun] = wfft( ___ )
% wfft( ___ )
% 
% Description
% ----------
% Fy = wfft(y, x) はy全体をフーリエ変換した結果を返します．
% 
% Fy = wfft(y, x, xStart, xEnd) はxの軸のxStartからxEndの範囲に対して対応するyをフーリエ変換します．
% 
% Fy = wfft(y, x, xStart, xEnd, expandPts) はexpandPtsがyの大きさよりも大きい場合，
% expandPtsまで0を追加してフーリエ変換を行います．
% 
% Fy = wfft( ___, Name=Value) は，名前と値の引数を使用して追加オプションを指定します．
% オプションにはウィンドウの形状，零点補正の有無，方法などが含まれます．
% 
% [Fy, Fx] = wfft( ___ ) はフーリエ変換の結果Fyに対する周波数軸Fxを返します．
% 
% [Fy, Fx, beforeFFT] = wfft( ___ ) はフーリエ変換直前の波形（零点補正・窓関数・ゼロパディング後）
% beforeFFTを返します．正しい位置に窓がかけられているかなどをチェックするのに有効です．
% 
% [Fy, Fx, beforeFFT, windowFun] = wfft( ___ ) は窓関数の関数ハンドルを返します．
% yに掛けられるベクトルはwindowFun(timevec)で求めることができます．
% 
% 出力引数を設定せずにwfft( ___ )を使用すると，現在のFigureウィンドウに， 
% 変換前の時間波形とフーリエ変換結果を並べて表示します．この方法は，結果を最初に確認するのに向いています． 
% 
% Options (名前と値の引数）
%   オプションの引数のペアを Name1=Value1,...,NameN=ValueN として指定します。
%   ここで、Name は引数名で、Value は対応する値です。名前と値の引数は他の引数の後に
%   指定しなければなりませんが、ペアの順序は重要ではありません。
% ----------
% Window -- 窓関数
% "hann" (既定値) | "rect" | function_handle
%   窓関数形状を指定します．文字列で'hann', 'rect'のように関数名を指定するか，
%   規格化された窓関数の関数ハンドルを渡してください．利用可能なウィンドウのリストは
%   別途参照して下さい．MatlabのSignal Processing Toolsが提供するウィンドウは使えませんので，注意ください．
% 
% ZeroAdjustment -- ゼロ点補正
% "off"（既定値） | "on" | logical
%   ゼロ点補正を行う場合"on"を指定します．デフォルトでは波形全体の平均を波形から引きますが，
%   ZeroRangeオプションを設定することで，平均をとる時間範囲を設定できます．
% 
% ZeroRange --　ゼロ点補正を行うための平均範囲
% [-inf inf]（既定値） | ベクトル
%   
% Desctipri

arguments
    y
    x
    xStart = x(1)
    xEnd = x(end)
    expandPts = 0;
    options.Window {common.mustBeWindowFunction} = 'hann';
    options.ZeroAdjustment logical = false;
    options.ZeroRange = [-inf inf];
    options.AmpCompensate logical = true;
    options.Complex logical = false;
    options.display logical = false;
end

if(options.ZeroAdjustment)
    y = y - mean(y(x>=options.ZeroRange(1) & x<=options.ZeroRange(2)));
end

n_windowFun = common.getWindowFunByName(options.Window);
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
    common.plotft(x,y,windowVect,Fx,abs(Fy));
end
end
