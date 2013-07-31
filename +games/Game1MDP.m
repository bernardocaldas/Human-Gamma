function [ model ] = Game1MDP(varrewards)
%%GAME1MDP  Creates a model of the Game 3 from Kesh's second experiments
% if g is the gamma value and r is the variable reward (varrewards( then we ask matlab to solve:
% solve('(20 + 0.2*g*p)/(1-0.8*g-0.2*g^2) = g*p/(1-g^2)')
% to give g in terms of r as:
% g = 25/(r-25)
% or alternatively r in terms of g as:
% r = (25*g+25)/g


% solve('(g *x)/(1-g^2) = (20 + 0.2*g *x)/(1-0.8*g - 0.2*g^2)')

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
%1   2   <-- FROM STATE
0   1 ; % 1 TO STATE
1   0 ; % 2    
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
    if ((prior_s == 1) && (action == 1) && (post_s == 2))
        rew = 0;
    elseif ((prior_s == 1) && (action == 2) && (post_s == 1))
        rew = 25;
    elseif ((prior_s == 1) && (action == 2) && (post_s == 2))
        rew = 0;
    elseif ((prior_s == 2) && (action == 1) && (post_s == 1))
        rew = varrewards(epstep);
    elseif ((prior_s == 2) && (action == 2) && (post_s == 1))
        rew = 25;
    else
        rew = 0;
    end
end


