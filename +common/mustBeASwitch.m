function mustBeASwitch(a)
%MUSTBESWITCH 関数のオプション引数としてon/offあるいはtrue/falseを受け付ける引数のチェック
mustBeA(a,["string","char","logical"]);
if (isa(a,"string") || isa(a,"char"))
    mustBeMember(string(lower(a)),["on","off"]);
end
end