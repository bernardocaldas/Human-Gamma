function [ trace, env, stem, indir, summary ] = load_xdata(xid,subject,game,varargin)
    addpath('../bernado_rl');
    kwargs = utils.dict(varargin{:});
    indir = kwargs.get('indir','../kesh/experiments');
    stem = analyse.resolve_stem(xid,subject,game);
    ifpath = sprintf('%s/%s',indir,stem);
    fprintf('loading file %s...\n',ifpath);
    load(ifpath);
    trace.states = state';
    trace.actions = action';
    trace.rewards = reward';

    env = games.get_env(xid,game);
%%%    switch game
%%%    case {1,2}
%%%        env.numstates = 2;
%%%        env.numactions = 2;
%%%    case {3,4}
%%%        env.numstates = 3;
%%%        env.numactions = 2;
%%%    otherwise
%%%        error('Unrecognised game type');
%%%    end
%%    env.numstates = max(trace.states);
%%    env.numactions = max(trace.actions);
%%
%%    switch xid
%%    case 1
%%        env.varrewards = r3;
%%        warning('It is unclear what variable should be considered the variable rewards');
%%    case 2
%%        env.varrewards = eval(['r3_game' num2str(game)]);
%%        switch game
%%        case 1
%%            % get gamma from immediate reward (reward indicates what gamma for policy switch)
%%            env.get_gamma = @(r) min(25/(r-25),1);
%%        case 2
%%            % get gamma from immediate reward (reward indicates what gamma for policy switch)
%%            %env.get_gamma = @(r) min(0.25/(r-0.25),1);
%%            %XXX new analysis gives
%%            env.get_gamma = @(r) min(25/(100*r - 21),1);
%%        case 3
%%            %XXX should be this but mistake in experiments means it is not
%%            % get gamma from immediate reward (reward indicates what gamma for policy switch)
%%            %XXX new analysis gives
%%            env.get_gamma = @(r) min(2*(sqrt(5*(r - 15)) + 5)/(r - 20),1);
%%            %XXX it is in fact this@
%%            env.get_gamma = @(r1,r2)  min(   -(1.0*(r1 + (4.0*r1*r2 - 3.0*r1^2)^(1/2)))/(2.0*r1 - 2.0*r2),1);
%%        case 4
%%            % get gamma from immediate reward (reward indicates what gamma for policy switch)
%%            %XXX old analysis based on incorrect data
%%            %env.get_gamma = @(r) min(((20.0*r - 3.0)^(1/2) + 1.0)/(10.0*r - 2.0),1);
%%            %XXX new analysis gives
%%            env.get_gamma = @(r) min((sqrt(17*(400*r - 51)) + 17)/(2*(100*r - 17)),1);
%%        otherwise
%%            error('Unrecognised game type');
%%        end
%%    otherwise
%%        error('Unrecognised experiment id (xid)');
%%    end

    if nargout > 4
        [ summary ] = analyse.get_summary(game,trace);
    end
end
