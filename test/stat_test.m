% stat_test

% 多変量データテスト
% テスト１：c4の補正の有効性のテスト：有限標本からある方向v_majorへの標準偏差（標準偏差楕円のv_major方向への半径）をc4補正を入れて推定．複数回の標本に対して計算し期待値を数値計算する．
% これと母集団分布の真の共分散行列から計算した標準偏差楕円の長辺と短辺の大きさを計算しておく．標本数を増やしたときに推定値が不偏性を持っていなければ，真の標準偏差楕円の長辺の大きさには収束しない．
% テスト２：平均値の信頼区間テスト：
% 有限標本で平均ベクトルの信頼区間を推定し，真の平均が入っているかをチェック．
% 信頼区間で設定したパーセンテージと一致するかを確認する．

addpath("..")

A = [1.0 0; -.5 1.0];
Sigma = A*A'; %真の共分散行列
mu = [-2;0]  ; %真の平均ベクトル
% 真の固有ベクトル方向を特定する
[V, D] = eig(Sigma);
v_major = V(:, 2); % 最大固有値に対応する固有ベクトル

%有限標本を複数回作成
N = 5;            % 小標本の場合 N=5 を考える
sampleMax = 1e6;  % 試行回数の最大値
%独立ガウス分布から（依存性のある）多変量正規分布に従う仮想実験データの作成
%ガウス分布変数の作成．
% Z = randn(2,N,sampleMax);
% X = mu + pagemtimes(A,Z);
X = stat.make_sample(mu, Sigma, N, sampleMax);
% ここから実験での統計処理を模擬する．

stats = stat.get_stats(X); % 平均と共分散などの計算

% 標本共分散からの（長辺方向の標準偏差の計算）
sd = sqrt(pagemtimes(v_major,"ctranspose", pagemtimes(stats.S,v_major),"none"));
sd = squeeze(sd);

avg_sd = cumsum(sd)./(1:sampleMax)';
% c4係数による修正
avg_sd_corr = cumsum(sd)./(1:sampleMax)'/stat.c4(N);
true_sd = sqrt(D(2,2));

% 信頼楕円の推定
P = 0.95;
ellip = stat.conf_ellipse(stats, P);
in_conf_ellipse = stat.in_ellipse(mu, ellip);
rateInCIellipse = cumsum(squeeze(in_conf_ellipse))./(1:sampleMax)';

%%
figure(1)
tiledlayout(1,2)
nexttile
true_stats.m = mu;
true_stats.S = Sigma;
true_stats.nu = inf;
hsd_true = stat.plot_sd_ellipse(true_stats,DisplayName = "True SD ellipse");
hold on;
axis equal
hSample = plot(X(1,:,1), X(2,:,1), 'o', DisplayName = "Sample");
first_stats.m = stats.m(:,:,1);
first_stats.S = stats.S(:,:,1);
first_stats.V = stats.V(:,:,1);
first_stats.nu = stats.nu;
hsd_pred = stat.plot_sd_ellipse(first_stats, '--', DisplayName = "Predicted SD ellipse");
legend([hSample, hsd_pred, hsd_true]);
title("標準偏差楕円の半径の補正 "+ sprintf("サンプルサイズ N = %d", N))
hold off;
nexttile
% 標準偏差の期待値の計算
hwithoutc4 = semilogx(1:sampleMax, avg_sd, DisplayName="$\sqrt{\textbf{v}^\top \textbf{S v}}$");
hold on;
hwithc4 = semilogx(1:sampleMax, avg_sd_corr,DisplayName="$\sqrt{\textbf{v}^\top \textbf{S v}}/c_4$");
yline(true_sd,DisplayName="$\sqrt{\textbf{v}^\top \textbf{\Sigma v}}$");
legend([hwithoutc4, hwithc4],Location="southwest", Interpreter="latex")
xlabel("試行回数 Number of trials")
ylabel("Estimated and true standard deviations in the \textbf{v} direction",Interpreter="latex")
title("標準偏差の期待値の補正")
msg = {
    '{\it c}_4 補正した赤いプロットが';...
    '真の{\bf v}方向の標準偏差に収束'
};
t = annotation('textbox', [0.7, 0.15, 0.2, 0.2], ...
    'String', msg, ...
    'Interpreter', 'tex', ...
    'FontSize', 11, ...
    'BackgroundColor', 'w');
ylim([true_sd-0.5 true_sd+0.5])
hold off;

%%

figure(2)
x = 1:sampleMax;
hplt = semilogx(x, rateInCIellipse,DisplayName="信頼楕円に入る割合");
hold on;
hsig = semilogx(x,P+sqrt(P*(1-P)./x),'k',DisplayName="確率Pの二項分布の標準偏差");
semilogx(x,P-sqrt(P*(1-P)./x),'k')
xlabel("試行回数 Number of trials")
ylabel("信頼楕円の中に真の標本平均が入る割合")
yline(P);
title("信頼楕円の中に真の標本平均が入る割合 "+sprintf("P = %.3f, N = %d",P,N))
legend([hplt hsig]);
ylim([P-0.02 P+0.02]);
hold off;

%%
figure(3)
tiledlayout(1,2)
% 小標本 N=5 と大標本 N=100のシミュレーション
for Ns=[5 100]
    nexttile
    Xs = stat.make_sample(mu,Sigma,Ns,1); %平均mu, 共分散Sigmaの，サンプルサイズNsの標本を1つだけ生成
    hs = plot(Xs(1,:), Xs(2,:), 'o', DisplayName="Sample");
    hold on
    stats = stat.get_stats(Xs);
    % ms = mean(Xs,2);
    % Ss = pagemtimes(Xs - ms, pagetranspose(Xs - ms))/(Ns-1);
    % 真の標準偏差楕円と平均値
    hsdtrue = stat.plot_sd_ellipse(true_stats,DisplayName="True SD ellipse");
    plot(mu(1), mu(2), '+', MarkerSize=10)
    % 標準偏差楕円
    hsd = stat.plot_sd_ellipse(stats, DisplayName="SD ellipse");
    % 95%確率楕円
    Pprob = 0.95;
    hprob = stat.plot_prob_ellipse(stats,Pprob, DisplayName=sprintf("%d%% Probability ellipse",Pprob*100));
    % 平均ベクトル95%信頼楕円
    Pconf = 0.95;
    hconf = stat.plot_conf_ellipse(stats,Pconf, DisplayName=sprintf("%d%% Confidence ellipse", Pconf*100));
    axis equal
    legend([hs, hsdtrue, hsd, hprob, hconf])
    title(sprintf("Simulation of Bivariate normal distribution: Sample size N = %d", Ns))
    hold off
end


%% measure_ellipseのテスト
figure(4)
Nm = 100;
Xm = stat.make_sample(mu,Sigma,Nm,1); %平均mu, 共分散Sigmaの，サンプルサイズNmの標本を1つだけ生成
stats = stat.get_stats(Xm);

tiledlayout(1,2)
nexttile
% 標準偏差楕円とその楕円の測定
[h,ellip] = stat.plot_sd_ellipse(stats, DisplayName="SD ellipse");
title("SD ellipse")
hold on
axis equal
% 楕円の大きさを測定
[ABS,ARG,X,Y] = stat.measure_ellipse(ellip);
xline(0,LineWidth=2)
yline(0,LineWidth=2)
xline([X.mean-X.neg,X.mean,X.mean+X.pos])
yline([Y.mean-Y.neg,Y.mean,Y.mean+Y.pos])
leng = hypot(stats.m(1),stats.m(2))*2;
plot([0 leng*cos(ARG.mean)], [0 leng]*sin(ARG.mean))
plot([0 leng]*cos(ARG.mean+ARG.pos), [0 leng]*sin(ARG.mean+ARG.pos))
plot([0 leng]*cos(ARG.mean-ARG.neg), [0 leng]*sin(ARG.mean-ARG.neg))
plot_circle(ABS.mean);
plot_circle(ABS.mean+ABS.pos);
plot_circle(ABS.mean-ABS.neg);
plot(Xm(1,:), Xm(2,:), 'o', DisplayName="Sample");
plot(stats.m(1), stats.m(2), '+', MarkerSize=10)
xlim([min(Xm(1,:)), max(Xm(1,:))])
ylim([min(Xm(2,:)), max(Xm(2,:))])
hold off

nexttile
% 信頼楕円とその楕円の測定
Pm = 0.95;
[h,ellip] = stat.plot_conf_ellipse(stats,Pm, DisplayName="confidence ellipse");
title("95% confidence ellipse")
hold on
axis equal
% 楕円の大きさを測定
[ABS,ARG,X,Y] = stat.measure_ellipse(ellip);
xline(0,LineWidth=2)
yline(0,LineWidth=2)
xline([X.mean-X.neg,X.mean,X.mean+X.pos])
yline([Y.mean-Y.neg,Y.mean,Y.mean+Y.pos])
leng = hypot(stats.m(1),stats.m(2))*2;
plot([0 leng*cos(ARG.mean)], [0 leng]*sin(ARG.mean))
plot([0 leng]*cos(ARG.mean+ARG.pos), [0 leng]*sin(ARG.mean+ARG.pos))
plot([0 leng]*cos(ARG.mean-ARG.neg), [0 leng]*sin(ARG.mean-ARG.neg))
plot_circle(ABS.mean);
plot_circle(ABS.mean+ABS.pos);
plot_circle(ABS.mean-ABS.neg);
plot(Xm(1,:), Xm(2,:), 'o', DisplayName="Sample");
plot(stats.m(1), stats.m(2), '+', MarkerSize=10)
xlim([min(Xm(1,:)), max(Xm(1,:))])
ylim([min(Xm(2,:)), max(Xm(2,:))])
hold off

%% 二つの異なるサンプルサイズの有限集合の線形結合による信頼楕円の推定
A1 = (rand(2,2)-0.5);
Sigma1 = A1*A1'; %真の共分散行列
A2 = (rand(2,2)-0.5)/3;
Sigma2 = A2*A2'; %真の共分散行列
mu1 = [1;0]  ; %真の平均ベクトル
mu2 = [0;1]  ; %真の平均ベクトル
stats_trueX.m = mu1; stats_trueX.S = Sigma1; stats_trueX.V = zeros(2); stats_trueX.nu = inf;
stats_trueY.m = mu2; stats_trueY.S = Sigma2; stats_trueY.V = zeros(2); stats_trueY.nu = inf;
% XとYを結合した新たな変量Zを考える。Zの統計値を計算
a1 = 1; a2 = 0.5;
stats_trueZ = stat.combine(stats_trueX, a1, stats_trueY, a2);
[V, D] = eig(stats_trueZ.S);
v_major = V(:, 2); % Zの最大固有値に対応する固有ベクトル
true_sd = sqrt(D(2,2)); %v_major方向の真の標準偏差（この値に標準偏差楕円のv_major方向の標準偏差は収束するはず）


% X, Yを1標本だけシミュレート
N1 = 10; N2 = 5;
P = 0.95;
X = stat.make_sample(mu1, Sigma1, N1,1); % ばらつきの大きい大標本
Y = stat.make_sample(mu2, Sigma2, N2,1); %ばらつきの小さい小標本
stats_x = stat.get_stats(X); stats_y = stat.get_stats(Y);
stats_z = stat.combine(stats_x,a1,stats_y,a2);
figure(5)
tiledlayout(1,2);
nexttile;
xline(0); hold on; yline(0);
[hx,~] = stat.plot_sd_ellipse(stats_x, 'b-', DisplayName = "SD ellipse:large sample/large cov");hold on;
[hy,~] = stat.plot_sd_ellipse(stats_y, 'r-', DisplayName = "SD ellipse:small sample/small cov");
[hz,~] = stat.plot_sd_ellipse(stats_z, '-',  DisplayName = "SD ellipse:estimated X+Y", Color='magenta');
legend([hx, hy, hz])
hold off

figure(6)
tiledlayout(1,2);
nexttile;
xline(0); hold on; yline(0);
[hx,~] = stat.plot_conf_ellipse(stats_x, P, 'b-', DisplayName = "95% Conf ellipse:large sample/large cov");hold on;
[hy,~] = stat.plot_conf_ellipse(stats_y, P, 'r-', DisplayName = "95% Conf ellipse:small sample/small cov");
[hz,~] = stat.plot_conf_ellipse(stats_z, P, '-',  DisplayName = "95% Conf ellipse:estimated X+Y", Color='magenta');
if(stat.in_ellipse(stats_trueZ.m, ellip_z))
    ht = plot(stats_trueZ.m(1), stats_trueZ.m(2), 'k+', MarkerSize = 10, DisplayName="True mean");
else
    ht = plot(stats_trueZ.m(1), stats_trueZ.m(2), 'r+', MarkerSize = 10, DisplayName="True mean");
end
legend([hx, hy, hz, ht])
hold off

% 二つの異なるサンプルサイズの有限集合の線形結合による信頼楕円の検証
sampleMax = 1e6; %試行回数
X = stat.make_sample(mu1, Sigma1, N1, sampleMax); % ばらつきの大きい大標本
Y = stat.make_sample(mu2, Sigma2, N2, sampleMax); %ばらつきの小さい小標本
stats_x = stat.get_stats(X); stats_y = stat.get_stats(Y);
% X, Yの大量のシミュレーションからそれぞれZの統計量を計算（大量の実験をしたことに相当）
% 「分散が異なる2つの集団の平均の差（あるいは和）を検定・推定する際、どのような分布に従うか」
% を扱っている。いわゆるベーレンス・フィッシャー問題で、厳密にPになる解は与えることができない。
% そのためこのプログラムでは「不偏共分散行列の和が、単一のウィシャート分布に従う」と仮定している。
% このとき合成された自由度は多変量ウェルチ近似（Nel and van der Merwe 近似）で近似できる。
stats_z = stat.combine(stats_x,a1,stats_y,a2);

% v_major方向の標準偏差
% 標本共分散からの（長辺方向の標準偏差の計算）+ c4係数による修正
sd = sqrt(pagemtimes(v_major,"ctranspose", pagemtimes(stats_z.S,v_major),"none"))./stat.c4(stats_z.nu+1);
sd = squeeze(sd);

avg_sd_corr = cumsum(sd)./(1:sampleMax)';


% 真の平均が推定したP信頼楕円に入る割合を計算（Pに収束するはず）
conf_ellip = stat.conf_ellipse(stats_z, P);
in_conf_ellipse = stat.in_ellipse(stats_trueZ.m, conf_ellip);
rateInCIellipse = cumsum(squeeze(in_conf_ellipse))./(1:sampleMax)';

figure(5)
nexttile
hwithc4 = semilogx(1:sampleMax, avg_sd_corr,DisplayName="$\sqrt{\textbf{v}^\top \textbf{S v}}/c_4$");
hold on;
ht = yline(true_sd,DisplayName="$\sqrt{\textbf{v}^\top \textbf{\Sigma v}}$");
legend([hwithc4, ht],Location="southwest", Interpreter="latex")
xlabel("試行回数 Number of trials")
ylabel("Estimated and true standard deviations in the \textbf{v} direction",Interpreter="latex")
title("標準偏差の期待値の補正")
ylim([true_sd-0.5 true_sd+0.5])
hold off;

figure(6)
nexttile
x = 1:sampleMax;
hplt = semilogx(x, rateInCIellipse,DisplayName="信頼楕円に入る割合");
hold on;
hsig = semilogx(x,P+sqrt(P*(1-P)./x),'k',DisplayName="確率Pの二項分布の標準偏差");
semilogx(x,P-sqrt(P*(1-P)./x),'k')
xlabel("試行回数 Number of trials")
ylabel("信頼楕円の中に真の標本平均が入る割合")
yline(P,'--');
title("信頼楕円の中に真の標本平均が入る割合 "+sprintf("P = %.3f",P))
legend([hplt hsig]);
ylim([P-0.05 P+0.05]);
hold off


function h = plot_circle(R,varargin)
    theta = linspace(0,2*pi,200);
    h = plot(R*cos(theta), R*sin(theta), varargin{:});
end

