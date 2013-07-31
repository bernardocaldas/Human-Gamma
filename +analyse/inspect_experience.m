function [ analysis ] = inspect_experience()
    data = load('../kesh/experiments/all.mat','xids');
    xids = data.xids;
    clear data;
    for x=1:2
        for g=1:4
            for s=1:9
                try
                    gamedata = xids{x}.game{g}.subj{s};
                    states = gamedata.state;
                    actions = gamedata.action;
                    rewards = gamedata.reward;
                    s1 = (states(1:end-1) == 1);
                    s2 = (states(1:end-1) == 2);
                    %s3 = (states(1:end-1) == 3);
                    s1a1 = (s1 & (actions == 1));
                    s1a2 = (s1 & (actions == 2));
                    s2a1 = (s2 & (actions == 1));
                    s2a2 = (s2 & (actions == 2));
                    %s3a1 = (s3 & (actions == 1));
                    %s3a2 = (s3 & (actions == 2));
                    s1a1s1 = (s1a1 & (states(2:end) == 1));
                    s1a1s2 = (s1a1 & (states(2:end) == 2));
                    s1a2s1 = (s1a2 & (states(2:end) == 1));
                    s1a2s2 = (s1a2 & (states(2:end) == 2));
                    s2a1s1 = (s2a1 & (states(2:end) == 1));
                    %s3a1s1 = (s3a1 & (states(2:end) == 1));
                    when.s1 = find(s1);
                    when.s2 = find(s2);
                    when.s1a1 = find(s1a1);
                    when.s1a2 = find(s1a2);
                    when.s2a1 = find(s2a1);
                    when.s2a2 = find(s2a2);
                    meanrs.all = mean(rewards);
                    meanrs.s1 = mean(rewards(when.s1));
                    meanrs.s2 = mean(rewards(when.s2));
                    meanrs.s1a1 = mean(rewards(when.s1a1));
                    meanrs.s1a2 = mean(rewards(when.s1a2));
                    meanrs.s2a1 = mean(rewards(when.s2a1));
                    meanrs.s2a2 = mean(rewards(when.s2a2));
                    stdrs.all = std(rewards);
                    stdrs.s1 = std(rewards(when.s1));
                    stdrs.s2 = std(rewards(when.s2));
                    stdrs.s1a1 = std(rewards(when.s1a1));
                    stdrs.s1a2 = std(rewards(when.s1a2));
                    stdrs.s2a1 = std(rewards(when.s2a1));
                    stdrs.s2a2 = std(rewards(when.s2a2));

					% games 3 and 4
					if g == 3 | g == 4
		                s3 = (states(1:end-1) == 3);
		                s3a1 = (s3 & (actions == 1));
		                s3a2 = (s3 & (actions == 2));
		                when.s3 = find(s3);
		                when.s3a1 = find(s3a1);
		                when.s3a2 = find(s3a2);
		                meanrs.s3 = mean(rewards(when.s3));
		                meanrs.s3a1 = mean(rewards(when.s3a1));
		                meanrs.s3a2 = mean(rewards(when.s3a2));
		                meanrs.s3 = mean(rewards(when.s3));
		                meanrs.s3a1 = mean(rewards(when.s3a1));
		                meanrs.s3a2 = mean(rewards(when.s3a2));
		                stdrs.s3 = std(rewards(when.s3));
		                stdrs.s3a1 = std(rewards(when.s3a1));
		                stdrs.s3a2 = std(rewards(when.s3a2));
					end
                    % errors l (not a principled way to do it)
                    %allwhenl = find(rewards<meanrs.all);
                    %lerrs.all = sqrt(mean((rewards(allwhenl)-meanrs.all).^2))/sqrt(length(allwhenl));
                    %s1whenl = find(rewards(when.s1)<meanrs.s1);
                    %lerrs.s1 = sqrt(mean((rewards(when.s1(s1whenl))-meanrs.s1).^2))/sqrt(length(s1whenl));
                    %s2whenl = find(rewards(when.s2)<meanrs.s2);
                    %lerrs.s2 = sqrt(mean((rewards(when.s2(s2whenl))-meanrs.s2).^2))/sqrt(length(s2whenl));
                    %s1a1whenl = find(rewards(when.s1a1)<meanrs.s1a1);
                    %lerrs.s1a1 = sqrt(mean((rewards(when.s1a1(s1a1whenl))-meanrs.s1a1).^2))/sqrt(length(s1a1whenl));
                    %s1a2whenl = find(rewards(when.s1a2)<meanrs.s1a2);
                    %lerrs.s1a2 = sqrt(mean((rewards(when.s1a2(s1a2whenl))-meanrs.s1a2).^2))/sqrt(length(s1a2whenl));
                    %s2a1whenl = find(rewards(when.s2a1)<meanrs.s2a1);
                    %lerrs.s2a1 = sqrt(mean((rewards(when.s2a1(s2a1whenl))-meanrs.s2a1).^2))/sqrt(length(s2a1whenl));
                    %s2a2whenl = find(rewards(when.s2a2)<meanrs.s2a2);
                    %lerrs.s2a2 = sqrt(mean((rewards(when.s2a2(s2a2whenl))-meanrs.s2a2).^2))/sqrt(length(s2a2whenl));
                    %% errors u
                    %allwhenu = find(rewards>meanrs.all);
                    %uerrs.all = sqrt(mean((rewards(allwhenu)-meanrs.all).^2))/sqrt(length(allwhenu));
                    %s1whenu = find(rewards(when.s1)>meanrs.s1);
                    %uerrs.s1 = sqrt(mean((rewards(when.s1(s1whenu))-meanrs.s1).^2))/sqrt(length(s1whenu));
                    %s2whenu = find(rewards(when.s2)>meanrs.s2);
                    %uerrs.s2 = sqrt(mean((rewards(when.s2(s2whenu))-meanrs.s2).^2))/sqrt(length(s2whenu));
                    %s1a1whenu = find(rewards(when.s1a1)>meanrs.s1a1);
                    %uerrs.s1a1 = sqrt(mean((rewards(when.s1a1(s1a1whenu))-meanrs.s1a1).^2))/sqrt(length(s1a1whenu));
                    %s1a2whenu = find(rewards(when.s1a2)>meanrs.s1a2);
                    %uerrs.s1a2 = sqrt(mean((rewards(when.s1a2(s1a2whenu))-meanrs.s1a2).^2))/sqrt(length(s1a2whenu));
                    %s2a1whenu = find(rewards(when.s2a1)>meanrs.s2a1);
                    %uerrs.s2a1 = sqrt(mean((rewards(when.s2a1(s2a1whenu))-meanrs.s2a1).^2))/sqrt(length(s2a1whenu));
                    %s2a2whenu = find(rewards(when.s2a2)>meanrs.s2a2);
                    %uerrs.s2a2 = sqrt(mean((rewards(when.s2a2(s2a2whenu))-meanrs.s2a2).^2))/sqrt(length(s2a2whenu));
                    
                    analysis{x}.game{g}.subj{s}.when = when;
                    analysis{x}.game{g}.subj{s}.meanrs = meanrs;
                    analysis{x}.game{g}.subj{s}.stdrs = stdrs;
                    %analysis{x}.game{g}.subj{s}.lerrs = lerrs;
                    %analysis{x}.game{g}.subj{s}.uerrs = uerrs;
                end
            end
        end
    end
    plot_subject_mean_rewards(analysis);
end

function [] = plot_subject_mean_rewards(analysis)

    colours = lines(6);
    legloc = 'westoutside';
	games = [1:4];
    numgames = length(games);    
    numsubjects = 9;
    numexps = 2;
    for x=1:numexps
        for g=games
            clear meanrss1a1 meanrss1a2 meanrss2a1 meanrss2a2
            clear stdrss1a1 stdrss1a2 stdrss2a1 stdrss2a2
            clear lerrss1a1 lerrss1a2 lerrss2a1 lerrss2a2
            clear uerrss1a1 uerrss1a2 uerrss2a1 uerrss2a2
            for s=1:numsubjects
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

                    stdrss1a1(s) = stdrs.s1a1;
                    stdrss1a2(s) = stdrs.s1a2;
                    stdrss2a1(s) = stdrs.s2a1;
                    stdrss2a2(s) = stdrs.s2a2;

					% games 3 and 4
					if g == 3 | g == 4
		                meanrss3a1(s) = meanrs.s3a1;
		                meanrss3a2(s) = meanrs.s3a2;

		                stdrss3a1(s) = stdrs.s3a1;
		                stdrss3a2(s) = stdrs.s3a2;
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

                    stdrss1a1(s) = nan;
                    stdrss1a2(s) = nan;
                    stdrss2a1(s) = nan;
                    stdrss2a2(s) = nan;

					% games 3 and 4
					if g == 3 | g == 4
		                meanrss3a1(s) = nan;
		                meanrss3a2(s) = nan;

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
            subplot(numgames,numexps,(g-1)*numexps+x);
            hold on;
            h(1) = bar(partxs,meanrss1a1,'facecolor',colours(1,:),'edgecolor','none');
            h(2) = bar(partxs+1,meanrss1a2,'facecolor',colours(2,:),'edgecolor','none');
            h(3) = bar(partxs+2,meanrss2a1,'facecolor',colours(3,:),'edgecolor','none');
            h(4) = bar(partxs+3,meanrss2a2,'facecolor',colours(4,:),'edgecolor','none');
            errorbar(partxs,meanrss1a1,stdrss1a1,'k.');
            errorbar(partxs+1,meanrss1a2,stdrss1a2,'k.');
            errorbar(partxs+2,meanrss2a1,stdrss2a1,'k.');
            errorbar(partxs+3,meanrss2a2,stdrss2a2,'k.');

			% games 3 and 4
			if g == 3 | g == 4
		        h(5) = bar(partxs+4,meanrss3a1,'facecolor',colours(5,:),'edgecolor','none');
		        h(6) = bar(partxs+5,meanrss3a2,'facecolor',colours(6,:),'edgecolor','none');
		        errorbar(partxs+4,meanrss3a1,stdrss3a1,'k.');
		        errorbar(partxs+5,meanrss3a2,stdrss3a2,'k.');
%				legtext = {'state=1, action=1   ','state=1, action=2   ',...
%							'state=2, action=1   ','state=2, action=2   ',...
%							'state=3, action=1   ','state=3, action=2   '};
				legtext = {'s_1, a_1   ','s_1, a_2   ',...
							's_2, a_1   ','s_2, a_2   ',...
							's_3, a_1   ','s_3, a_2   '};
			else
%				legtext = {'state=1, action=1   ','state=1, action=2   ','state=2, action=1   ','state=2, action=2   '};
				legtext = {'s_1, a_1   ','s_1, a_2   ','s_2, a_1   ','s_2, a_2   '};
			end

            %errorbar(partxs,meanrss1a1,lerrss1a1,uerrss1a1,'k.');
            %errorbar(partxs+1,meanrss1a2,lerrss1a2,uerrss1a2,'k.');
            %errorbar(partxs+2,meanrss2a1,lerrss2a1,uerrss2a1,'k.');
            %errorbar(partxs+3,meanrss2a2,lerrss2a2,uerrss2a2,'k.');
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


