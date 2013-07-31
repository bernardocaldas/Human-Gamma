function [ analysis ] = subject_dominant_in_window(xid,subject,game,width,varargin)
% predicts the gamma of the subject from the choice of action 
% looks at visits to state 1 at times t(1),t(2),...,t(k)
% uses the dominant action on visits i to (i+w-1) for window w.

%%kwargs = utils.dict('indir','../kesh/experiments');
%%xid=2
%%for subject=[1:9]
%%for game=3
%%for width=3:2:11
%%try
%%[ analysis ] = analyse.gammalysis.dominant_in_window(xid,subject,game,width,kwargs)
%%catch thrown
%%fprintf('Failed to run gammalysis with message: %s', thrown.message() );
%%end % catch
%%end
%%end
%%end
	addpath('../bernado_rl');
    kwargs = utils.dict(varargin{:});
    if xid ~= 2
        error('This does not currently support xid~=2');
    end
    [ trace, env, stem, indir, summary ] = analyse.load_xdata(xid,subject,game,kwargs);

    states = trace.states;
    actions = trace.actions;
    rewards = trace.rewards;
    varrewards = env.varrewards;
    numchoices = length(actions);

    analysis = analyse.gammalysis.dominant_in_window(xid,game,width,trace,env,summary)

    % save results
    outdir = kwargs.get('outdir','../kesh/analysis/gammalysis');
    ofstem = sprintf('%s_w%d',stem,width);
    ofpath = sprintf('%s/%s', outdir, ofstem);
    fprintf('Saving analysis to %s...\n',ofpath);
    save(ofpath,'analysis');

end
