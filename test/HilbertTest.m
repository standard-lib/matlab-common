classdef HilbertTest < matlab.unittest.TestCase
    % HilbertTest tests output of the common.hilbert
    
    methods (Test)
        function testEvenNumberInput(testCase)
            addpath("..");
            input = [1 4 3.4 2 3 1];
            actOutput = common.hilbert(input);
            expOutput = hilbert(input);
            testCase.verifyEqual(actOutput,expOutput);
        end
        function testOddNumberInput(testCase)
            addpath("..");
            input = [1 4.3 2 3 1];
            actOutput = common.hilbert(input);
            expOutput = hilbert(input);
            testCase.verifyEqual(actOutput,expOutput);
        end
    end
    
end