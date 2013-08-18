function indices_estimate= get_indices_estimate(states,actions,env)
a=0;b=0;
for i=1:length(states)
    if states(i)==env.choice_state
        a=a+1;
        indices_estimate(a)=b;
    elseif states(i)==env.reward_state&&actions(i)==env.reward_action
        b=b+1;
    end
end
end