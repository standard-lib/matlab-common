function [ freqdomain, freqvec ] = windowedFFT( timedomain, expandPts, timevec, windowStart, windowEnd  )
%UNTITLED3 この関数の概要をここに記述
%   詳細説明をここに記述
idxWindowStart = floor( (windowStart - timevec(1) ) / (timevec(2) - timevec(1))) - 10;
idxWindowEnd   = floor( (windowEnd   - timevec(1) ) / (timevec(2) - timevec(1))) + 10;

windowCenter = (windowEnd + windowStart ) /2.0;
windowWidth  = (windowEnd - windowStart ) /2.0;

beforeFFT = zeros(1, max( numel(timedomain), expandPts) );
integral = 0.0;

% ハン窓をかける
for idx = idxWindowStart:idxWindowEnd
    if( abs( timevec(idx) - windowCenter ) < windowWidth )
        coef = ( cos((timevec(idx) - windowCenter) / windowWidth * pi ) + 1.0 ) / 2.0; 
        integral = integral + coef;
        beforeFFT( idx ) = timedomain(idx) * coef;
    end
end

freqdomain = fft(beforeFFT) / integral * 2.0;
freqvec = linspace(0,1.0/(timevec(2)-timevec(1)),numel(freqdomain)+1);
freqvec = freqvec(1:numel(freqdomain));
end


