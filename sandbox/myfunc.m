function myfunc(inputArg1,inputArg2)
%UNTITLED5 この関数の概要をここに記述
%   詳細説明をここに記述
    arguments(Repeating)
        inputArg1
        inputArg2
    end
    for i = 1:numel(inputArg1)
        fprintf("axis %s, val %e\n", inputArg1{i}, inputArg2{i});
    end
end