function [ model ] = Game4MDP(varrewards)
%%GAME4MDP Creates a model of the Game 4 from Kesh's second experiments
% if g is the gamma value and r is the variable reward (varrewards( then we ask matlab to solve:
% solve('v=g*(p2*(1+g*v)+(1-p2)*g*(p3*(1+g*v)+(1-p3)*(8*x+g*v)))','v')
% solve('v=0.8*(1+g*v)+0.2*g*(p2*(1+g*v)+(1-p2)*g*(p3*(1+g*v)+(1-p3)*(8*x+g*v)))','v')
% solve('((g^2*(p3 - 8*x*(p3 - 1))*(p2 - 1))/(g*(g*p2 - g*(g*p3 - g*(p3 - 1))*(p2 - 1)) - 1))=((0.2*(p3 - 8*x*(p3 - 1))*(p2 - 1)*g^2 - 0.8)/(0.8*g + 0.2*g*(g*p2 - g*(g*p3 - g*(p3 - 1))*(p2 - 1)) - 1))','x')
% g= (0.5*(((p2 - 1.0)*(p2 - 4.0*p3 - 32.0*x + 32.0*p3*x + 3.0))^(1/2) - 1.0*p2 + 1.0))/(p2 + p3 + 8.0*x - 1.0*p2*p3 - 8.0*p2*x - 8.0*p3*x + 8.0*p2*p3*x - 1.0)
% x=-(1.0*(g - 1.0*g*p2 - 1.0*g^2*p2 - 1.0*g^2*p3 + g^2 + g^2*p2*p3 + 1.0))/(8.0*g^2*p2 + 8.0*g^2*p3 - 8.0*g^2 - 8.0*g^2*p2*p3)
% 

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
model.varrewards = varrewards;
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
 1   0  0 ; % 2    
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
        q = 0;r=1;
    elseif ((prior_s == 1) && (action == 2) && (post_s == 1))
        q = 1;r=1;
    elseif ((prior_s == 1) && (action == 2) && (post_s == 2))
        q = 0;r=1;
    elseif ((prior_s == 2) && (action == 1) && (post_s == 1))
        q = 1;r=1;
    elseif ((prior_s == 2) && (action == 2) && (post_s == 3))
        q = 0;r=1;
    elseif ((prior_s == 3) && (action == 1) && (post_s == 1))
        q = 1;r=1;
    elseif ((prior_s == 3) && (action == 2) && (post_s == 1))
        q = varrewards(epstep);r=8;
    else
        q = 0;
    end
    if rand(1) <= q
        rew = r;
    else
        rew = 0;
    end
end


