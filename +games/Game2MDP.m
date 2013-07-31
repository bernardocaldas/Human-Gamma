function [ model ] = Game2MDP(varrewards)
%%GAME1MDP Creates a model of the simple stair climbing MDP from the lectures
% if g is the gamma value and r is the variable reward (varreward( then we ask matlab to solve:
% solve('(20 + 0.2*g*p)/(1-0.8*g-0.2*g^2) = g*p/(1-g^2)')
% to give g in terms of r as:
% g = 25/(r-25)
% or alternatively r in terms of g as:
% r = (25*g+25)/g

numstates = 2; 
statenames =  ['s1'; 's2'];

% Actions are: {L,R} --> {1, 2 }
numactions = 2; 
actionnames =  ['1'; '2'];

% Matrix indicating absorbing states
absorbing = [
%1   2   <-- STATES 
 0   0
];

% Matrix indicating starting state distribution
initial = [
%1   2   <-- STATES 
 1   0
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
%1   2   <-- FROM STATE
0.2  1 ; % 1 TO STATE
0.8  0 ; % 2    
];
Ta2 = [
%1   2   <-- FROM STATE
0.8  1 ; % 1 TO STATE
0.2  0 ; % 2    
];
T = cat(3, Ta1, Ta2); %transition probabilities for each action 
end

%--------------------------------------------------------------------------

% the locally defined reward function
function rew = reward_function(prior_s, action, post_s, epstep, varrewards) % reward function (defined locally)
    if ((prior_s == 1) && (action == 1) && (post_s == 1))
        q = 0.05;
    elseif ((prior_s == 1) && (action == 1) && (post_s == 2))
        q = 0;
    elseif ((prior_s == 1) && (action == 2) && (post_s == 1))
        q = 0.2;
    elseif ((prior_s == 1) && (action == 2) && (post_s == 2))
        q = 0;
    elseif ((prior_s == 2) && (action == 1) && (post_s == 1))
        q = varrewards(epstep);
    elseif ((prior_s == 2) && (action == 2) && (post_s == 1))
        q = 0.1;
    else
        q = 0;
    end
    if rand(1) <= q
        rew = 1;
    else
        rew = 0;
    end
end

