function [ trace policytrace ] = synthetic_traces( agent, sim, maxsteps )
    % Runs a single episode of the passed in simulation.
    s = sim.init(); % get initial state
    trace.states(1) = s;
    a = agent.first(s);
    for j=1:maxsteps
        % get next state and reward from sim
        [ r, s ] = sim.next(a);
        trace.actions(j) = a;
        trace.rewards(j) = r;
        trace.states(j+1) = s;
        policytrace(:,:,j) = agent.policy.weights;
        if ~sim.terminal();
            a = agent.next(r,s);
        else
            agent.last(r,s);
            break
        end % if
    end % for each step
end % function - run

