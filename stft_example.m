close all
load('test_data\data20231127-113905-trimed.mat');
windowWidth = 2e-6;
maxF = 15e6;

figure();
waveform = waveform1and2;
[s, f, t] = wav.stft(waveform, timevec, windowWidth, maxF);
[ax1, ax2, t] = wav.plotstft(timevec, waveform, t, f, s);
xlim([0 80])
colormap hot;
title(ax1, 'Raw waveform')
figure();
waveform = waveform1and2-waveform1-waveform2;
[s, f, t] = wav.stft(waveform, timevec, windowWidth, maxF);
[ax1, ax2, t] = wav.plotstft(timevec, waveform, t, f, s);
xlim([0 80])
colormap hot;
title(ax1,'Compensated waveform')
