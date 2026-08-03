function h = conf_ellipse(cov, mu, LineSpec, options)
%CONF_ELLIPSE 信頼楕円の描画
%   cov (required) 2x2 covariance matrix
%   mu  (optional) 1x2 mean of distribution
%   LineSpec (optional) line spec 
%   
arguments(Input)
    cov (2,2) double {mustBeReal,mustBeFinite}
    mu (1,2) double {mustBeReal,mustBeFinite} = [0 0]
    LineSpec = "-"
    options.points (1,1) double {mustBeInteger,mustBePositive} = 100;
    options.conf (1,1) double {mustBeReal, ...
        mustBeGreaterThanOrEqual(options.conf, 0.0), ...
        mustBeLessThanOrEqual(options.conf,1.0)} = 0.5;
    options.scale (1,1) double {mustBeReal} = 1.0;
    options.linewidth (1,1) double {mustBeReal} = 0.5;
end
    n = options.points;
    mu = reshape(mu,1,[]);
    theta = linspace(0,1,n)*2*pi;
    [P, lambda] = eig(cov);
    xy = [cos(theta'), sin(theta')]*sqrt(lambda)*P';

    k = sqrt(invcdf(options.conf, @(x) chi2(x,2), 0));
    
    pxy = options.scale*(k*xy+repmat(mu,[n,1]));
    
    h = plot(pxy(:,1), pxy(:,2), LineSpec, LineWidth = options.linewidth);
end