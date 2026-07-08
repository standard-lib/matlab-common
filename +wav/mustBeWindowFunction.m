function mustBeWindowFunction(a)
    windowNameList = ["hann", "rect"];
    if ~(isa(a,'function_handle') || ismember(lower(a),windowNameList))
        eidType = 'mustBeWindowFunction:notWindowFunction';
        msgType = 'Input must be a function handle of normalized window function, or window function name.';
        throwAsCaller(MException(eidType,msgType))
    end
end