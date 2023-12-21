function [s,f,t] = stft(waveform,timevec,windowWidth,maxF,options)
%STFT Short-time Fourier transform
%
% s = stft(waveform,timevec)
% s = stft(waveform,timevec,windowWidth)
% s = stft(waveform,timevec,windowWidth,maxF)
% s = stft( ___ ,Name=Value)
% [s,f,t] = stft( ___ )
% stft( ___ )
%
% Description
% ----------
% s = stft(waveform,timevec) はtimevecを時間軸にもつ時間信号
% waveformの短時間フーリエ変換(STFT)を返します．
% 
% s = stft(waveform,timevec,windowWidth) は窓関数幅を指定して短時間フーリエ変換
% を行います．窓関数幅を大きくすると周波数解像度を上げることができ，小さくすると
% 時間解像度を上げることができます．重要なパラメータのため，必ず指定することをおすすめしますが，
% 指定しない場合，stft関数は窓関数幅を全時間軸の幅の1/100に設定します．
% 
% s = stft(waveform,timevec,windowWidth,maxF) は最大周波数を指定して
% 短時間フーリエ変換を行います．指定しない場合，解析時間が非常に長くなったり， 
% 目的の周波数範囲を拡大した際に荒い結果になる可能性があります．
% 
% s = stft( ___,Name=Value) は，名前と値の引数を使用して追加オプションを指定します．
% オプションにはウィンドウの形状を指定したり，生成されるstft結果の時間・周波数刻み等が含まれます．
% 
% [s,f,t] = stft( ___ )　はSTFTの結果の周波数軸，時間軸を返します．size(s) =
% [numel(t),numel(f)]になります．
% 
% 出力引数を設定せずにstft( ___ )を使用すると，現在のFigureウィンドウに， 
% 変換前の時間波形とSTFTの結果を並べて表示します．この方法は，STFTの結果を最初に確認するのに向いています． 
% 
% Options (名前と値の引数）
%   オプションの引数のペアを Name1=Value1,...,NameN=ValueN として指定します。
%   ここで、Name は引数名で、Value は対応する値です。名前と値の引数は他の引数の後に
%   指定しなければなりませんが、ペアの順序は重要ではありません。
% ----------
% Window -- 窓関数
% common.gauss(1.0) (既定値) | "hann" | "rect" | function_handle
%   窓関数形状を指定します．文字列で'hann', 'rect'のように関数名を指定するか，
%   規格化された窓関数の関数ハンドルを渡してください．利用可能なウィンドウのリストは
%   別途参照して下さい．MatlabのSignal Processing Toolsが提供するウィンドウは使えませんので，注意ください．
% 
% divT -- stftの結果の時間方向の刻み
% 400（既定値） | double
%   stftでは時間方向に窓関数をシフトしながらFFTを行いますが，このシフトの幅を決める値です．
%   たとえば800を指定するとより細かいSTFT結果が得られます．
% 
% divF -- stftの結果の周波数方向の刻み
% 400（既定値） | double
%   sの周波数方向の刻みの最小値を指定するパラメータです．特にmaxFが指定されている場合，
%   maxFまでの周波数を最低でもdivFに分割するように適当に入力信号ベクトルに0を追加します．
%   maxF, divFに過度に大きい値を指定すると解析時間が膨大になる可能性があります．
% 
% display -- stftの結果の表示
% "off"（既定値） | "on" | logical
%   "on"を指定した場合，出力引数を設定せずにstft( ___ )を使用した場合と同様に，結果を
%   現在のFigureウィンドウに表示します．
% 
% Parameters
% ----------
% waveform      : double vector 時間的な信号（波形）
% timevec       : double vector waveformの時間軸
% windowWidth   : double scalar 窓関数の時間長さ（片側ではなく，全体）
% maxF          : double scalar 解析対象の最大周波数（オプション） 
% 
% Returns
% ----------
% s : double matrix STFT結果 (振幅のみ・複素数ではない）
% f : double vector sの周波数軸
% t : double vector sの時間軸
% 

arguments
    waveform (1,:) {mustBeVector, mustBeNumeric, mustBeNonNan, mustBeFinite}
    timevec (1,:)  {mustBeVector, mustBeReal,mustBeEqualSize(timevec,waveform)}
    windowWidth (1,1) {mustBeReal} = (timevec(end)-timevec(1))/100
    maxF (1,1) {mustBeReal} = inf;
    options.Window {common.mustBeWindowFunction} = common.gauss(1.0);
    options.DivT int32 {mustBeInteger,mustBePositive} = 400;
    options.DivF int32 {mustBeInteger,mustBePositive} = 400;
    options.Display {common.mustBeASwitch} = false;
end
options.Display = common.tological(options.Display);
n_windowFun = common.getWindowFunByName(options.Window);

% timevec = reshape(timevec,[],1);
% waveform = reshape(waveform,[],1);
if(~isinf( maxF ))
    expandPts = 1.0/(maxF/options.DivF)/((timevec(end)-timevec(1))/(numel(timevec)-1));
else
    expandPts = 0;
end
fftlength = double(max(expandPts,numel(waveform)));
waveforms = zeros(fftlength,options.DivT);

shiftTime = linspace(timevec(1), timevec(end), options.DivT);

for idxShiftT = 1:options.DivT
    windowVect = n_windowFun((timevec-shiftTime(idxShiftT))/(windowWidth/2.0));  %windowWidthは窓全体の時間長さ
    integral = sum(windowVect);
    waveforms(1:numel(waveform),idxShiftT) = waveform.*windowVect/integral*2.0;
end
rawfreqdomain = abs(fft(waveforms,fftlength,1));
rawfreqvec = linspace(0.0, double(1.0/(timevec(2)-timevec(1))*(fftlength-1)/fftlength),fftlength);

%trimming 
f = rawfreqvec(rawfreqvec <= maxF);
s = rawfreqdomain(1:numel(f),:);
t = shiftTime;

if(options.Display || nargout == 0)
    common.plotstft(timevec,waveform,t,f,s);
end
end

function mustBeEqualSize(a,b)
    % Test for equal size
    if ~isequal(size(a),size(b))
        eid = 'Size:notEqual';
        msg = 'Size of first input must equal size of second input.';
        error(eid,msg)
    end
end