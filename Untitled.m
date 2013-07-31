function [x,fval,exitflag,output,lambda,grad,hessian] = Untitled(x0,lb,ub)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('fmincon');
%% Modify options setting
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'Algorithm', 'active-set');
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@(x)agent_fitness2('sarsa',2,2,trace,'policytype','softmax','alpha',x(1),'gamma',x(2),'temperature',x(3)),x0,[],[],[],[],lb,ub,[],options);
