function tests = so3ToVecTest
tests = functiontests(localfunctions);
end

function testZero(testCase)
w_hat = zeros(3);
actual = ECE569_so3ToVec(w_hat);
expected = zeros(3,1);
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testIdentity(testCase)
w_hat = eye(3);
actual = ECE569_so3ToVec(w_hat);
expected = zeros(3,1);
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testPositive(testCase)
w_hat = [0 -3 2; 3 0 -1; -2 1 0];
actual = ECE569_so3ToVec(w_hat);
expected = [1;2;3];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testNegative(testCase)
w_hat = -1*[0 -3 2; 3 0 -1; -2 1 0];
actual = ECE569_so3ToVec(w_hat);
expected = -1*[1;2;3];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end
