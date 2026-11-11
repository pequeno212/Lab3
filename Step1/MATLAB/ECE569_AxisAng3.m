function [w,theta] = ECE569_AxisAng3(w_theta)
% Given the product omega times theta,
% this function will return omega and theta separately
%
% Input: w_theta = omega*theta is a 3-vector
% returns: omega is a unit-length 3-vector
%          theta is a real number
%
% You should check that the input is not a zero vector
% If so, set theta=0 and set w=zeros(size(w_theta))


%theta = 
% w = ...

    if(w_theta == zeros(3,1))
        theta = 0;
        w = zeros(size(w_theta));
    else
        theta = norm(w_theta);
        w = w_theta / theta;
    end

end