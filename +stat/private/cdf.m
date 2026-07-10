function [C] = cdf(x, pdf, xmin)
%CDF 確率密度関数関数pdfに対する累積分布関数
%   pdf(xmin)からpdf(x)までの積分を返す．
%   xとしてベクトルを受け入れる．
    arguments(Input)
        x {mustBeReal}
        pdf {mustBeA(pdf,"function_handle")}
        xmin {mustBeReal}
    end
    C = zeros(1,numel(x));
    for idx = 1:numel(x)
        if(x(idx)>xmin)
            C(idx) = integral(pdf, xmin, x(idx));
        end
    end
end