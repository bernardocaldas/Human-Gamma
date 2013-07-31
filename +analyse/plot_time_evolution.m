function [ analysis ] = plot_time_evolution(xid,game,subject,varargin)

    orangergb = [254 153 20]/255;
    darkbluergb = [14 32 127]/255;
    lightbluergb = [105 144 163]/255;

    kwargs = utils.dict(varargin{:});
%%    indir = kwargs.get('indir','../kesh/experiments')
%%    inpath = sprintf('%s/all.mat',indir);
%%    data = load(inpath,'xids');

    [ trace, env, stem, indir, summary ] = analyse.load_xdata(xid,subject,game,kwargs)

    outdir = kwargs.get('outdir','../kesh/analysis/timeseries')
%    ofname = sprintf('s%d0%dg%d_timeseries.eps',xid,subject,game);
    ofpath = sprintf('%s/%s_timeseries.eps',outdir,stem);
    ofpath2 = sprintf('%s/%s_inferredpol.eps',outdir,stem);

%    gamedata = data.xids{xid}.game{game}.subj{subject};
    states = trace.states;
    actions = trace.actions;
    rewards = trace.rewards;
    when = summary.when;
%%    s1 = (states(1:end-1) == 1);
%%    s2 = (states(1:end-1) == 2);
%%    s1a1 = (s1 & (actions == 1));
%%    s1a2 = (s1 & (actions == 2));
%%    s2a1 = (s2 & (actions == 1));
%%    s2a2 = (s2 & (actions == 2));
%%    s1a1s1 = (s1a1 & (states(2:end) == 1));
%%    s1a1s2 = (s1a1 & (states(2:end) == 2));
%%    s1a2s1 = (s1a2 & (states(2:end) == 1));
%%    s1a2s2 = (s1a2 & (states(2:end) == 2));
%%    s2a1s1 = (s2a1 & (states(2:end) == 1));


%    when.s1 = find(s1);
%    when.s2 = find(s2);
%    when.s1a1 = find(s1a1);
%    when.s1a2 = find(s1a2);
%    when.s2a1 = find(s2a1);
%    when.s2a2 = find(s2a2);
    textsize = kwargs.get('textsize',12);
    h{1} = text(when.s1a1,rewards(when.s1a1),'1','fontsize',textsize);
    hold on;
    h{2} = text(when.s1a2,rewards(when.s1a2),'1','fontsize',textsize);
    h{3} = text(when.s2a1,rewards(when.s2a1),'2','fontsize',textsize);
    h{4} = text(when.s2a2,rewards(when.s2a2),'2','fontsize',textsize);


    % plot averages
    if game < 3
        set(h{1},'color',orangergb);
        set(h{2},'color',lightbluergb);
        set(h{3},'color',orangergb);
        set(h{4},'color','k');
    else
        set(h{1},'color',orangergb);
        set(h{2},'color',lightbluergb);
        set(h{3},'color','k');
        set(h{4},'color',orangergb);
%%        s3 = (states(1:end-1) == 3);
%%        s3a1 = (s3 & (actions == 1));
%%        s3a2 = (s3 & (actions == 2));
%%        when.s3 = find(s3);
%%        when.s3a1 = find(s3a1);
%%        when.s3a2 = find(s3a2);
        h{5} = text(when.s3a1,rewards(when.s3a1),'3','fontsize',textsize);
        set(h{5},'color',orangergb);
        h{6} = text(when.s3a2,rewards(when.s3a2),'3','fontsize',textsize);
        set(h{6},'color',orangergb);
    end

    xlim([0,length(states)]);
    ylim([-10,max(rewards)+5]);

    fontsize = kwargs.get('fontsize',14);
    xlabel('time-step','fontsize',fontsize);
    ylabel('reward','fontsize',fontsize);
    hold off;
    %title('Gamma predictions for policy switches');
    fprintf('saving to %s...\n',ofpath);
    saveas(gcf,ofpath,'epsc');
    %close gcf;

    if kwargs.get('infer_policy',true)
        widths = kwargs.get('widths',[3,5,7,9,11]);

        figure;
        hold on;
        for w = widths
            [ analysis, stem, gammalysisdir ] = analyse.load_gammalysis(xid,subject,game,w);
            detectup = analysis.detectedup;
            detectdown = analysis.detecteddown;
            % policy must be defined from first step 
            % firstpol is the indices of all the times that the first policy is switched to
            % secondpol is similalry defined for second policy
            if detectup(1) < detectdown(1)
                firstpol = [1 detectdown];
                secondpol = detectup;
                firstcolor = lightbluergb;
                secondcolor = orangergb;
            else
                firstpol = [1 detectup];
                secondpol = detectdown;
                firstcolor = orangergb;
                secondcolor = lightbluergb;
            end
            for i=1:length(firstpol)-1
                fprintf('Plotting policy in regions %d to %d via %d\n',firstpol(i),firstpol(i+1),secondpol(i));
                plot([firstpol(i) secondpol(i)],[w w],'-','color',firstcolor,'linewidth',5);
                plot([secondpol(i) firstpol(i+1)],[w w],'-','color',secondcolor,'linewidth',5);
            end
            if length(firstpol) == length(secondpol)
                plot([firstpol(end) secondpol(end)],[w w],'-','color',firstcolor,'linewidth',5);
                plot([secondpol(end) length(states)],[w w],'-','color',secondcolor,'linewidth',5);
            else
                plot([firstpol(end) length(states)],[w w],'-','color',firstcolor,'linewidth',5);
            end
        end
        xlim([0,length(states)]);
        ylim([widths(1)-1,widths(end)+1]);
        set(gca,'ytick',widths);
        for i=1:length(widths), yticklabs{i} = num2str(widths(i)); end;
        set(gca,'yticklabel',yticklabs);

        xlabel('time-step','fontsize',fontsize);
        ylabel('window','fontsize',fontsize);
        ar = daspect();
        daspect(ar.*[0.04*length(widths) 1 1]);
        hold off;
        %title('Gamma predictions for policy switches');
        fprintf('saving to %s...\n',ofpath2);
        saveas(gcf,ofpath2,'epsc');
        close gcf;

    end

end
