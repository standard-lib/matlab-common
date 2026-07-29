% statライブラリの典型的な使用方法
% 統計的な正確性の検証は./test/stat_test.mを参照のこと．

% 実験データの処理方法
% 実験データの模擬（2行100列のデータ）行方向の2次元のデータを100回採ったという設定
N = 100; %サンプルサイズ
X = getExperimentData(1,N);

tiledlayout(1,2); nexttile;
xline(0); hold on; yline(0) %軸の描画
h_plot = plot(X(1,:), X(2,:), 'o', DisplayName="plots");% データ点の描画

% 標本平均ベクトルと不偏共分散行列の計算
stats = stat.get_stats(X);
% 95%信頼楕円(P=0.95)の描画
[h, ellip] = stat.plot_conf_ellipse(stats,0.95,DisplayName="95% confidence ellipse"); hold off;
legend([h_plot, h])

% 絶対値の表示
nexttile
% 楕円の大きさの測定．ABSが原点からの距離，ARGが原点を中心とする角度に関する構造体
[ABS,ARG,~,~] = stat.measure_ellipse(ellip);
bar(0, ABS.mean); hold on
er = errorbar(0, ABS.mean, ABS.neg, ABS.pos);
er.Color = [0 0 0];er.LineStyle = "none";
hold off




function X = getExperimentData(number,N)
    % 適当な母集団分布の特徴を設定
    if(number == 1)
        mu = [1;0.2]  ; %真の平均ベクトル
        A = [1.5 0; .5 1.0]; % 独立2変量正規分布を線形変換する行列
    else
        mu = [-0.1;0.4]  ; %真の平均ベクトル
        A = [1.0 .3; 0 2.0];
    end        
    Sigma = A*A'; %真の共分散行列
    X = stat.make_sample(mu,Sigma, N, 1);
end