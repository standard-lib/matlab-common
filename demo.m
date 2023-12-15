%commonパッケージの関数を全てインポートする場合
import common.*

timevec = (0:0.1:10)*1e-6;
waveform = sin(timevec*2*pi*1e6) + 0.3*sin(timevec*2*pi*2e6) + 0.1*sin(timevec*2*pi*3e6);
%3~8usの波形を切り出してフーリエ変換
[freqdomain, freqvec] = windowedFFT(waveform, 2^16, timevec, 3e-6, 8e-6);

plot(freqvec, abs(freqdomain));
xlim([0 4e6]);
