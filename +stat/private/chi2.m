function p = chi2(x,nu)
%CHI2 カイ二乗分布の確率密度関数pdf
%   分散１の標準正規分布N(0,1)から独立に抽出したnu個の標本x_1, x_2, ..., x_nuの
%   自乗和　Z = x_1^2 + x_2^2 + ... + x_nu^2 が従う分布
    p = zeros(1,numel(x));
    idx = x>0;
    p(idx) = x(idx).^((nu/2)-1).*exp(-(x(idx)/2))/(2^(nu/2)*gamma(nu/2));
end
