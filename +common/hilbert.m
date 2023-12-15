function out = hilbert(indata)
    n = numel(indata);
    freqdomain = fft(indata);
    h = zeros(1,numel(freqdomain));
    if(rem(n,2)==1)
        h(1) = 1;
        h(2:(n+1)/2) = 2;
    else
        h(1) = 1;
        h(n/2+1) = 1;
        h(2:n/2) = 2;
    end
    out = ifft(freqdomain(:).*h(:));
end