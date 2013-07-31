function [ analysis ] = conditional_action_probabilities()
    data = load('../kesh/experiments/all.mat','xids');
    xids = data.xids;
    clear data;
    subjects = [1:9];
    numsubjects = length(subjects);
    colours = lines(numsubjects);
    numbins = 5;
    totbinscontlong = cell(1,numbins);
    totbinsabandlong = cell(1,numbins);
    x = 2; g = 1; s=2;
%    for x=1:2
%       for g=1:2
            for s=subjects
                try
                    gamedata = xids{x}.game{g}.subj{s};
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


                    when.s1 = find(s1);
                    when.s2 = find(s2);
                    when.s1a1 = find(s1a1);
                    when.s1a2 = find(s1a2);
                    when.s2a1 = find(s2a1);
                    when.s2a2 = find(s2a2);
                    if g >= 3
                        s3 = (states(1:end-1) == 3);
                        s3a1 = (s3 & (actions == 1));
                        s3a2 = (s3 & (actions == 2));
                        when.s3 = find(s3);
                        when.s3a1 = find(s3a1);
                        when.s3a2 = find(s3a2);
                    end

                    % can only do this for game 1, but we can plot the frequency with which the next action is
                    switch g
                    case 1
                        %subplot(2,1,1);
                        whencontlong = find(s2a1(1:end-1) & s1a1(2:end));
                        whenabandlong = find(s2a1(1:end-1) & s1a2(2:end));
                        binbounds = linspace(30,110,numbins+1);
                        binwidth = binbounds(2)-binbounds(1);
                        bincentres = binwidth/2 +binbounds(1:end-1);
                        rewcontlong = rewards(whencontlong);
                        %hist(rewcontlong,bincentres),xlim([30,110]);
                        %subplot(2,1,2);
                        rewabandlong = rewards(whenabandlong);
                        %hist(rewabandlong,bincentres),xlim([30,110]);
                        for b=1:length(bincentres)
                            rewscontlong = rewcontlong(find(rewcontlong >= binbounds(b) & rewcontlong < binbounds(b+1)));
                            rewsabandlong = rewabandlong(find(rewabandlong >= binbounds(b) & rewabandlong < binbounds(b+1)));
                            totbinscontlong{b} = [totbinscontlong{b}; rewscontlong];
                            totbinsabandlong{b} = [totbinsabandlong{b}; rewsabandlong];
                            % assuming flat prior, then the beta distribution estimates the prob of continuing with long in following way
                            alpha = length(rewscontlong) + 1; % positive evidence
                            beta = length(rewsabandlong) + 1; % negative evidence
                            try
                                avgprob(b) = alpha/(alpha+beta);
                                stdprob(b) = sqrt(alpha*beta/(alpha+beta)^2/(alpha+beta+1));
                                relevantrews = [rewscontlong' rewsabandlong'];
                                avgrew(b) = mean(relevantrews);
                                sterew(b) = std(relevantrews)/sqrt(length(relevantrews));
                            catch
                                avgrew(b) = nan;
                                sterew(b) = nan;
                            end
                        end
                        h(s,:) = utils.ploterr(avgrew,avgprob,sterew,stdprob,'x-');
                        set(h(s,:),'color',colours(s,:));
                        hold on;
                        clear avgprob stdprob avgrew sterew
                    otherwise
                        error('Game number not supported');
                    end % switch
                end % try
            end % for - each subject
            xlabel('Previously Experienced Reward');
            ylabel('Est. prob. of subsequently choosing Long')
            hold off;
            % now do the overall average
            for b=1:length(bincentres)
                rewscontlong = totbinscontlong{b};
                rewsabandlong = totbinsabandlong{b};
                % assuming flat prior, then the beta distribution estimates the prob of continuing with long in following way
                alpha = length(rewscontlong) + 1; % positive evidence
                beta = length(rewsabandlong) + 1; % negative evidence
                try
                    totavgprob(b) = alpha/(alpha+beta);
                    totstdprob(b) = sqrt(alpha*beta/(alpha+beta)^2/(alpha+beta+1));
                    relevantrews = [rewscontlong' rewsabandlong'];
                    totavgrew(b) = mean(relevantrews);
                    totsterew(b) = std(relevantrews)/sqrt(length(relevantrews));
                catch
                    totavgrew(b) = nan;
                    totsterew(b) = nan;
                end % try
            end % for -each bincentre
            figure;
            utils.ploterr(totavgrew,totavgprob,totsterew,totstdprob);
            xlabel('Previously Experienced Reward');
            ylabel('Est. prob. of subsequently choosing Long')
%        end % for - each game
%    end % for - each experiment id (xid)
end

