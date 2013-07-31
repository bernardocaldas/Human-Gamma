function [ model ] = Game3MDP(varrewards)
%%GAME3MDP Creates a model of the Game 3 from Kesh's second experiments
% if g is the gamma value and r is the variable reward (varreward( then we ask matlab to solve:
% Long policy =>
% V(1) = 0 + g*V(2)   - best action : pol(1)=1
% V(2) = 0 + g*V(3)   - best action : pol(2)=2
% V(3) = r + g*V(1)   - best action : pol(3)=2
% =>
% V(3) = r + g*g*V(2)
% V(3) = r + g*g*g*V(3)
% =>
% V(3) = r/(1-g^3)
% V(2) = g*r/(1-g^3)
% V(1) = g^2*r/(1-g^3)
%
% Short policy =>
% V(1) = 0.8*(20 + g*V(1)) + 0.2*(0 + g*V(2))
%   - best action : pol(1)=2
% V(2) = 0 + g*V(3)   - best action : pol(2)=2
% V(3) = r + g*V(1)   - best action : pol(3)=2
% =>
% V(2) = g*r + g*g*V(1)
% V(1) = 16 + 0.8*g*V(1) + 0.2*g*g*r + 0.2*g*g*g*V(1)
% V(1) = 16 + 0.2*g^2*r  + (0.8*g + 0.2*g^3)*V(1)
% =>
% V(1) = (16 + 0.2*g^2*r)/(1 - 0.8*g - 0.2*g^3)


% solve('(16 + 0.2*x^2*r)/(1 - 0.8*x - 0.2*x^3) = x^2*r/(1-x^3)')
% to give g in terms of r as:
% g = (4.4721359549995793928183473374626*(r - 15.0)^(1/2) + 10.0)/(r - 20.0)
% or alternatively r in terms of g as:
% r = (20.0*g^2 + 20.0*g + 20.0)/g^2

% for game 4
% solve('(0.16 + 0.2*x^2*r)/(1 - 0.8*x - 0.2*x^3) = x^2*r/(1-x^3)')
% ((20.0*r - 3.0)^(1/2) + 1.0)/(10.0*r - 2.0)


%% actually game 3 is not as advertised for xid=2
% It is
% Long policy =>
% V(1) = 0 + g*V(2)
% V(2) = 0 + g*V(3)
% V(3) = r2 + g*V(1)
% =>
% V(3) = r/(1-g^3)
% V(2) = g*r/(1-g^3)
% V(1) = g^2*r2/(1-g^3)

% Short policy =>
% V(1) = 0.8*(r1 + g*V(1)) + 0.2*(0 + g*V(2))
% V(2) = 0 + g*V(3)
% V(3) = r2 + g*V(1)
% =>
% V(2) = g*r2 + g*g*V(1)
% V(1) = 0.8*r1 + 0.8*g*V(1) + 0.2*g*g*r2 + 0.2*g*g*g*V(1)
% V(1) = 0.8*r1 + 0.2*g^2*r2  + (0.8*g + 0.2*g^3)*V(1)
% =>
% V(1) = (0.8*r1 + 0.2*g^2*r2)/(1 - 0.8*g - 0.2*g^3)
%
% solve('(0.8*r1 + 0.2*x^2*r2)/(1 - 0.8*x - 0.2*x^3) = x^2*r2/(1-x^3)')
%
% get_gamma = @(r1,r2)     -(1.0*(r1 + (4.0*r1*r2 - 3.0*r1^2)^(1/2)))/(2.0*r1 - 2.0*r2)
%
%XXX
% New analysis for fixed rewards gives
% solve('(x^2*r)/(1 - x^3) = (16 + 0.2 * x^2 * r)/(1 - 0.8 * x - 0.2 * x^3)')
% get_gamma = @(r) 2*(sqrt(5*(r - 15)) + 5)/(r - 20)

numstates = 3; 
statenames =  ['s1'; 's2'; 's3'];

% Actions are: {L,R} --> {1, 2 }
numactions = 2; 
actionnames =  ['1'; '2'];

% Matrix indicating absorbing states
absorbing = [
%1   2   3  <-- STATES 
 0   0   0
];

% Matrix indicating starting state distribution
initial = [
%1   2   3  <-- STATES 
 1   0   0
];

% load transition
T = transition_matrix();

%% create the output struct
model.numstates = numstates; % number of states
model.statenames = statenames; % and their names
model.varreward = varrewards;
model.numactions = numactions; % number of actions
model.actionnames = actionnames; % and their names
model.initial = initial; % probability distribution over initial states
model.absorbing = absorbing; % which states terminate an episode
model.t = @(s,a,s_,epstep) T(s_,s,a); % the transition function - note the different order of the arguments.
model.r = @(s,a,s_,epstep) reward_function(s, a, s_, epstep, varrewards); % the reward function

end
%--------------------------------------------------------------------------

% get the transition matrix
function T = transition_matrix()
Ta1 = [
%1   2   3  <-- FROM STATE
 0   1   1 ; % 1 TO STATE
 1   0   0 ; % 2    
 0   0   0 ; % 2    
];
Ta2 = [
%1   2   <-- FROM STATE
 0.8 0   1 ; % 1 TO STATE
 0.2 0   0 ; % 2    
 0   1   0 ; % 2    
];
T = cat(3, Ta1, Ta2); %transition probabilities for each action 
end

%--------------------------------------------------------------------------

% the locally defined reward function
function rew = reward_function(prior_s, action, post_s, epstep, varrewards) % reward function (defined locally)
    if ((prior_s == 1) && (action == 1) && (post_s == 2))
        rew = 0;
    elseif ((prior_s == 1) && (action == 2) && (post_s == 1))
        rew = 20;
    elseif ((prior_s == 1) && (action == 2) && (post_s == 2))
        rew = 0;
    elseif ((prior_s == 2) && (action == 1) && (post_s == 1))
        rew = 5;
    elseif ((prior_s == 2) && (action == 2) && (post_s == 3))
        rew = 0;
    elseif ((prior_s == 3) && (action == 1) && (post_s == 1))
        rew = 25;
    elseif ((prior_s == 3) && (action == 2) && (post_s == 1))
        rew = varrewards(epstep);
    else
        rew = 0;
    end
end

% get the reward matrix
function R = reward_matrix(numstates, numactions, varreward)
% i.e. 11x11 matrix of rewards for being in state s, performing action a and ending in state s'
R = zeros(numstates, numstates, numactions); 
for i = 1:numstates
   for j = 1:numactions
      for k = 1:numstates
         R(k, i, j) = reward_function(i, j, k, varreward);
      end
   end    
end
end

