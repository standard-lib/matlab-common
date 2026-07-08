function [ Fy, Fx, beforeFFT, windowVect ] = wfft( y,  x, winRange, expandPts, options)
%wfft Fourier transform with window function
%   
% Fy = wfft(y, x)
% Fy = wfft(y, x, winRange)
% Fy = wfft(y, x, winRange, expandPts)
% Fy = wfft( ___, Name=Value)
% [Fy, Fx] = wfft( ___ )
% [Fy, Fx, beforeFFT] = wfft( ___ )
% [Fy, Fx, beforeFFT, windowVect] = wfft( ___ )
% wfft( ___ )
% 
% Description
% ----------
% Fy = wfft(y, x)
% はy全体をフーリエ変換した結果を返します．yとしてベクトルを与えた場合はその
% フーリエ変換を，n行m列の行列を与えた場合は行方向をn点の波形と扱い，
% 波形がm個ある波形の集団と扱います．関数はm回分のfftを行った結果を返します．
% 
% Fy = wfft(y, x, [xStart, xEnd]) はxの軸のxStartからxEndの範囲に対して対応するyをフーリエ変換します．
% 
% Fy = wfft(y, x, [xStart, xEnd], expandPts) はexpandPtsがyの大きさよりも大きい場合，
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
% 変換前の時間波形とフーリエ変換結果を並べて表示します．この方法は，
% 結果を最初に確認するのに向いています． 下記に示すようにDisplayをOnにしても同じ結果が得られます．
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
% zeroRange --　ゼロ点補正を行うための平均範囲
% []（既定値） | ベクトル
%   ゼロ点補正を行うx軸の範囲を指定します．
%   ZeroRangeオプションを設定することで，平均をとる時間範囲を設定できます．指定しない場合は零点補正を行いません．
% 
% ampCompensate -- 振幅補正
% "on"（既定値） | "off" | logical
%   FFTの点数で割ることにより，ある成分のFFTの結果を，FFTをかけた範囲の
%   平均的なその成分の振幅と一致させます．窓関数がrect（方形窓）以外の場合，
%   窓関数の積分値で補正します．
% 
% complex -- 複素数領域の結果を返す
% "off"（既定値） | "on" | logical
%   "on"の場合，フーリエ変換を複素数で返します．この場合，結果には
%   位相情報も含んだ値になります．
% 
% display -- FFTの結果の表示
% "off"（既定値） | "on" | logical
%   "on"を指定した場合，出力引数を設定せずにwfft( ___ )を使用した場合と同様に，結果を
%   現在のFigureウィンドウに表示します．
% 
% Parameters
% ----------
% y      : double vector 時間的な信号（波形）
% x       : double vector waveformの時間軸
% xStart : 窓関数の左側の端（あるいは特徴点）
% xEnd   : 窓関数の右側の端（あるいは特徴点）
% expandPts   : double scalar 0 paddingを行って少なくともexpandPtsの長さになるようにする．
% 
% Returns
% ----------
% Fx : double/complex vector FFT結果 (振幅のみ，あるいは複素数（オプションによる））
% Fy : double/complex vector 周波数軸
% beforeFFT : double vector FFT前の波形．
% WindowFun : function Handle かけた窓の形状

arguments
    y (:,:) {mustBeNumeric, mustBeNonNan, mustBeFinite}
    x (:,:) {mustBeVector, mustBeReal}
    winRange (1,2) {mustBeReal} = [x(1),x(end)];
    expandPts double {mustBeInteger, mustBeScalarOrEmpty} = [];
    options.window {common.mustBeWindowFunction} = 'hann';
    options.zeroRange double {mustBeReal} = [];
    options.ampCompensate {common.mustBeASwitch}  = true;
    options.complex {common.mustBeASwitch}  = false;
    options.display {common.mustBeASwitch}  = false;
end
options.ampCompensate  = common.tological(options.ampCompensate);
options.complex        = common.tological(options.complex);
options.display        = common.tological(options.display);

x = reshape(x,[], 1); %列ベクトル化

if(isvector(y))
    y=reshape(y,[], 1); %列ベクトルにしておく
elseif(size(y,1) ~= numel(x))
    error("波形として行列を入力する場合、各波形を列(:,idx)とする行列にしてください。")
end

[beforeFFT,windowVect] = common.precondition(y,x,expandPts, options.zeroRange,winRange, options.window);
Fy = fft(beforeFFT);

if(options.ampCompensate)
    integral = sum(windowVect);
    Fy = Fy / integral * 2.0;
end
if(~options.complex)
    Fy = abs(Fy);
end
if(nargout>=2 || nargout == 0)
    N = size(beforeFFT,1);
    Fx = linspace(0,(numel(x)-1)/(x(end)-x(1))*(N-1)/N, N);
end
if(options.display || nargout == 0)
    common.plotft(x,y,windowVect,Fx,abs(Fy));
end
end
