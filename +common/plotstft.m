function [ax1,ax2,t] = plotstft(timevec,waveform,t,f,s)
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here
fh = gcf;
fh.Position = [10 90 1000 600];

[T,F] = meshgrid(t,f);

t = tiledlayout(fh,2,1,"TileSpacing","tight");
ax1=nexttile;
ax2=nexttile;
linkaxes([ax1 ax2],'x');

axes(ax1);
[px,mx]=common.SIprefix(max(abs(timevec)));
[py,my]=common.SIprefix(max(abs(waveform)));
plot(timevec/mx, waveform/my)
xlim(common.niceouter(timevec(1),timevec(end))/mx);
common.myPlotStyle('',['Voltage [',py,'V]'],'');
ax1.XTickLabel = [];

axes(ax2);
[pf,mf]=common.SIprefix(max(abs(F),[],"all"));
mesh(T/mx,F/mf,s);
hold on
view(2)
set(gca,'ColorScale','log')
colorbar
common.myPlotStyle(['Time [',px,'s]'],['Frequency [',pf,'Hz]'],'');
%clim([0.003 20])
% x = (-10:10:90)';   % will draw grid with reduced resolution 
% f = [0 16];
% [gX, gF] = meshgrid(x,f);
% plot3(gX,gF,ones(size(gX))*max(trimed_freqdomain,[],'all'),'k')
end