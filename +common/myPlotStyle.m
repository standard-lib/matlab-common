function [  ] = myPlotStyle( xstr, ystr, titlestr )
%UNTITLED6 ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q
set(gca, 'FontName', 'Arial', 'FontSize', 11);
xlabel(xstr, 'FontName', 'Arial', 'FontSize', 12);
ylabel(ystr, 'FontName', 'Arial', 'FontSize', 12);
title(titlestr, 'FontName', 'Arial', 'FontSize', 14);

end

