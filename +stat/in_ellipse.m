function [tf] = in_ellipse(test_vec, ellip)
%IN_ELLIPSE この関数の概要をここに記述
%   詳細説明をここに記述
arguments (Input)
    test_vec double
    ellip struct
end
arguments (Output)
    tf
end
diff = test_vec - ellip.m; %2行1列sampleMaxページの配列
invS = pageinv(ellip.cov);
tf = pagemtimes(pagemtimes(pagetranspose(diff),invS),diff) < ellip.c.^2;
end
