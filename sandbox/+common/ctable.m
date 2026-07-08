classdef ctable < matlab.mixin.indexing.RedefinesDot ...
        & matlab.mixin.indexing.RedefinesParen ...
        & matlab.mixin.indexing.RedefinesBrace

    properties (Access=public)
        ctbl table
    end
    properties (Constant, Access = private)
        vname_Count = "[count]";
        vname_Count_alias = "count";
    end


    methods (Access=public)
        function obj = ctable(varargin)
            if(nargin==0)
                obj.ctbl = table();
            elseif(isa(varargin{1},'table'))
                obj.ctbl = varargin{1};
            elseif(isa(varargin{1},'common.ctable'))
                obj = varargin{1};
            else
                obj.ctbl = table(varargin{:});
            end
            obj = obj.setCount();
        end

        function obj = setCount(obj)
            varnames = string(obj.ctbl.Properties.VariableNames);
            varnames_wo_count = varnames(varnames~=common.ctable.vname_Count);
            tbl_to_count = obj.ctbl(:,varnames_wo_count);
            [~, ia, ic] = unique(tbl_to_count, 'stable');
            if(numel(ia)~=numel(ic))
                countrow = ones(size(obj.ctbl, 1), 1);
                uniq_counter = ones(numel(ia),1);
                for idx = 1:size(obj.ctbl,1)
                    countrow(idx) = uniq_counter(ic(idx));
                    uniq_counter(ic(idx)) = uniq_counter(ic(idx))+1;
                end
                obj.ctbl.(common.ctable.vname_Count) = countrow;
            end
        end

        function out = cat(dim, varargin)
            % abstract method in RedefinesParen
            assert(dim<=2 && 1<=dim);
            numCatArrays = nargin -1;
            newArgs = cell(numCatArrays,1);
            for ix = 1:numCatArrays
                if isa(varargin{ix},"common.ctable")
                    ct = varargin{ix};
                    newArgs{ix} = ct.ctbl;
                else
                    newArgs{ix} = varargin{ix};
                end
            end
            out = common.ctable();
            out.ctbl = cat(dim,newArgs{:});
            out = out.setCount();
        end

        function vars = variables(obj)
            vars = table2cell(obj.ctbl);
        end

        function obj = plus(obj1, obj2)
            obj = cat(1,obj1,obj2);
        end

        function objout = empty(varargin)
            % abstract method in RedefinesParen
            objout.ctbl = table.empty(varargin);
        end

        function sz = size(obj,varargin)
            % abstract method in RedefinesParen
            sz = size(obj.ctbl);
        end

        function disp(obj)
            obj.ctbl.Properties.RowNames = string(num2str((1:size(obj.ctbl,1))'));
            disp(obj.ctbl);
        end
    end
    
    methods (Access = public)

        function lin_index = find(obj, varnames, specify_vals)
            arguments
                obj
            end
            arguments(Repeating)
                varnames
                specify_vals
            end
            varnames = string(varnames);
            assert(numel(varnames) == numel(specify_vals));
            varnames(varnames==common.ctable.vname_Count_alias)=common.ctable.vname_Count;
            entries = size(obj.ctbl,1);
            logical_idx = true(entries,1);
            for idxDim = 1:numel(varnames)
                part_logical_idx = false(entries,1);
                val_list = obj.ctbl.(varnames(idxDim));
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
            [varargout{1:nargout}] = obj.ctbl.(indexOp);
        end

        function obj = dotAssign(obj,indexOp,varargin)
            if isempty(obj)
                obj = varargin{1};
            end
            [obj.ctbl.(indexOp)] = varargin{:};
        end
        
        function n = dotListLength(obj,indexOp,indexContext)
            n = listLength(obj.ctbl,indexOp,indexContext);
        end
    end
    methods (Access = protected)
        function varargout = parenReference(obj,indexOp) 
            % abstract method in RedefinesParen
            %indexOpの1つ目はカッコの処理なので，これをtableに処理させる
            % 一般にはこれで，部分tableが得られるので，これを新しいtableとするようなオブジェクトを作る．
            obj.ctbl = obj.ctbl.(indexOp(1));
            % indexOpが一つだけのときはカッコだけで後ろに何もついていないので，このまま新しいオブジェクトを返して終わり
            if(isscalar(indexOp))
                varargout{1} = obj;
                return
            end
            % 後ろに演算子が続くときは，次の演算子を処理させるため，obj.に投げる．
            [varargout{1:nargout}] = obj.(indexOp(2:end));
        end
        
        function obj = parenAssign(obj,indexOp,varargin)
            % abstract method in RedefinesParen
            if isempty(obj)
                obj = varargin{1};
            end
            if( isscalar(indexOp) )
                if( strcmp( class(obj), "common.ctable" ))
                    rhs = varargin{1};
                    obj.ctbl.(indexOp) = rhs.ctbl;
                else
                    %　入力はTableかセル配列ならそのまま代入
                    obj.ctbl.(indexOp) = varargin{1};
                end
                return
            end
            objtmp = obj;
            objtmp.ctbl = obj.ctbl.(indexOp(1));
            [objtmp.(indexOp(2:end))] = varargin{:};
            obj.ctbl.(indexOp(1)) = objtmp.ctbl;
        end
        function obj = parenDelete(obj,indexOp)
            % abstract method in RedefinesParen
            obj.ctbl.(indexOp) = [];
        end
        function n = parenListLength(obj,indexOp,indexingContext)
            % abstract method in RedefinesParen
            n = listLength(obj.ctbl,indexOp,indexingContext);
        end
        
        function varargout = braceReference(obj,indexOp) 
            % abstract method in RedefinesBrace
            if(~isscalar(indexOp))
                warning("ctable:braceReference","中括弧の処理以降に演算子をつけることが想定されていません．新しい使い方があれば提案ください")
            end
            [varargout{1:nargout}] = obj.ctbl.(indexOp);
        end
        function obj = braceAssign(obj,indexOp,varargin)
            % abstract method in RedefinesBrace
            if(~isscalar(indexOp))
                warning("ctable:braceAssign","中括弧の処理以降に演算子をつけることが想定されていません．新しい使い方があれば提案ください")
            end
            [obj.ctbl.(indexOp)] = varargin{1};
        end
        function n = braceListLength(obj,indexOp,indexingContext)
            % abstract method in RedefinesBrace
            n = listLength(obj.ctbl,indexOp,indexingContext);
        end
    end
end