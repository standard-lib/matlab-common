close all
load('test_data\data20231127-113905-trimed.mat');
xStart = 40e-6;
xEnd = 52e-6;
y = waveform1and2;
x = timevec;

% 使い方例 1
% デフォルトの設定でフーリエ変換
[Fy, Fx] = common.wfft(y,x,xStart,xEnd); %ハン窓が選択される．

% 使い方例 2
% 0 padding 点数を指定してフーリエ変換
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, 2e5);

% 使い方例 3
% 窓を指定してフーリエ変換
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window="rect"); %方形窓
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window=common.rect()); %方形窓
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window="hann"); %ハン窓
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window=common.gaussRect(3.0)); %3σガウス窓（端で０に飛ぶコンパクト関数）
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window=common.gauss(3.0)); %3σガウス窓（端がない純粋なガウス関数）
[Fy, Fx] = common.wfft(y, x, xStart, xEnd, Window=common.tukey(0.1)); %コサインテーパー窓．Hannで立ち上がり，中央部がフラットで，Hannで立ち下がる窓．ratio=0.1は，cos関数部分が片側の幅の10%で（全体の５%で）あることを示す

% 使い方例 4
% 返り値を指定しない場合，元の波形とフーリエ変換後のFFT結果のプレビューを見れる．
common.wfft(y,x,xStart,xEnd);


