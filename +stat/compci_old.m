function [ABS, ARG, Re, Im] = compci_old(mu, cov, conf)
%COMPCI 複素数の信頼区間を計算する(Nが十分に大きいときのみ有効）
%   mu: 平均値（スカラー複素数）
%   cov: 不偏共分散/Nの標準誤差に相当する分散
%   conf:信頼係数

    mulist = mu;
    assert(isscalar(conf));
    if(~iscell(cov))
        covcell = {cov};
    else
        covcell = cov;
    end
    M = numel(covcell);
    ABS.max = nan(1,M);
    ABS.min = nan(1,M);
    ARG.max = nan(1,M);
    ARG.min = nan(1,M);
    ARG.neg = nan(1,M);
    ARG.pos = nan(1,M);
    ABS.mean = abs(mu);
    ARG.mean = angle(mu);
    Re.mean = real(mu);
    Im.mean = imag(mu);
    for idxPts = 1:numel(covcell)
        if(~isscalar(mulist))
            mvec = [real(mulist(idxPts)),imag(mulist(idxPts))];
            mu = mulist(idxPts);
        else
            mvec = [real(mulist),imag(mulist)];
            mu = mulist;
        end
        cov = covcell{idxPts};
        [P, lambda] = eig(cov);
        k = sqrt(invcdf(conf, @(x) chi2(x,2), 0));

        v = @(theta) k*[cos(theta), sin(theta)]*sqrt(lambda)*P';
        pv = @(theta) v(theta) + mvec;
        dpv = @(theta) [-sin(theta), cos(theta)]*sqrt(lambda)*P';
        norm = @(theta) dpv(theta)*[0 1; -1 0];
        dist = @(th) pv(th)*pv(th)';
        ddist = @(th) pv(th)*dpv(th)';
        tcross = @(th) pv(th)*norm(th)';
        % plot(suv(1)*cos(theta)+muv(1), suv(2)*sin(theta)+muv(2))
        % pv = @(theta) [suv(1)*cos(theta)+muv(1), suv(2)*sin(theta)+muv(2)];
        % dist =  @(theta) (suv(1)*cos(theta)+muv(1)).^2+(suv(2)*sin(theta)+muv(2)).^2;
        % ddist = @(theta) -2*(suv(1)*cos(theta)+muv(1))*suv(1).*sin(theta)+2*(suv(2)*sin(theta)+muv(2))*suv(2).*cos(theta);
        % tcross = @(theta) (suv(1)*cos(theta)+muv(1))*suv(2).*cos(theta)+ (suv(2)*sin(theta)+muv(2))*suv(1).*sin(theta);
        maxmin1 = fzero(ddist, 0);
        r1 = sqrt(dist(maxmin1));
        maxmin2 = fzero(ddist,maxmin1+pi);
        r2 = sqrt(dist(maxmin2));
        ABS.max(idxPts)  = max(r1,r2);
        muv = mvec*P;
        if(muv(1)^2/lambda(1,1) + muv(2)^2/lambda(2,2) < k^2)% origin is in ellipse
            ABS.min(idxPts)  = 0;
            ARG.max(idxPts) = angle(mu) + pi;
            ARG.min(idxPts) = angle(mu) -pi;
        else
            ABS.min(idxPts) = min(r1,r2);
            tang1   = fzero(tcross,0);
            p1 = pv(tang1);
            tang2   = fzero(tcross,tang1+pi);
            p2 = pv(tang2);
            theta1 = angle(complex(p1(1),p1(2)));
            theta2 = angle(complex(p2(1),p2(2)));
            if(angle(mu)>max(theta1,theta2))
                ARG.max(idxPts) = min(theta1,theta2)+2*pi;
                ARG.min(idxPts) = max(theta1,theta2);
            elseif(angle(mu)<min(theta1,theta2))
                ARG.max(idxPts) = min(theta1,theta2);
                ARG.min(idxPts) = max(theta1,theta2)-2*pi;
            else
                ARG.max(idxPts) = max(theta1,theta2);
                ARG.min(idxPts) = min(theta1,theta2);
            end
        end
        xyamp = sqrt(v(0).^2 + v(pi/2).^2);
        Re.pos = xyamp(1);
        Re.neg = xyamp(1);
        Im.pos = xyamp(2);
        Im.neg = xyamp(2);
        
    
    end
    ABS.pos = ABS.max(:) - ABS.mean(:);
    ABS.neg = ABS.mean(:) - ABS.min(:);
    ARG.pos = ARG.max(:) - ARG.mean(:);
    ARG.neg = ARG.mean(:) - ARG.min(:);
end