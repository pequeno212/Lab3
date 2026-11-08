%% Lab 3 Step 1 Starter Code

clear all;
close all;
clc;
% load csv data. Put data into column vectors.
% convert from degrees to radians
M = readmatrix("mocap_data.csv");

% Number of rows in M = Number of samples from motion capture system
N = size(M,1);

t = M(:,1);
x = M(:,2);
y = M(:,3);
z = M(:,4);

p = [x y z]; % position vector (in m)

roll = deg2rad(M(:,5));
pitch = deg2rad(M(:,6));
yaw = deg2rad(M(:,7));
%% 
% *Problem 1a*
% 
% For this problem, you need to use |subplot.|

% plot x,y,z data in subplots
%% 
% *Problem 1b*
% 
% We approximate the velocities using the definition of a derivative, and replacing 
% $h$ with $\Delta t$.
% 
% $$v(t) = \lim_{h \rightarrow 0^+} \frac{p(t+h)-p(t)}{h} \Rightarrowv(t_i) 
% \approx  \frac{p(t_{i+1})-p(t_i)}{t_{i+1}-t_i} $$

% Calculate velocities numerically
v = zeros(N,3);
for i=1:N-1
    % v(i,:) = ...
end
v(end,:) = v(end-1,:);

% plot the figure
%% 
% *Problem 1c*
% 
% First we need to convert roll-pitch-yaw to rotation matrices. You can either 
% use change of basis (MLS p. 31-33) or use the |eul2rotm| function from the Robotics 
% Toolbox to do the job. (This part is done for you.)

% convert rpy to rotation matrices by hand (MLS p. 31-33)
R = zeros(3,3,N);

% using inline functions to make our code easier to read
Rx = @(phi) [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
Ry = @(beta) [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
Rz = @(alpha) [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];

for i=1:N
    R(:,:,i) = Rz(yaw(i))*Ry(pitch(i))*Rx(roll(i));
end

% convert rpy to rotation matrices using Robotics Toolbox
% this code works identically to above!
% eul = [yaw pitch roll];
% Rotm = eul2rotm(eul,'ZYX');
%% 
% Now implement ECE569_MatrixLog3, ECE569_so3ToVec, ECE569_VecToso3, ECE569_AxisAng3 
% in their respective .m files. When you have written them, run the command "runtests" 
% in the Command Window.
% 
% Once you have done that, take a matrix logarithm to obtain $$\widehat{\omega} 
% \theta$ (the exponential coordinate of $R=e^{\widehat{\omega}\theta}$)$. Then, 
% perform manipulations to obtain $\hat \omega$ and $\theta$ where $\omega$ is 
% a unit vector representing the axis of rotation.

% get (w,theta) from e^(w_hat_theta)
w = zeros(N,3);
theta = zeros(N,1);
for i=1:N
    Ri = R(:,:,i);

    % Calculate the matrix logarithm as we learned in class
    % See MR textbook eqn. 3.58
    
    % you will need to assign values to w(i,:) and theta(i)

end
%% 
% Finally, plot the desired signals with appropriate labels.

% subplots
%% 
% *Problem 1d*
% 
% Take a matrix logarithm of $R(t_i)^\top R(t_{i+1})$ and then do manipulations 
% to obtain $\omega^b(t_i)$, which we defined as $\omega^b(t_i)=\frac{\omega(t_i)\theta(t_i)}{t_{i+1}-t_i}$.

% Calculate angular velocity
% make subplot
%% 
% *Problem 1e*
% 
% Plot the function $d(R(t),R_d)^2 = 2Tr(I-R^\top R_d)$ 

% calculate d^2
% plot the error from current rotation to desired rotation Rd = R(t_N)
