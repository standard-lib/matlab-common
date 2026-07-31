function drawArrow(ax,x,y,color,size)
    currentHoldState = ishold(ax);
    line(ax,x,y,'Color',color);
    hold(ax,"on");
    x0 = x(2) - x(1);
    y0 = y(2) - y(1);
    p = (x0 + 1i*y0)/hypot(x0,y0);
    p1 = 0;
    p2 = (-1 + 0.5*1i)*p*size;
    p3 = (-1 - 0.5*1i)*p*size;
    pvect = [p1 p2 p3] + (x(2)+1i*y(2));
    poly = polyshape(real(pvect), imag(pvect));
    plot(ax,poly,'FaceColor', color, 'EdgeColor', color);
    if(currentHoldState)
        hstate = 'on';
    else
        hstate = 'off';
    end
    hold(ax, hstate);
end

