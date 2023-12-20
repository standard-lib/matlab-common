
% n_step = @(v) (sign(v)+1)*0.5;
% n_rect = @(v) n_step(1-v).*n_step(1+v);
% n_hann = @(v) (cos(v*pi)+1)*0.5.*n_rect(v);

x = (-5:0.01:30)*1e-6;
y = 0.1*sin(2*pi*5e6*x)+0.02*sin(2*pi*10e6*x);
xStart = 0e-6;
xEnd = 10e-6;
% [Fy, Fx] = common.wfft(y,x,xStart,xEnd,Window="rect");
% common.wfft(y,x,xStart,xEnd,Window="hann");
% common.wfft(y,x,xStart,xEnd,Window=common.hannFlat(.3));
common.wfft(y,x,xStart,xEnd,Window=common.gauss(1.0));

% figure(1)
% plot(Fx,abs(Fy))
% xlim([0 20e6]);