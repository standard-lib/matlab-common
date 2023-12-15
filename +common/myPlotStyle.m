function [  ] = myPlotStyle( xstr, ystr, titlestr )
%UNTITLED6 この関数の概要をここに記述
%   詳細説明をここに記述
set(gca, 'FontName', 'Arial', 'FontSize', 11);
xlabel(xstr, 'FontName', 'Arial', 'FontSize', 12);
ylabel(ystr, 'FontName', 'Arial', 'FontSize', 12);
title(titlestr, 'FontName', 'Arial', 'FontSize', 14);

end

