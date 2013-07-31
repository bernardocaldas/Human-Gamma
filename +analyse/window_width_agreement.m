function [ analysis, summary ] = window_width_agreement(xid,game,subject,varargin)
% compares the inferred policy between different window widths
    addpath('../bernado_rl');
    orangergb = [254 153 20]/255;
    darkbluergb = [14 32 127]/255;
    lightbluergb = [105 144 163]/255;

    kwargs = utils.dict(varargin{:});
    [ trace, env, stem, indir, summary ] = analyse.load_xdata(xid,subject,game,kwargs);

    %outdir = kwargs.get('outdir','../kesh/analysis/timeseries')
    %ofpath = sprintf('%s/x%dg%d_window_width_agreement.eps',outdir,stem);

    states = trace.states;
    actions = trace.actions;
    rewards = trace.rewards;
    when = summary.when;
    tracelen = length(actions);

    textsize = kwargs.get('textsize',12);
    widths = kwargs.get('widths',[3,5,7,9,11]);

    for i = 1:length(widths)
        w = widths(i);
        [ analysis, stem, gammalysisdir ] = analyse.load_gammalysis(xid,subject,game,w);
        detectup = analysis.detectedup;
        detectdown = analysis.detecteddown;
        % policy must be defined from first step 
        % firstpol is the indices of all the times that the first policy is switched to
        % secondpol is similalry defined for second policy
        if detectup(1) < detectdown(1)
            firstpol = [1 detectdown];
            secondpol = detectup;
            firstislong = 0;
        else
            firstpol = [1 detectup];
            secondpol = detectdown;
            firstislong = 1;
        end
        polprofile = [];
        for i=1:length(firstpol)-1
            %fprintf('Plotting policy in regions %d to %d via %d\n',firstpol(i),firstpol(i+1),secondpol(i));
            polprofile = [polprofile firstislong*ones(1,(secondpol(i)-firstpol(i)))  ~firstislong*ones(1,(firstpol(i+1)-secondpol(i)))];
        end
        if length(firstpol) == length(secondpol)
            polprofile = [polprofile firstislong*ones(1,(secondpol(end)-firstpol(end))) ~firstislong*ones(1,(length(states)-secondpol(end)))];
        else
            polprofile = [polprofile firstislong*ones(1,(length(states)-firstpol(end)))];
        end
        polprofiles{w} = polprofile;
    end
    analysis.polprofiles = polprofiles;
    for i = 1:length(widths)
        w = widths(i);
        for j = 1:length(widths)
            ww = widths(j);
            agreement(i,j) = sum(polprofiles{w} == polprofiles{ww})/tracelen;
        end
    end
    analysis.agreement = agreement;
    analysis.widths = widths;
end

