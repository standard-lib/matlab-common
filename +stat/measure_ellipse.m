function [ABS, ARG, X, Y] = measure_ellipse(ellip)
%楕円の大きさを計算する
%   mu: 標本平均ベクトル（スカラー複素数）
%   cov: 不偏共分散行列
%   mahala:楕円の半径：マハラノビス距離
    m = ellip.m;
    S = ellip.cov;
    mahala = ellip.c;
    ABS.max = nan;   ABS.min = nan;
    ABS.mean = hypot(m(1),m(2));
    ARG.max = nan;   ARG.min = nan;
    ARG.neg = nan;   ARG.pos = nan;
    ARG.mean = atan2(m(2),m(1));
    X.mean = m(1);
    Y.mean = m(2);
    mvec = reshape(m,1,2);

    [P, lambda] = eig(S);
    
    v = @(theta) mahala*[cos(theta), sin(theta)]*sqrt(lambda)*P';
    pv = @(theta) v(theta) + mvec;
    dpv = @(theta) [-sin(theta), cos(theta)]*sqrt(lambda)*P';
    norm = @(theta) dpv(theta)*[0 1; -1 0];
    dist = @(th) pv(th)*pv(th)';
    ddist = @(th) pv(th)*dpv(th)';
    tcross = @(th) pv(th)*norm(th)';
    maxmin1 = fzero(ddist, 0);
    r1 = sqrt(dist(maxmin1));
    maxmin2 = fzero(ddist,maxmin1+pi);
    r2 = sqrt(dist(maxmin2));
    ABS.max  = max(r1,r2);
    muv = mvec*P;
    if(muv(1)^2/lambda(1,1) + muv(2)^2/lambda(2,2) < mahala^2)% origin is in ellipse
        ABS.min  = 0;
        ARG.max = atan2(m(2),m(1)) + pi;
        ARG.min = atan2(m(2),m(1)) -pi;
    else
        ABS.min = min(r1,r2);
        tang1   = fzero(tcross,0);
        p1 = pv(tang1);
        tang2   = fzero(tcross,tang1+pi);
        p2 = pv(tang2);
        theta1 = atan2(p1(2),p1(1));
        theta2 = atan2(p2(2),p2(1));
        if(atan2(m(2),m(1))>max(theta1,theta2))
            ARG.max = min(theta1,theta2)+2*pi;
            ARG.min = max(theta1,theta2);
        elseif(atan2(m(2),m(1))<min(theta1,theta2))
            ARG.max = min(theta1,theta2);
            ARG.min = max(theta1,theta2)-2*pi;
        else
            ARG.max = max(theta1,theta2);
            ARG.min = min(theta1,theta2);
        end
    end
    xyamp = sqrt(v(0).^2 + v(pi/2).^2);
    X.pos = xyamp(1);
    X.neg = xyamp(1);
    Y.pos = xyamp(2);
    Y.neg = xyamp(2);
    ABS.pos = ABS.max(:) - ABS.mean(:);
    ABS.neg = ABS.mean(:) - ABS.min(:);
    ARG.pos = ARG.max(:) - ARG.mean(:);
    ARG.neg = ARG.mean(:) - ARG.min(:);
end