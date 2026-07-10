% Keysight H5ファイル解析スクリプト
clear; clc; close all;

filename = 'test_data\rtape.h5'; % アップロードされたファイル名

% 読み込みたいチャンネルのリスト
channels = {'Channel 1', 'Channel 2', 'Channel 3'};

figure('Name', 'Keysight Oscilloscope Data');

for i = 1:length(channels)
    ch_name = channels{i};
    
    % --- 1. メタデータ（設定情報）の読み込み ---
    % ※KeysightのH5は、各チャンネル配下の「Header」にサンプリング情報が入っています
    header_path = sprintf('/Frame/Waveforms/%s/Header', ch_name);
    
    % 横軸（時間）計算用のパラメータを取得
    x_increment = h5read(filename, [header_path, '/XIncrement']);
    x_origin    = h5read(filename, [header_path, '/XOrigin']);
    num_points  = h5read(filename, [header_path, '/NumPoints']);
    
    % 縦軸（電圧）の単位やラベル（必要に応じて使用）
    y_units     = h5read(filename, [header_path, '/YUnits']);
    
    % --- 2. 波形データ（Rawデータ）の読み込み ---
    data_path = sprintf('/Frame/Waveforms/%s/Data', ch_name);
    y_data = h5read(filename, data_path);
    
    % --- 3. 時間軸（秒）の作成 ---
    % 各サンプリング点の時間を計算
    t_data = x_origin + (0:double(num_points)-1)' * x_increment;
    
    % --- 4. グラフへのプロット ---
    subplot(length(channels), 1, i);
    plot(t_data, y_data, 'LineWidth', 1.5);
    grid on;
    title(sprintf('Waveform: %s', ch_name));
    xlabel('Time (s)');
    ylabel(sprintf('Amplitude (%s)', y_units));
end
