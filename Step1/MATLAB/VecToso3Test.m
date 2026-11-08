function tests = VecToso3Test
tests = functiontests(localfunctions);
end

function testZero(testCase)
w_hat = zeros(3,1);
actual = ECE569_VecToso3(w_hat);
expected = zeros(3);
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testCol(testCase)
w_hat = [1 2 3]';
actual = ECE569_VecToso3(w_hat);
expected = [0 -3 2; 3 0 -1; -2 1 0];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end
