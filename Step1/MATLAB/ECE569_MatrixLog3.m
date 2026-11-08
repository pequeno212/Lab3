function w_hat_theta = ECE569_MatrixLog3(R)
% This function implements the matrix log function
% for a 3x3 rotation matrix R using
% Algorithm: (MR eqn. 3.58)
%
% Input: R = expm(w_hat*theta); 3x3 rotation matrix
% Returns: w_hat*theta = logm(R) is the exponential coordinate
% represented as a skew-symmetric 3x3 matrix.
% If tr(R) = 1, then the axis is not defined
% so we just return all zeros.

% There are main cases to consider, following the algorithm

if ismembertol(trace(R), 3)
    % case (a) check if tr(R) == 3 (within numerical tolerance)
    % the exponential coordinate is undefined here, return all zeros
    w_hat_theta = zeros(3);

elseif ismembertol(trace(R), -1)
    % case (b) check if tr(R) == -1 (within numerical tolerance)
    theta = pi;

    % three subcases to avoid dividing by zero
    if ~ismembertol(R(3,3),-1)
        % case (b.1) check r33 is not -1
        % w_hat = ...

    elseif ~ismembertol(R(2,2),-1)
        % case (b.2) check r22 is not -1
        % w_hat = ...

    else
        % case (b.3) check r11 is not -1
        % w_hat = ...
    end
    
    % You must return a skew-symmetric matrix
    % w_hat_theta = ...

else
    % case (c) this condition runs in all other cases
    % theta = ...
    % w_hat = ...
    w_hat_theta = w_hat*theta;
end
end