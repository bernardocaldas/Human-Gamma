function [model, sim, env ] = get(xid,game,varargin)

    kwargs = utils.dict(varargin{:});
    if kwargs.iskey('varrewards')
        varrewards = kwargs('varrewards');
    else
        env = games.get_env(xid,game,kwargs);
        varrewards = env.varrewards;
        %varrewards = source_varrewards(xid,game);
    end
    switch xid
    case 2
        switch game
        case 1
            [ model ] = games.Game1MDP(varrewards);
        case 2
            [ model ] = games.Game2MDP(varrewards);
        case 3
            [ model ] = games.Game3MDP(varrewards);
        case 4
            [ model ] = games.Game4MDP(varrewards);
        otherwise
            fprintf('xid %d game %d not available',xid,game);
        end
    otherwise
        fprintf('Games for xid %d not available',xid);
    end

    if nargout > 1
        torecord = kwargs.get('torecord',[1 1 1]); % by default record states, actions and rewards
        sim = environment.discrete.simulation.NonStationarySim(model,'torecord',torecord);
    end

end


