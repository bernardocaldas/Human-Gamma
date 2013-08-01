function env = get_env(xid,game,varargin)

    kwargs = utils.dict(varargin{:});
    indir = kwargs.get('indir','../kesh/experiments')
    
    % this is the general varrewards, and subject varrewards should still be got independently
    if kwargs.iskey('varrewards')
        env.varrewards = kwargs('varrewards');
    else
        env.varrewards = source_varrewards(xid,game,indir);
    end

    switch game
    case {1,2}
        env.numstates = 2;
        env.numactions = 2;
    case {3,4}
        env.numstates = 3;
        env.numactions = 2;
    otherwise
        error('Unrecognised game type');
    end


    switch xid
    case 1
        warning('It is unclear what variable should be considered the variable rewards');
        warning('get_gamma not evaluated for this game');
    case 2
        %XXX has been verified on data
        env.choice_state = 1;
        env.long_action = 1;
        env.short_action = 2;
        switch game
        case 1
            % get gamma from immediate reward (reward indicates what gamma for policy switch)
%             env.get_gamma = @(r) min(25/(r-25),1);
            env.get_gamma = @(r,p) max(0,min(25/(r*p-25*p),1));
            %XXX has been verified on data
            env.reward_state = 2;
            env.reward_action = 1;
        case 2
            % get gamma from immediate reward (reward indicates what gamma for policy switch)
            %env.get_gamma = @(r) min(0.25/(r-0.25),1);
            %XXX new analysis gives
%             env.get_gamma = @(r) min(25/(100*r - 21),1);
            env.get_gamma = @(r,p) max(0,min(-25/(10*p-100*p*r+11),1));
            %XXX has been verified on data
            env.reward_state = 2;
            env.reward_action = 1;
        case 3
            %XXX should be this but mistake in experiments means it is not
            % get gamma from immediate reward (reward indicates what gamma for policy switch)
            %XXX new analysis gives
%             env.get_gamma = @(r) min(2*(sqrt(5*(r - 15)) + 5)/(r - 20),1);
            env.get_gamma =@(r,p2,p3)max(0,min(-(5^(1/2)*(400*p2*(1-p3)-400*(1-p3)-120*p2+16*(1-p3)*r+5*p2^2-16*p2*(1-p3)*r+160)^(1/2)-5*p2+20)/(2*(p2-1)*((1-p3)*r-25*(1-p3)+5)),1));
            %TODO Sort out which one of these are the best
            %%XXX it is in fact this@
            %env.get_gamma = @(r1,r2)  min(   -(1.0*(r1 + (4.0*r1*r2 - 3.0*r1^2)^(1/2)))/(2.0*r1 - 2.0*r2),1);
            %XXX has been verified on data
            env.reward_state = 3;
            env.reward_action = 2;
        case 4
            % get gamma from immediate reward (reward indicates what gamma for policy switch)
            %XXX old analysis based on incorrect data
            %env.get_gamma = @(r) min(((20.0*r - 3.0)^(1/2) + 1.0)/(10.0*r - 2.0),1);
            %XXX new analysis gives
%             env.get_gamma = @(r) min((sqrt(17*(400*r - 51)) + 17)/(2*(100*r - 17)),1);
            env.get_gamma =@(r,p2,p3)max(0,min(-((1700*p2*(1-p3)-1700*(1-p3)-714*p2+6800*(1-p3)*r+25*p2^2-6800*p2*(1-p3)*r+833)^(1/2)-5*p2+17)/(2*(p2-1)*(100*(1-p3)*r-25*(1-p3)+8)),1));
            env.reward_state = 3;
            env.reward_action = 2;
        otherwise
            error('Unrecognised game type');
        end
    otherwise
        error('Unrecognised experiment id (xid)');
    end
end

function [ varrewards ] = source_varrewards(xid,game,indir)
    for s=1:9
        try
            stem = analyse.resolve_stem(xid,s,game);
            ifpath = sprintf('%s/%s',indir,stem);
%             fprintf('loading file %s...\n',ifpath);
            load(ifpath);
            switch xid
            case 1
                varrewards = r3;
            case 2
                varrewards = eval(['r3_game' num2str(game)]);
            end
%            [ trace, env ] = analyse.load_xdata(xid,s,game,'indir',indir);
%            varrewards = env.varrewards;
            return;
        end
    end
    error('Cannot get varrewards');
end
