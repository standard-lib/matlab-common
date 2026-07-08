close all
load('test_data\data20231127-113905-trimed.mat');
xStart = 40e-6;
xEnd = 52e-6;
y = waveform1and2';
x = timevec;

% 使い方例 1
% デフォルトの設定でフーリエ変換
[Fy, Fx] = wav.wfft(y,x,[xStart,xEnd]); %ハン窓が選択される．

% 使い方例 2
% 0 padding 点数を指定してフーリエ変換
[Fy, Fx] = wav.wfft(y, x, [xStart, xEnd], 2e5);

% 使い方例 3
% 窓を指定してフーリエ変換
[Fy, Fx] = wav.wfft(y, x, [xStart, xEnd], window="rect"); %方形窓
[Fy, Fx] = wav.wfft(y, x, [xStart, xEnd], window=wav.rect()); %方形窓
[Fy, Fx] = wav.wfft(y, x, [xStart, xEnd], window="hann"); %ハン窓
[Fy, Fx] = wav.wfft(y, x, [xStart, xEnd], window=wav.gaussRect(3.0)); %3σガウス窓（端で０に飛ぶコンパクト関数）
[Fy, Fx] = wav.wfft(y, x, [xStart, xEnd], window=wav.gauss(3.0)); %3σガウス窓（端がない純粋なガウス関数）
[Fy, Fx] = wav.wfft(y, x, [xStart, xEnd], window=wav.tukey(0.1)); %コサインテーパー窓．Hannで立ち上がり，中央部がフラットで，Hannで立ち下がる窓．ratio=0.1は，cos関数部分が片側の幅の10%で（全体の５%で）あることを示す

% 使い方例 4
% 返り値を指定しない場合，元の波形とフーリエ変換後のFFT結果のプレビューを見れる．
wav.wfft(y,x,[xStart,xEnd]);

% 使い方例 5
% yとして列ベクトルを束ねた行列を与えて，複数のFFTを一度に行う．
% 一つずつ行うより遥かに効率が良い．
ys = repmat(y,[1,10]); %10波形分の設定
disp(size(ys))
[Fy, Fx] = wav.wfft(ys, x, [xStart, xEnd]);
disp(size(Fy))
figure()
plot(Fx,Fy(:,1))
xlim([0 30e6])
yscale(gca,"log")

% 使い方例 6 wdft
% 必要な周波数が一つだけのとき，すなわち特定の周波数の振幅のみが知りたいとき
% 全周波数ビンを計算するFT（O(N log N)）よりも，FTのSumを一つだけ行うほうが当然速い（O(N)）
F0 = 6e6;
[Fy] = wav.wdft(ys, F0, x, [xStart, xEnd]);
hold on
plot(F0, Fy(1), '*')
hold off