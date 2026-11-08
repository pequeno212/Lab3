%% *ECE 569 Lab3 Tutorial*
% If you are new to MATLAB, this tutorial will help you with the basic commands 
% you will need in order to complete this assignment.

clear all; % delete variables in current Workspace
close all; % close all figures (if any are open)
clc;       % clear the Command Window
% *Vectors and Matrices*
% MATLAB supports both row vectors and column vectors. Here are some examples:

row_vector_1 = zeros(1,6)   % 1 row, 6 columns
row_vector_2 = 1:10         % 1,2,3,4,...,9,10

column_vector_1 = ones(5,1) % 5 rows, 1 column
column_vector_2 = (3:2:13)' % the ' is the transpose operator
%% 
% Note that you can suppress output by using the semicolon ; at the end of the 
% line.

x_data = rand(3,1); % remove the ; to see the output
%% 
% To access an element inside a vector, use |()| for indexing. Note that in 
% MATLAB, indexing starts at 1.

row_vector_1(2) = 17            % index 2
row_vector_1(end) = 100         % end gives final index
column_vector_1(end-1) = 2*3    % end-1 works too!
%% 
% You can also define vectors using brackets [ ]

small_primes = [2 3 5 7 11 13]  % row vector
gas_prices = [3.81; 3.99; 4.25] % column vector
%% 
% Matrices are similarly defined and accessed.

R = ones(3,3)
I = eye(3)
M = [1 2 3; 4 5 6; 7 8 9]

% Change the (2,3) element of R
R(2,3) = 200

% Get the 3rd column of R.
% Think: Every row, 3rd column
R(:,3)

% Get the first row of M
% Think: first row, every column
M(1,:)

% Modify a section of a matrix
M(2:3,1:2) = -1*[11 12; 13 14]

% Transpose a matrix
M'
%% 
% You can construct a matrix from column vectors (and also row vectors).

c1 = [10; 20; 30];
c2 = [40; 50; 60];
C = [c1 c2]
%% 
% To check the size of a matrix of vector, use |size()|

size(C)
size(C,1) % number of rows
size(C,2) % number of columns
%% 
% What about a list of matrices? Sometimes, we want to use a single variable 
% to represent a bunch of different matrices of the same size. In this example, 
% we have 5 matrices, $A_1 \dots A_5$ each of which is a 2x2 matrix.

A = zeros(2,2,5);
A(:,:,1) = ones(2,2);
A(:,:,2) = rand(2,2);
A(:,:,3) = [1 2; 3 4];
A(:,:,4) = A(:,:,1) + A(:,:,3);
A
%% 
% Matrix multiplication, scalar multiplication, addition, subtraction work as 
% you would expect, but MATLAB also allows for element-wise operators.

x = 1:4;
5*x
2+x
x.^2 % square each element
exp(x) % e^x1 e^x2 ...
sin(x) % sin(x1) sin(x2) ...

A = magic(3);
B = diag([1 2 3])
A*B    % matrix multiplication
A.*B   % element-wise multiplcation
%% 
% Be careful with functions with matrices. Sometimes they are applied elementwise 
% and sometimes they are applied to the entire matrix. If you don't know, use 
% the |help| command in the Command Window

exp(A)   % element-wise exponential
expm(A)  % matrix exponential
help expm
%% 
% *Plotting and Subplots*
% 
% We can plot two vectors (x vector, y vector) using the plot command. In this 
% example, we simulate a spring-mass system with damping using a state space model 
% (simulating a model is not required on this homework!)

% model coefficients
k = 3;
b = 1;
m = 2;

% state space model
A = [0 1; -k/m -b/m];
B = [0; 0];
C = eye(2);
D = 0;
sys = ss(A,B,C,D);

% time vector
t = (0:0.1:20)'; 

% initial condition
x0 = [1; 0];

% simulation (input u = 0*t)
[y,t] = lsim(sys,0*t,t,x0);
q = y(:,1); % position
v = y(:,2); % velocity
%% 
% Now we have two vectors q and v which we would like to plot as functions of 
% time. We need to use |subplot| to select which part of the figure to graph. 
% We first tell subplot that we want the figures arranged in a (2,1) column vector, 
% and then specify the index. If you wanted to plot 4 signals, then you would 
% have the command |subplot(4,1,1)| and then |subplot(4,1,2),| etc. Sometimes 
% you want to plot a row vector. That is not a problem either for the plot function.

% plotting
figure()
subplot(2,1,1); plot(t,q); grid on; ylabel('Position (m)');
title('Spring-Mass Simulation')
subplot(2,1,2); plot(t,v); grid on; ylabel('Velocity (m/s)');
xlabel('time (s)');
%% 
% *Loops*
% 
% Best seen with an example or two.

N = 10;
A = zeros(3,3,N);

for i=1:N
    A(:,:,i) = i * ones(3,3);
end
A

% compute row sums of A_i
A_first_row_sums = zeros(N,1);
for i=1:N
    Ai = A(:,:,i);  % get the ith matrix
    A_first_row_sums(i) = sum(Ai(1,:));
end
A_first_row_sums'
%% 
% *If ElseIf Else*

N = 10;
A = zeros(3,3,N);

for i=1:N
    if mod(i,3) == 0
        % i = 3,6,9,...
        A(:,:,i) = 3*ones(3,3);
    elseif mod(i,3) == 1
        % i = 1,4,7,...
        A(:,:,i) = ones(3,3);
    else
        A(:,:,i) = 2*ones(3,3);
    end
end
A
%% 
% *Inline Functions*
% 
% You can create your own one-line functions. The syntax is a little strange, 
% but not difficult with practice.

my_sum = @(x,y) x+y;
z = my_sum(3,4)

my_matrix = @(x) [0 x 0; 0 0 x; x 0 0];
A = my_matrix(7)
%% 
% *Functions*
% 
% For functions that take multiple lines, you can either put them into their 
% own .m file (with the same name as the function itself) or put them at the bottom 
% of your live script.

[s,d] = Add_Sub(5,7)
s1 = My_Square(12)
s2 = My_Square(-3) % ALWAYS test your functions!
%%
function [the_sum, the_diff] = Add_Sub(x,y)
    the_sum = x+y;
    the_diff = x-y;
end

function y = My_Square(n)
total = 0;
for i=1:n
    total = total + n;
end
y = total;
end
%% 
% 
% 
%