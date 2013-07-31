function [ analysis ] = inspect_transitions(varargin)
    data = load('../kesh/experiments/all.mat','xids');
    kwargs = utils.dict(varargin{:});
    games = kwargs.get('games',[1:4]);
    numgames = length(games);    
    subjects = kwargs.get('subjects',[1:9]);
    numsubjects = length(subjects);
    xids = kwargs.get('xids',[1:2]);
    numexps = length(xids);
    for x=xids
        for g=games
            for s=subjects
                try
                    gamedata = data.xids{x}.game{g}.subj{s};
                    states = gamedata.state;
                    actions = gamedata.action;
                    rewards = gamedata.reward;
                    s1 = (states(1:end-1) == 1);
                    s2 = (states(1:end-1) == 2);
                    s1a1 = (s1 & (actions == 1));
                    s1a2 = (s1 & (actions == 2));
                    s2a1 = (s2 & (actions == 1));
                    s2a2 = (s2 & (actions == 2));
                    s1a1s1 = (s1a1 & (states(2:end) == 1));
                    s1a1s2 = (s1a1 & (states(2:end) == 2));
                    s1a2s1 = (s1a2 & (states(2:end) == 1));
                    s1a2s2 = (s1a2 & (states(2:end) == 2));
                    s2a1s1 = (s2a1 & (states(2:end) == 1));
                    s2a2s1 = (s2a2 & (states(2:end) == 1));
                    when.s1 = find(s1);
                    when.s2 = find(s2);
                    when.s1a1 = find(s1a1);
                    when.s1a2 = find(s1a2);
                    when.s2a1 = find(s2a1);
                    when.s2a2 = find(s2a2);
                    when.s1a1s1 = find(s1a1s1);
                    when.s1a1s2 = find(s1a1s2);
                    when.s1a2s1 = find(s1a2s1);
                    when.s1a2s2 = find(s1a2s2);
                    when.s2a1s1 = find(s2a1s1);
                    when.s2a2s1 = find(s2a2s1);
                    meanrs.all = mean(rewards);
                    meanrs.s1 = mean(rewards(when.s1));
                    meanrs.s2 = mean(rewards(when.s2));
                    meanrs.s1a1 = mean(rewards(when.s1a1));
                    meanrs.s1a2 = mean(rewards(when.s1a2));
                    meanrs.s2a1 = mean(rewards(when.s2a1));
                    meanrs.s2a2 = mean(rewards(when.s2a2));
                    meanrs.s1a1s1 = mean(rewards(when.s1a1s1));
                    meanrs.s1a1s2 = mean(rewards(when.s1a1s2));
                    meanrs.s1a2s1 = mean(rewards(when.s1a2s1));
                    meanrs.s1a2s2 = mean(rewards(when.s1a2s2));
                    meanrs.s2a1s1 = mean(rewards(when.s2a1s1));
                    meanrs.s2a2s1 = mean(rewards(when.s2a2s1));
                    stdrs.all = std(rewards);
                    stdrs.s1 = std(rewards(when.s1));
                    stdrs.s2 = std(rewards(when.s2));
                    stdrs.s1a1 = std(rewards(when.s1a1));
                    stdrs.s1a2 = std(rewards(when.s1a2));
                    stdrs.s2a1 = std(rewards(when.s2a1));
                    stdrs.s2a2 = std(rewards(when.s2a2));
                    stdrs.s1a1s1 = std(rewards(when.s1a1s1));
                    stdrs.s1a1s2 = std(rewards(when.s1a1s2));
                    stdrs.s1a2s1 = std(rewards(when.s1a2s1));
                    stdrs.s1a2s2 = std(rewards(when.s1a2s2));
                    stdrs.s2a1s1 = std(rewards(when.s2a1s1));
                    stdrs.s2a2s1 = std(rewards(when.s2a2s1));

                    % games 3 and 4
                    if g == 3 | g == 4
                        s3 = (states(1:end-1) == 3);
                        s3a1 = (s3 & (actions == 1));
                        s3a2 = (s3 & (actions == 2));
                        s3a1s1 = (s3a1 & (states(2:end) == 1));
                        s3a2s1 = (s3a2 & (states(2:end) == 1));
                        s2a1s3 = (s2a1 & (states(2:end) == 3));
                        s2a2s3 = (s2a2 & (states(2:end) == 3));
                        when.s3 = find(s3);
                        when.s3a1 = find(s3a1);
                        when.s3a2 = find(s3a2);
                        when.s2a1s3 = find(s2a1s3);
                        when.s2a2s3 = find(s2a2s3);
                        when.s3a1s1 = find(s3a1s1);
                        when.s3a2s1 = find(s3a2s1);
                        meanrs.s3 = mean(rewards(when.s3));
                        meanrs.s3a1 = mean(rewards(when.s3a1));
                        meanrs.s3a2 = mean(rewards(when.s3a2));
                        meanrs.s2a1s3 = mean(rewards(when.s2a1s3));
                        meanrs.s2a2s3 = mean(rewards(when.s2a2s3));
                        meanrs.s3a1s1 = mean(rewards(when.s3a1s1));
                        meanrs.s3a2s1 = mean(rewards(when.s3a2s1));
                        stdrs.s3 = std(rewards(when.s3));
                        stdrs.s3a1 = std(rewards(when.s3a1));
                        stdrs.s3a2 = std(rewards(when.s3a2));
                        stdrs.s2a1s3 = std(rewards(when.s2a1s3));
                        stdrs.s2a2s3 = std(rewards(when.s2a2s3));
                        stdrs.s3a1s1 = std(rewards(when.s3a1s1));
                        stdrs.s3a2s1 = std(rewards(when.s3a2s1));
                    end
                    
                    analysis{x}.game{g}.subj{s}.when = when;
                    analysis{x}.game{g}.subj{s}.meanrs = meanrs;
                    analysis{x}.game{g}.subj{s}.stdrs = stdrs;
                    %analysis{x}.game{g}.subj{s}.lerrs = lerrs;
                    %analysis{x}.game{g}.subj{s}.uerrs = uerrs;
                end
            end
        end
    end
    %
    legloc = 'westoutside';
    for x=xids
        for g=games
            clear meanrss1a1 meanrss1a2 meanrss2a1 meanrss2a2
            clear stdrss1a1 stdrss1a2 stdrss2a1 stdrss2a2
            clear lerrss1a1 lerrss1a2 lerrss2a1 lerrss2a2
            clear uerrss1a1 uerrss1a2 uerrss2a1 uerrss2a2
            for s=subjects
                try
                    when = analysis{x}.game{g}.subj{s}.when;
                    meanrs = analysis{x}.game{g}.subj{s}.meanrs;
                    stdrs = analysis{x}.game{g}.subj{s}.stdrs;
                    %lerrs = analysis{x}.game{g}.subj{s}.lerrs;
                    %uerrs = analysis{x}.game{g}.subj{s}.uerrs;

                    meanrss1a1(s) = meanrs.s1a1;
                    meanrss1a2(s) = meanrs.s1a2;
                    meanrss2a1(s) = meanrs.s2a1;
                    meanrss2a2(s) = meanrs.s2a2;

                    meanrss1a1s1(s) = meanrs.s1a1s1;
                    meanrss1a1s2(s) = meanrs.s1a1s2;
                    meanrss1a2s1(s) = meanrs.s1a2s1;
                    meanrss1a2s2(s) = meanrs.s1a2s2;
                    meanrss2a1s1(s) = meanrs.s2a1s1;
                    meanrss2a2s1(s) = meanrs.s2a2s1;

                    stdrss1a1(s) = stdrs.s1a1;
                    stdrss1a2(s) = stdrs.s1a2;
                    stdrss2a1(s) = stdrs.s2a1;
                    stdrss2a2(s) = stdrs.s2a2;

                    stdrss1a1s1(s) = stdrs.s1a1s1;
                    stdrss1a1s2(s) = stdrs.s1a1s2;
                    stdrss1a2s1(s) = stdrs.s1a2s1;
                    stdrss1a2s2(s) = stdrs.s1a2s2;
                    stdrss2a1s1(s) = stdrs.s2a1s1;
                    stdrss2a2s1(s) = stdrs.s2a2s1;


                    % games 3 and 4
                    if g == 3 | g == 4
                        meanrss3a1(s) = meanrs.s3a1;
                        meanrss3a2(s) = meanrs.s3a2;

                        meanrss2a1s3(s) = meanrs.s2a1s3;
                        meanrss2a2s3(s) = meanrs.s2a2s3;
                        meanrss3a1s1(s) = meanrs.s3a1s1;
                        meanrss3a2s1(s) = meanrs.s3a2s1;

                        stdrss3a1(s) = stdrs.s3a1;
                        stdrss3a2(s) = stdrs.s3a2;

                        stdrss2a1s3(s) = stdrs.s2a1s3;
                        stdrss2a2s3(s) = stdrs.s2a2s3;
                        stdrss3a1s1(s) = stdrs.s3a1s1;
                        stdrss3a2s1(s) = stdrs.s3a2s1;

                    end

                    %% can be nan if there are no rewards above or below the mean
                    %if isfinite(lerrs.s1a1)
                    %    lerrss1a1(s) = lerrs.s1a1;
                    %    uerrss1a1(s) = uerrs.s1a1;
                    %else
                    %    lerrss1a1(s) = 0;
                    %    uerrss1a1(s) = 0;
                    %end
                    %if isfinite(lerrs.s1a2)
                    %    lerrss1a2(s) = lerrs.s1a2;
                    %    uerrss1a2(s) = uerrs.s1a2;
                    %else
                    %    lerrss1a2(s) = 0;
                    %    uerrss1a2(s) = 0;
                    %end
                    %if isfinite(lerrs.s2a1)
                    %    lerrss2a1(s) = lerrs.s2a1;
                    %    uerrss2a1(s) = uerrs.s2a1;
                    %else
                    %    lerrss2a1(s) = 0;
                    %    uerrss2a1(s) = 0;
                    %end
                    %if isfinite(lerrs.s2a2)
                    %    lerrss2a2(s) = lerrs.s2a2;
                    %    uerrss2a2(s) = uerrs.s2a2;
                    %else
                    %    lerrss2a2(s) = 0;
                    %    uerrss2a2(s) = 0;
                    %end



                catch
                    fprintf('Failed for xid %d, game %d, subject %d\n',x,g,s)
                    meanrss1a1(s) = nan;
                    meanrss1a2(s) = nan;
                    meanrss2a1(s) = nan;
                    meanrss2a2(s) = nan;

                    meanrss1a1s1(s) = nan;
                    meanrss1a1s2(s) = nan;
                    meanrss1a2s1(s) = nan;
                    meanrss1a2s2(s) = nan;
                    meanrss2a1s1(s) = nan;
                    meanrss2a2s1(s) = nan;

                    stdrss1a1(s) = nan;
                    stdrss1a2(s) = nan;
                    stdrss2a1(s) = nan;
                    stdrss2a2(s) = nan;

                    stdrss1a1s1(s) = nan;
                    stdrss1a1s2(s) = nan;
                    stdrss1a2s1(s) = nan;
                    stdrss1a2s2(s) = nan;
                    stdrss2a1s1(s) = nan;
                    stdrss2a2s1(s) = nan;

                    % games 3 and 4
                    if g == 3 | g == 4
                        meanrss3a1(s) = nan;
                        meanrss3a2(s) = nan;

                        meanrss2a1s3(s) = nan;
                        meanrss2a2s3(s) = nan;
                        meanrss3a1s1(s) = nan;
                        meanrss3a2s1(s) = nan;

                        stdrss3a1(s) = nan;
                        stdrss3a2(s) = nan;
                    end

                    %lerrss1a1(s) = nan;
                    %lerrss1a2(s) = nan;
                    %lerrss2a1(s) = nan;
                    %lerrss2a2(s) = nan;

                    %uerrss1a1(s) = nan;
                    %uerrss1a2(s) = nan;
                    %uerrss2a1(s) = nan;
                    %uerrss2a2(s) = nan;

                end
            end
            partxs = [1:numsubjects] ./(numsubjects+1);
            xs = [partxs 1+partxs 2+partxs 3+partxs];
            for i=1:length(xs), xlabs{i} = sprintf('%d',mod(i-1,numsubjects)+1); end;
            %ys = [s1a1means s1a2means s2a1means s2a2means];

            % games 3 and 4
            if g == 1 | g == 2
                numgroups = 6;
                colours = lines(numgroups);
                legtext = {'s_1, a_1, s_1   ','s_1, a_1, s_2   ',...
                           's_1, a_2, s_1   ','s_1, a_2, s_2   ',...
                           's_2, a_1, s_1   ',...
                           's_2, a_2, s_1   '};
                %subplot(numgames,numexps,(g-1)*numexps+x);
                figure
                hold on;
                h(1) = bar(partxs,meanrss1a1s1,'facecolor',colours(1,:),'edgecolor','none');
                h(2) = bar(partxs+1,meanrss1a1s2,'facecolor',colours(2,:),'edgecolor','none');
                h(3) = bar(partxs+2,meanrss1a2s1,'facecolor',colours(3,:),'edgecolor','none');
                h(4) = bar(partxs+3,meanrss1a2s2,'facecolor',colours(4,:),'edgecolor','none');
                h(5) = bar(partxs+4,meanrss2a1s1,'facecolor',colours(5,:),'edgecolor','none');
                h(6) = bar(partxs+5,meanrss2a2s1,'facecolor',colours(6,:),'edgecolor','none');
                errorbar(partxs,meanrss1a1s1,stdrss1a1s1,'k.');
                errorbar(partxs+1,meanrss1a1s2,stdrss1a1s2,'k.');
                errorbar(partxs+2,meanrss1a2s1,stdrss1a2s1,'k.');
                errorbar(partxs+3,meanrss1a2s2,stdrss1a2s2,'k.');
                errorbar(partxs+4,meanrss2a1s1,stdrss2a1s1,'k.');
                errorbar(partxs+5,meanrss2a2s1,stdrss2a2s1,'k.');
            elseif g == 3 | g == 4
                colours = lines(10);
                h(1) = bar(partxs,meanrss1a1s1,'facecolor',colours(1,:),'edgecolor','none');
                h(2) = bar(partxs+1,meanrss1a1s2,'facecolor',colours(2,:),'edgecolor','none');
                h(3) = bar(partxs+2,meanrss1a2s1,'facecolor',colours(3,:),'edgecolor','none');
                h(4) = bar(partxs+3,meanrss1a2s2,'facecolor',colours(4,:),'edgecolor','none');
                h(5) = bar(partxs+4,meanrss2a1s1,'facecolor',colours(5,:),'edgecolor','none');
                h(6) = bar(partxs+5,meanrss2a2s1,'facecolor',colours(6,:),'edgecolor','none');
                h(7) = bar(partxs+6,meanrss2a1s3,'facecolor',colours(7,:),'edgecolor','none');
                h(8) = bar(partxs+7,meanrss2a2s3,'facecolor',colours(8,:),'edgecolor','none');
                h(9) = bar(partxs+8,meanrss3a1s1,'facecolor',colours(9,:),'edgecolor','none');
                h(10) = bar(partxs+9,meanrss3a2s1,'facecolor',colours(10,:),'edgecolor','none');
                errorbar(partxs,meanrss1a1s1,stdrss1a1s1,'k.');
                errorbar(partxs+1,meanrss1a1s2,stdrss1a1s2,'k.');
                errorbar(partxs+2,meanrss1a2s1,stdrss1a2s1,'k.');
                errorbar(partxs+3,meanrss1a2s2,stdrss1a2s2,'k.');
                errorbar(partxs+4,meanrss2a1s1,stdrss2a1s1,'k.');
                errorbar(partxs+5,meanrss2a2s1,stdrss2a2s1,'k.');
                errorbar(partxs+6,meanrss2a1s3,stdrss2a1s3,'k.');
                errorbar(partxs+7,meanrss2a2s3,stdrss2a2s3,'k.');
                errorbar(partxs+8,meanrss3a1s1,stdrss3a1s1,'k.');
                errorbar(partxs+9,meanrss3a2s1,stdrss3a2s1,'k.');
                legtext = {'s_1, a_1, s_1   ','s_1, a_1, s_2   ',...
                           's_1, a_2, s_1   ','s_1, a_2, s_2   ',...
                           's_2, a_1, s_1   ','s_2, a_2, s_1   ',...
                           's_2, a_1, s_3   ','s_2, a_2, s_3   ',...
                           's_3, a_1, s_1   ','s_3, a_2, s_1   '};
            end

            hold off;
            legend(h,legtext,'location',legloc);
            set(gca,'xtick',xs);
            set(gca,'xticklabel',xlabs);
            xlabel('Subject');
            ylabel('Avg. Reward');
            title(['Game ' num2str(g)]);
        end
    end
end


