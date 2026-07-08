classdef lindex < matlab.mixin.indexing.RedefinesDot & matlab.mixin.indexing.RedefinesParen
     

    properties (Access=public)
        varTable table
    end
    properties (Constant, Access = private)
        vname_Count = "[count]";
        vname_Count_alias = "count";
    end


    methods (Access=public)
        function obj = lindex(varNames, values, option)
            arguments
                varNames (1,:) string = string.empty(1,0);
                values = {}
                option.varTypes (1,:) string = string.empty(1,0);
            end
            varTypes = option.varTypes;
            if numel(varTypes) == 0
                % とりあえず，今のところはvariableとして許すのは数値のみとする
                varTypes = repmat("double", [1 size(varNames,2)]);
            end
            varNames(varNames == common.lindex.vname_Count_alias) = common.lindex.vname_Count;
            obj.varTable = table('Size', [0 size(varNames,2)], 'VariableTypes', varTypes , 'VariableNames', varNames);
            if numel(values)~= 0 
                obj = obj.cat(values);
            end
        end

        function obj = cat(obj, obj2)
            % abstract method in RedefinesParen
            arguments
                obj
                obj2 = {};
            end
            if strcmp(class(obj2),"lindex")
                vars = obj2.variables();
            else
                vars = obj2;
            end
            if(~iscell(vars))
                vars = num2cell(vars);
            end
            for idxAppend = 1:size(vars,1)
                specify_vals = vars(idxAppend,:);
                varnames = string(obj.varTable.Properties.VariableNames);
                varnames_wo_count = varnames(varnames~=common.lindex.vname_Count);
                lin_index = obj.find(varnames_wo_count, specify_vals);
                if(~ismember(common.lindex.vname_Count, varnames) && numel(lin_index)~=0)
                    obj.varTable.(common.lindex.vname_Count) = ones(size(obj.varTable, 1), 1);
                end
                varnames = string(obj.varTable.Properties.VariableNames);
                if(ismember(common.lindex.vname_Count, varnames))
                    specify_vals{end+1} = numel(lin_index)+1;
                end
                obj.varTable(end+1,:) = specify_vals;
            end
        end

        function vars = variables(obj)
            vars = table2cell(obj.varTable);
        end

        function obj = plus(obj1, obj2)
            obj = obj1.cat(obj2);
        end

        function objout = empty(varargin)
            % abstract method in RedefinesParen
            if(nargin == 1)
                sizeVector = varargin{1};
            end
            if(numel(sizeVector)<=3)
                checkIdx = 1;
            else
                checkIdx = [1, 3:numel(sizeVector)];
            end
            if( ~all(sizeVector(checkIdx) == 0))
                error("lindex:SizeNotSupported","The size of empty lindex should be [0 n 0 0...]");
            end
            objout = common.lindex("Var" + string([1:sizeVector(2)]));
        end

        function sz = size(obj,varargin)
            % abstract method in RedefinesParen
            sz = [size(obj.varTable,1),1];
        end

        function disp(obj)
            obj.varTable.Properties.RowNames = string(num2str((1:size(obj.varTable,1))'));
            disp(obj.varTable);
            % disp(addvars(obj.varTable,lin_idx,'before',1,'NewVariableNames','lindex'))
        end
    end
    
    methods (Access = public)
        function lin_index = find(obj, varnames, specify_vals)
            assert(numel(varnames) == numel(specify_vals));
            varnames(varnames==common.lindex.vname_Count_alias)=common.lindex.vname_Count;
            entries = size(obj.varTable,1);
            logical_idx = true(entries,1);
            for idxDim = 1:numel(varnames)
                part_logical_idx = false(entries,1);
                val_list = obj.varTable.(varnames(idxDim));
                specify_val_list = specify_vals{idxDim};
                if(iscell(specify_val_list)) % セル：範囲指定
                    part_logical_idx = part_logical_idx | (specify_val_list{1} <= val_list & val_list <= specify_val_list{2});
                else % 配列：リストとして指定
                    for idxList = 1:numel(specify_val_list)
                        specify_val = specify_val_list(idxList);
                        part_logical_idx = part_logical_idx | ...
                            abs(val_list - specify_val) <= eps |...
                            abs(val_list - specify_val) <= abs(specify_val*eps);
                    end
               end
                logical_idx = logical_idx & part_logical_idx;
            end
            lin_index = find(logical_idx);
        end
    end
    methods (Access = protected)
        function varargout = dotReference(obj,indexOp)
            [varargout{1:nargout}] = obj.varTable.(indexOp);
        end

        function obj = dotAssign(obj,indexOp,varargin)
            [obj.varTable.(indexOp)] = varargin{:};
        end
        
        function n = dotListLength(obj,indexOp,indexContext)
            n = listLength(obj.varTable,indexOp,indexContext);
        end
    end
    methods (Access = protected)
        function lin_index = parenReference(obj,indexOp) 
            % abstract method in RedefinesParen
            if(isstring(indexOp.Indices{1}) && any(indexOp.Indices{1} == string(obj.varTable.Properties.VariableNames)))
                varnames = string(indexOp.Indices(1:2:end));
                specify_vals = indexOp.Indices(2:2:end);
            else
                varnames = string(obj.varTable.Properties.VariableNames);
                specify_vals = indexOp.Indices(:);
                if(numel(specify_vals) == numel(varnames)-1)
                    % countが指定されていない場合と判断する
                    varnames = varnames(varnames~=common.lindex.vname_Count);
                end
            end
            lin_index = obj.find(varnames, specify_vals);
        end
        
        function obj = parenAssign(obj,indexOp,varargin)
            % abstract method in RedefinesParen
            error("lindex:CannotChange","Assign on lindex is prohibited");
        end

        function obj = parenDelete(obj,indexOp)
            % abstract method in RedefinesParen
            error("lindex:CannotChange","Deletion on lindex is prohibited");
       end
    
       function n = parenListLength(obj,indexOp,indexingContext)
            % abstract method in RedefinesParen
            error("lindex:UNDERCONSTRUCTION", "under construction.");
            % [keyExists, PKey] = convertKeysToPKey(obj, indexOp.Indices);
            % [keyExists,idx] = convertKeyToIndex(obj,indexOp(1).Indices);
            % if ~keyExists
            %     if indexingContext == matlab.indexing.IndexingContext.Assignment
            %         error("MyMap:MultiLevelAssignKeyDoesNotExist", ...
            %             "Unable to perform assignment. Key %s does not exist",...
            %         indexOp(1).Indices{1});
            %     end
            %     error("MyMap:KeyDoesNotExist",...
            %         "The requested key does not exist.");
            % end   
            % n = listLength(obj.Values{idx},indexOp(2:end),indexingContext);
        end
    end
end