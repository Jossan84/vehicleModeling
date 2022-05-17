% getSingleTrackModelParameters
% 29/03/2019

% Solve parameters
%theta_reg = [zeros(2, 1), A, B];    % Force to setted parameters

%% Objective function
f = @(x)(objectiveFcn(x, theta_reg, m));

%% Objective function with normalization
% Solve more fast?
x_max = [1e6, 1e6, 5, 5, 40, 1e6];

%% Init point for Minimization
%xInit = zeros(1, 6);
%xInit = ones(1, 6);
%xInit = rand(1, 6);
%xInit = [20000, 30000, 2, 3, 16, 1000];
%xInit = [20000, 10000, 2.5, 2.5, 16, 1000];
%xInit = [1, 10000, 2, 3, 16, 1000];
xInit = randi(1e2, 1, 6);

%% Compute minimizations
% 1st Method
disp('1st Method : [fminsearch]:');
options = optimset('Display','notify-detailed','GradObj', 'on', 'MaxFunEvals', 1e5 * 6, 'MaxIter', 1e5);
xSol = fminsearch(f, xInit, options);
disp('--------------');

% 2nd Method
disp('2nd Method : [fminunc]:');
xSol2 =fminunc(f, xInit, options);
disp('--------------');

% 3th Method
disp('3th Method [fmincon] "Whith constraints":');
LB = [100, 100, 0, 0, 10, 500]; % Low constraints
UB = [1e6, 1e6, 5, 5, 30, 1e6]; % Upper constraints
options = optimoptions(@fmincon,'Algorithm','interior-point',...
 'SpecifyObjectiveGradient',true,'SpecifyConstraintGradient',true,'PlotFcn',{@optimplotx,...
    @optimplotfval,@optimplotfirstorderopt},'MaxFunctionEvaluations',1e5 * 6,...
    'MaxIterations',1e5,'StepTolerance',1.0e-20,'ConstraintTolerance',1.0e-20,...
    'OptimalityTolerance',1.0e-10,'Display','iter');
xSol3 = fmincon(f, xInit, [], [], [], [], LB, UB, [], options);
disp('--------------');

