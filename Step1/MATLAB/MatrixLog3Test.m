function tests = MatrixLog3Test
tests = functiontests(localfunctions);
end

function testIdentity(testCase)
R = eye(3);
actual = ECE569_MatrixLog3(R);
expected = zeros(3);
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testCaseB1(testCase)
R = [-1 0 0; 0 -1 0; 0 0 1];
actual = ECE569_MatrixLog3(R);
expected = [0 -pi 0; 
            pi 0 0;
            0 0 0];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testCaseB2(testCase)
R = [-1 0 0; 0 1 0; 0 0 -1];
actual = ECE569_MatrixLog3(R);
expected = [0 0 pi; 
            0 0 0;
            -pi 0 0];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testCaseB3(testCase)
R = [1 0 0; 0 -1 0; 0 0 -1];
actual = ECE569_MatrixLog3(R);
expected = [0 0 0; 
            0 0 -pi;
            0 pi 0];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testCaseOther(testCase)
theta = pi/4;
R = [cos(theta)  -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
actual = ECE569_MatrixLog3(R);
expected = [0 -pi/4 0; 
            pi/4 0 0;
            0 0 0];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end