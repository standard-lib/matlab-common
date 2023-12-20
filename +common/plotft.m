function [ax1,ax2] = plotft(x,y,windowVect,Fx,Fy)
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here
    flimRatio = 0.9;
    flimMag = 2.5;
    fh = gcf;
    fh.Position = [10 90 550 600];
    tiledlayout(fh,2,1);
    ax1=nexttile;
    ax2=nexttile;
    
    [px,mx]=common.SIprefix(max(abs(x)));
    [py,my]=common.SIprefix(max(abs(y)));
    plot(ax1,x/mx,y/my,x/mx,y.*windowVect/my,x/mx,windowVect*max(abs(y.*windowVect))/my);
    xlim(common.niceouter(x(1),x(end))/mx);
    axes(ax1);
    common.myPlotStyle(['Time [',px,'s]'],['Voltage [',py,'V]'],'Time domain');

    aFy = abs(Fy);
    [pFx,mFx]=common.SIprefix(max(abs(Fx)));
    semilogy(ax2,Fx/mFx,aFy);
    axes(ax2);
    common.myPlotStyle(['Frequency [',pFx,'Hz]'],'','Frequecy domain');
    N = numel(aFy);
    wholeIntegral = sum(aFy(1:round(N/2)));
    partIntegral = 0.0;
    toPlotF = 0;
    for n = round(N/2):-1:1
        partIntegral = partIntegral+aFy(n);
        if(partIntegral>(1-flimRatio)*wholeIntegral)
            toPlotF = Fx(n)*flimMag;
            break;
        end
    end
    xlim([0 common.niceceil(toPlotF)/mFx]);

end