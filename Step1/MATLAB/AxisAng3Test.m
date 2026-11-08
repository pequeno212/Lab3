function tests = AxisAng3Test
tests = functiontests(localfunctions);
end

function testIdentityCol(testCase)
w_theta = [0 0 1]';
[actual_w, actual_theta] = ECE569_AxisAng3(w_theta);
actual = [actual_w', actual_theta];
expected = [0 0 1 1];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testNegativeCol(testCase)
w_theta = [0 0 -1]';
[actual_w, actual_theta] = ECE569_AxisAng3(w_theta);
actual = [actual_w', actual_theta];
expected = [0 0 -1 1];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testPosCol(testCase)
w_theta = [2 7 26 ]';
[actual_w, actual_theta] = ECE569_AxisAng3(w_theta);
actual = [actual_w', actual_theta];
expected = [2/27 7/27 26/27 27];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end

function testZeroCol(testCase)
w_theta = [0 0 0]';
[actual_w, actual_theta] = ECE569_AxisAng3(w_theta);
actual = [actual_w', actual_theta];
expected = [0 0 0 0];
verifyEqual(testCase,actual,expected,'AbsTol',1e-6);
end


