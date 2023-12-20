close all
load('test_data\data20231127-113905-trimed.mat');
xStart = 40e-6;
xEnd = 52e-6;
y = waveform1and2;
x = timevec;

% 使い方例
% Fy = wfft(y, x)
% Fy = wfft(y, x, xStart, xEnd, expandPts)
% Fy = wfft( ___, Name=Value)
% [Fy, Fx] = wfft( ___ )
% [Fy, Fx, beforeFFT] = wfft( ___ )
% [Fy, Fx, beforeFFT, windowFun] = wfft( ___ )
% wfft( ___ )

% デフォルトの設定でフーリエ変換
[Fy, Fx] = common.wfft(y,x,xStart,xEnd); %ハン窓が選択される．

% 0 padding 点数を指定してフーリエ変換
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, 2e5);

% 窓を指定してフーリエ変換
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window="rect"); %方形窓
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window=common.rect()); %方形窓
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window="hann"); %ハン窓
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window=common.gaussRect(3.0)); %3σガウス窓（端で０に飛ぶコンパクト関数）
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window=common.gauss(3.0)); %3σガウス窓（端がない）
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window=common.hannFlat(0.1)); %窓の10%でHannで立ち上がり，80%がフラットで，10％でHannで立ち下がる窓

common.wfft(y,x,xStart,xEnd)
% figure(1)
% plot(Fx,abs(Fy))
% xlim([0 20e6]);