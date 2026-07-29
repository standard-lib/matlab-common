function H = Fcum(x,d1,d2)
    H = zeros(size(x));
    valid_x = x(x>0);
    H(x>0) = betainc(d1*valid_x./(d1*valid_x+d2), d1/2, d2/2);
end