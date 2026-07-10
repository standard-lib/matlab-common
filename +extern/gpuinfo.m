function info = gpuinfo()
%UNTITLED2 この関数の概要をここに記述
%   詳細説明をここに記述
    if(~license('test','distrib_Computing_Toolbox'))
        fprintf('No license of Parallel Computing Toolbox\n')
        info = [];
        return;
    end
    if(gpuDeviceCount == 0)
        fprintf('No GPU device detected\n');
        info = [];
        return;
    end
    info = gpuDevice();
    % disp(['GPU: ',gpu_info.Name]);
end