%common�p�b�P�[�W�̊֐���S�ăC���|�[�g����ꍇ
import common.*

timevec = (0:0.1:10)*1e-6;
waveform = sin(timevec*2*pi*1e6) + 0.3*sin(timevec*2*pi*2e6) + 0.1*sin(timevec*2*pi*3e6);
%3~8us�̔g�`��؂�o���ăt�[���G�ϊ�
[freqdomain, freqvec] = windowedFFT(waveform, 2^16, timevec, 3e-6, 8e-6);

plot(freqvec, abs(freqdomain));
xlim([0 4e6]);
