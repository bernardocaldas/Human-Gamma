function [ model ] = Game2MDP(varrewards)
%%GAME1MDP Creates a model of the simple stair climbing MDP from the lectures
% if g is the gamma value and r is the variable reward (varreward( then we ask matlab to solve:
% solve('v=0.2*(0.05+g*v)+0.8*g*(p*(5*x+g*v)+(1-p)*(5*0.1+g*v))','v')
% solve('v=0.8*(1+g*v)+0.2*g*(p*(5*x+g*v)+(1-p)*(5*0.1+g*v))','v')
% solve('(-(1.0*(40.0*g - 40.0*g*p + 400.0*g*p*x + 1.0))/(80.0*g^2 + 20.0*g - 100.0))=(-(1.0*(g - 1.0*g*p + 10.0*g*p*x + 8.0))/(2.0*g^2 + 8.0*g - 10.0))','g')
% g=-395.0/(150.0*p - 1500.0*p*x + 169.0);
% x=(0.00066666666666666666666666666666667*(169.0*g + 150.0*g*p + 395.0))/(g*p)

% solve('v=g*(p*(5*x+g*v)+(1-p)*(1+g*v))','v')
% solve('v=0.8*(1+g*v)+0.2*g*(p*(5*x+g*v)+(1-p)*(1+g*v))','v')
% solve('(-(g - g*p + 5*g*p*x)/(g^2 - 1))=(-(1.0*(g - 1.0*g*p + 5.0*g*p*x + 9.0))/(g^2 + 9.0*g - 10.0))','g')
% -1.0/(p - 5.0*p*x)
% x=(0.2*(g*p + 1.0))/(g*p)

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
0  1 ; % 1 TO STATE
1  0 ; % 2    
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
        q = 0;r=1;
    elseif ((prior_s == 1) && (action == 1) && (post_s == 2))
        q = 0;r=1;
    elseif ((prior_s == 1) && (action == 2) && (post_s == 1))
        q = 1; r=1;
    elseif ((prior_s == 1) && (action == 2) && (post_s == 2))
        q = 0;r=1;
    elseif ((prior_s == 2) && (action == 1) && (post_s == 1))
        q = varrewards(epstep);r=5;
    elseif ((prior_s == 2) && (action == 2) && (post_s == 1))
        q = 1;r=1;
    else
        q = 0;
    end
    if rand(1) <= q
        rew = r;
    else
        rew = 0;
    end
end

