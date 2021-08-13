classdef PredictCasesTest < matlab.unittest.TestCase
    properties
       model
       mycty
       tt
       countyMasks
    end
    
    
    methods(TestMethodSetup)
        function loadModelData(testCase)
%             testCase.TestFigure = figure;
            load testData.mat tt mycty
            load expGPR.mat regressionGP
            load countyMasks countyMasks
            testCase.tt = tt;
            testCase.mycty = mycty;
            testCase.model = regressionGP;
            testCase.countyMasks = countyMasks;
        end
    end
    
    % [predData,dates] = predCases(model,mycty,newmaskrtgs,tvec,tt)
    
    methods(Test)
        
        function testDefaults(testCase)
            predData = predCases(testCase.model,testCase.mycty);
%             actSolution = quadraticSolver(1,-3,2);
%             n = length(predData);
            actualData = testCase.mycty.cases{1};            
%             expSolution = [2,1];
            testCase.verifySize(length(predData),length(actualData))
%             testCase.verifyEqual(actSolution,expSolution)
        end
%         function testNewmasks(testCase)
%             actSolution = quadraticSolver(1,2,10);
%             expSolution = [-1+3i, -1-3i];
%             testCase.verifyEqual(actSolution,expSolution)
%         end
%         function testTimetable(testCase)
%             testCase.verifyError(@()quadraticSolver(1,'-3',2), ...
%                 'quadraticSolver:InputMustBeNumeric')
%         end
%         function testTimevec(testCase)
%             actSolution = quadraticSolver(1,2,10);
%             expSolution = [-1+3i, -1-3i];
%             testCase.verifyEqual(actSolution,expSolution)
%         end
%         function testNewCounty(testCase)
% %             actSolution = quadraticSolver(1,2,10);
% %             expSolution = [-1+3i, -1-3i];
%             testCase.verifyEqual(actSolution,expSolution)
%         end
%         
%         
    end
end
% 
% 
% 
% function tests = predictCasesTest
% %     function tests = solverTest
% tests = functiontests(localfunctions);
% end
% 
% function testDefaults(testCase)
% % actSolution = quadraticSolver(1,-3,2);
% % expSolution = [2 1];
% verifyEqual(testCase,actSolution,expSolution)
% end
% 
% function testNewMasks(testCase)
% actSolution = quadraticSolver(1,2,10);
% expSolution = [-1+3i -1-3i];
% verifyEqual(testCase,actSolution,expSolution)
% end
% 
% 
% function testTimeVec(testCase)
% actSolution = quadraticSolver(1,2,10);
% expSolution = [-1+3i -1-3i];
% verifyEqual(testCase,actSolution,expSolution)
% end
% 
% 
% function testTimetable(testCase)
% actSolution = quadraticSolver(1,2,10);
% expSolution = [-1+3i -1-3i];
% verifyEqual(testCase,actSolution,expSolution)
% end
% 
% 
% % function teststartstopTimes(testCase)
% % actSolution = quadraticSolver(1,2,10);
% % expSolution = [-1+3i -1-3i];
% % verifyEqual(testCase,actSolution,expSolution)
% % end
