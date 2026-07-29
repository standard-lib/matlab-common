function res = combine(stats, a)
% COMBINE 複数の統計量セットの線形和を算出する
%   自由度の異なる統計量セットの線形和の場合，新たな統計量は多変量ウェルチ近似による有効自由度を返す．
% 使用法:
%   res = combine(stats1, a1, stats2, a2, ...)
%
% 入力:
%   stats_i : 構造体 (.m, .S, .V, .nu)
%   a_i     : スカラー定数 または k x k の行列
%
% 出力:
%   combined_stats : 以下のフィールドを持つ構造体
%       .m  : 合成された平均ベクトル
%       .S  : 合成された不偏共分散行列 (和の分散)
%       .V  : 合成された平均の分散行列 (信頼楕円用)
%       .nu : 有効自由度 (Welch-Satterthwaite)

    arguments (Repeating)
        stats (1,1) struct % .m, .S, .V, .nu を持つ構造体
        a                  % スカラー定数 または n x k の行列
    end

    % 入力ペアの数を取得
    n = numel(stats);
    if n == 0
        error('少なくとも1つの統計量セットと定数のペアが必要です。');
    end

    % 最初のペアを見て、出力されるべき次元 m を決定する
    k1 = size(stats{1}.m, 1);
    if isscalar(a{1})
        m = k1; % スカラーの場合は入力次元 = 出力次元
    else
        m = size(a{1}, 1); % 行列の場合はその行数が出力次元
    end
    
    pages = size(stats{1}.m,3);

    % 初期化
    m_sum = zeros(m, 1, pages);
    S_sum = zeros(m, m, pages);
    V_sum = zeros(m, m, pages);
    welch_denom = zeros(1,1,pages);

    for i = 1:n
        s_i = stats{i};
        a_i = a{i};
        ki = size(s_i.m, 1); % 入力次元

        % 変換行列 A の確定と次元チェック
        if isscalar(a_i)
            % スカラー指定の場合、入力次元と出力次元が一致している必要がある
            assert(m == ki, ...
                '引数 %d: 出力次元 m=%d と入力次元 k=%d が異なるため、スカラーによる係数指定はできません。行列形式で指定してください。', i*2, m, ki);
            A = a_i * eye(ki);
        else
            % 行列指定の場合、サイズが [m x ki] である必要がある
            assert( isequal(size(a_i), [m, ki] ), ...
                '引数 %d: 行列のサイズが不適切です。期待されるサイズ: [%d x %d], 入力サイズ: [%d x %d]', i*2, m, ki, size(a_i, 1), size(a_i, 2));
            A = a_i;
        end
        % 線形変換の適用
        % 平均ベクトル: m_y = A * m_x
        m_trans = pagemtimes(A, s_i.m);
        % 不偏共分散（データのばらつき）: S_y = A * S_x * A'
        S_trans = pagemtimes(pagemtimes(A, s_i.S), A');      
        % 平均の分散（不確かさ）: V_y = A * V_x * A'
        % ※ 入力 s_i.V を直接使用し、座標変換 A を施す
        V_i_trans  = pagemtimes(pagemtimes(A, s_i.V), A');

        % 2. 線形和の累積
        m_sum = m_sum + m_trans;
        S_sum = S_sum + S_trans;
        V_sum = V_sum + V_i_trans;

        % 3. 有効自由度（Nel and van der Merwe 近似）の分母項の累積
        % 分母の計算には、各成分が「最終的な V_sum」に対して寄与している 
        % 「変換後の V_i_trans」を使用する。
        % term = (tr(Vi^2) + (tr Vi)^2) / nu_i
        term_num = pagetrace(pagemtimes(V_i_trans, V_i_trans)) + (pagetrace(V_i_trans)).^2;
        welch_denom = welch_denom + (term_num ./ s_i.nu);
    end

    % 全体の有効自由度 nu_eff の算出
    % nu_eff = (tr(V_sum^2) + (tr V_sum)^2) / welch_denom
    if(welch_denom ~= 0)
        nu_eff = (pagetrace(pagemtimes(V_sum,V_sum)) + (pagetrace(V_sum)).^2) ./ welch_denom;
    else
        nu_eff = inf;
    end

    % 結果の返却
    res.m  = m_sum;   
    res.S  = S_sum;   
    res.V  = V_sum;   % 合成された不確かさの情報
    res.nu = nu_eff;  
end

function traces = pagetrace(X)
    % X: [n x n x S] の3次元配列
    n = size(X, 1);
    % 各ページを [n^2 x S] の行列に変形（各列が1ページ分）
    X_reshaped = reshape(X, n*n, []);
    % 各ページ内での対角要素のインデックス (1, n+1, 2n+1, ..., n^2) を使って抽出して縦方向に合計を取る
    traces = sum(X_reshaped(1 : n+1 : end, :), 1);
    traces = reshape(traces,1,1,[]);
end