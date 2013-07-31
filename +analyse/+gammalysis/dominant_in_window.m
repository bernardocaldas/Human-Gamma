function [ analysis ] = dominant_in_window(xid,game,width,trace,env,summary,varargin)
% predicts the gamma of the subject from the choice of action 
% looks at visits to state 1 at times t(1),t(2),...,t(k)
% uses the dominant action on visits i to (i+w-1) for window w.

    kwargs = utils.dict(varargin{:});
    if nargin < 6
        summary = analyse.get_summary( game, trace );
    end

    if xid ~= 2
        error('Experiment xid of %d not supported',xid);
    end
    states = trace.states;
    actions = trace.actions;
    rewards = trace.rewards;
    varrewards = env.varrewards;
    numchoices = length(actions);

    binary = summary.binary;
    when = summary.when;

    analysis.s1 = binary.s1;
    analysis.s1a1 = binary.s1a1;
    analysis.s1a2 = binary.s1a2;
    analysis.width = width;

    switch game 
    case {1,2}
        daft = binary.s2a2;
        % we want to know how often subject is daft in the region of some time point <daftlevel>
        daftwindow = kwargs.get('daftwidth',width);
        middaftwindow = ceil(daftwindow/2);
        complmiddaftwindow = floor(daftwindow/2);
        propdaft = analyse.mwa(daft,daftwindow);
        daftindex = 1;
        for t=middaftwindow:numchoices
            if states(t) == 2
                daftindex = daftindex + 1;
            end
            try
                daftlevel(t) = propdaft(daftindex);
            end
        end
        analysis.daft = daft;
        analysis.propdaft = propdaft;
        analysis.daftlevel = daftlevel;

        % use of mean window average : analyse.mwa gives
        % mwvals = analyse.mwa(vals,w) 
        % => mwvals(i) = mean(vals(i:i+w-1)) for all i =1,2,...,(length(vals)-w+1)

        % proplongs(i) is proportion of chosing opportunities in which long strat chosen
        % between opportunity i and opportunity i+width-1
        proplongs = analyse.mwa(binary.s1a1(when.s1),width);
        % indicating tendency to choose at opportunity i
        choselong = floor(proplongs+0.5); 
        analysis.proplongs = proplongs;
        analysis.choselong = choselong;

        % find the indices at which the changes occur.
        current = choselong(1);
        lastopportunity = when.s1(1);
        if lastopportunity ~= 1
            error('Subject not in state 1 at time 1')
        end
        t=2;
        strategy = [];
        upinds = [];
        downinds = [];
        detectedup = [];
        detecteddown = [];
        while t <= when.s1(end-width)
            opportunitycount = find(when.s1 <= t,1,'last');
            opportunitytime = when.s1(opportunitycount);
            % only possible to evaluate changed strategy at an opportunity
            if opportunitytime == t % if this is an opportunity
                % at ith visit to s1, current=1 indicating long strategy
                if current
                    % if mean choice is short from this point on for next w opportunities
                    % and this choice is short, then switching reward is nearby (in past)
                    if ~choselong(opportunitycount) & ~binary.s1a1(t) %XXX
                        % we assume that most recent variable reward (before time t) was the one that informed this.
                        rewardtime = when.s2a1s1(find(when.s2a1s1 < t,1,'last'));
                        detecteddown = [ detecteddown t];
                        downinds = [downinds rewardtime];
                        current = 0; % new strategy is short
                        strategy(rewardtime+1:t) = 0; % retrospectively apply this strategy to just after reward
                    end
                else
                    % if mean choice from this point on for next w opportunities is long
                    % and this choice is also long, then switching reward is nearby (in future)
                    if choselong(opportunitycount) & binary.s1a1(t) %XXX
                        % we assume that the first variable reward that came strictly after, the current
                        % opportunity that informs this switch
                        % NOT
                        %XXX first variable reward that came strictly after, the previous
                        %XXX opportunity to chose
                        %XXX lastchoice = find(when.s1a1 < t,1,'last')+1;
                        rewardtime = when.s2a1s1(find(when.s2a1s1 >= t,1,'first'));
                        detectedup = [ detectedup t];
                        upinds = [upinds rewardtime];
                        %%XXX strategy(lastchoice:rewardtime-1) = 0; % until rewardtime strategy is short
                        %%XXX if rewardtime < t
                        %%XXX     strategy(rewardtime:t) = 1;
                        %%XXX else
                            t = rewardtime; % new time is at that reward
                            strategy(t) = 1;
                        %%XXX end
                        current = 1; % new strategy is long
                    end
                end
            else
                strategy(t) = current;
            end
            t = t+1; % tick time.
        end
        strategy(length(choselong)+1:length(binary.s1)) = current;
    %XXX changed cos xid 2 game 3 is in fact the same as xid 1 game 3
    %case {3,4}
    case 4
        % daft analysis

        % proplongs(i) is proportion of opportunities for chosing long strat between
        % opportunity i and opportunity i+width-1
        proplongs = analyse.mwa(binary.s1a1(when.s1),width);
        % indicating tendency to choose at opportunity i
        choselong = floor(proplongs+0.5); 

        % find the indices at which the changes occur.
        current = choselong(1);
        lastopportunity = when.s1(1);
        if lastopportunity ~= 1
            error('Subject not in state 1 at time 1')
        end
        t=2;
        strategy = [];
        upinds = [];
        downinds = [];
        detectedup = [];
        detecteddown = [];
        while t <= length(choselong)
            opportunitycount = find(when.s1 <= t,1,'last');
            opportunitytime = when.s1(opportunitycount);
            % only possible to evaluate changed strategy at an opportunity
            if opportunitytime == t
                % at ith visit to s1, current=1 indicating long strategy
                if current
                    % if mean choice is short from this point on then switch nearby (in past)
                    if ~choselong(opportunitycount) & ~binary.s1a1(t) %XXX
                        % we assume that most recent variable reward (before time t) was the one that informed this.
                        rewardtime = when.s3a1s1(find(when.s3a1s1 < t,1,'last'));
                        detecteddown = [ detecteddown t];
                        downinds = [downinds rewardtime];
                        current = 0; % new strategy is short
                        strategy(rewardtime+1:t) = 0; % retrospectively apply this strategy to just after reward
                    end
                else
                    % if mean choice is long from this point on then switch nearby (in future)
                    if choselong(opportunitycount) & binary.s1a1(t) %XXX
                        % we assume that the first variable reward that came strictly after, the current
                        % opportunity that informs this switch
                        % NOT
                        %XXX first variable reward that came strictly after, the previous
                        %XXX opportunity to chose
                        %XXX lastchoice = find(when.s1a1 < t,1,'last')+1;
                        rewardtime = when.s3a1s1(find(when.s3a1s1 >= t,1,'first'));
                        detectedup = [ detectedup t];
                        upinds = [upinds rewardtime];
                        %%XXX strategy(lastchoice:rewardtime-1) = 0; % until rewardtime strategy is short
                        %%XXX if rewardtime < t
                        %%XXX     strategy(rewardtime:t) = 1;
                        %%XXX else
                        t = rewardtime; % new time is at that reward
                        strategy(t) = 1;
                        %%XXX end
                        current = 1; % new strategy is long
                    end
                end
            else
                strategy(t) = current;
            end
            t = t+1; % tick time.
        end
        strategy(length(choselong)+1:length(binary.s1)) = current;
    case 3
        %%% Should also be true for game 3 but infact game three is old method, i.e. xid==1
        % daft analysis

        % proplongs(i) is proportion of opportunities for chosing long strat between
        % opportunity i and opportunity i+width-1
        proplongs = analyse.mwa(binary.s1a1(when.s1),width);
        % indicating tendency to choose at opportunity i
        choselong = floor(proplongs+0.5); 

        % find the indices at which the changes occur.
        current = choselong(1);
        lastopportunity = when.s1(1);
        if lastopportunity ~= 1
            error('Subject not in state 1 at time 1')
        end
        t=2;
        strategy = [];
        upr1s = [];
        upr2s = [];
        downr1s = [];
        downr2s = [];
        upinds = [];
        downinds = [];
        detectedup = [];
        detecteddown = [];
        while t <= length(choselong)
            opportunitycount = find(when.s1 <= t,1,'last');
            opportunitytime = when.s1(opportunitycount);
            % only possible to evaluate changed strategy at an opportunity
            if opportunitytime == t
                % at ith visit to s1, current=1 indicating long strategy
                if current
                    % if mean choice is short from this point on then switch nearby (in past)
                    if ~choselong(opportunitycount) & ~binary.s1a1(t) %XXX
                        % we assume that most recent variable rewards (before time t) inform this
                        detecteddown = [ detecteddown t];
                        %downinds = [downinds rewardtime];
                        downr1time = when.s1a2s1(find(when.s1a2s1 < t,1,'last'));
                        downr2time = when.s3a2s1(find(when.s3a2s1 < t,1,'last'));
                        % only record if both values have been experienced.
                        if ~isempty(downr1time) & ~isempty(downr2time)
                            downr1s = [downr1s trace.rewards(downr1time)];
                            downr2s = [downr2s trace.rewards(downr2time)];
                        end
                        current = 0; % new strategy is short
                        strategy(downr2time+1:t) = 0; % retrospectively apply this strategy to just after reward
                    end
                else
                    % if mean choice is long from this point on then switch nearby (in future)
                    if choselong(opportunitycount) & binary.s1a1(t) %XXX
                        % we assume that the first variable reward r2 that came strictly after, the current
                        % opportunity that informs this switch
                        % and r1 from before
                        detectedup = [ detectedup t];
                        upr1time = when.s1a2s1(find(when.s1a2s1 < t,1,'last'));
                        upr2time = when.s3a2s1(find(when.s3a2s1 >= t,1,'first'));
                        % only record if both values have been experienced.
                        if ~isempty(upr1time) & ~isempty(upr2time)
                            upr1s = [upr1s trace.rewards(upr1time)];
                            upr2s = [upr2s trace.rewards(upr2time)];
                        end
                        t = upr2time; % new time is at that reward
                        strategy(t) = 1;
                        %%XXX end
                        current = 1; % new strategy is long
                    end
                end
            else
                strategy(t) = current;
            end
            t = t+1; % tick time.
        end
        strategy(length(choselong)+1:length(binary.s1)) = current;
    otherwise
        error('Unrecognised game');
    end
    % evaluation from a certain point only
    evaluatefrom = kwargs.get('evaluatefrom',0); % only evaluate from this point onwards, i.e. ignore indices lower
    upinds = upinds(upinds > evaluatefrom);
    downinds = downinds(downinds > evaluatefrom);

    analysis.upinds = upinds;
    analysis.downinds = downinds;
    analysis.detectedup = detectedup;
    analysis.detecteddown = detecteddown;

    % find the reward that changed the strategy down or up
    if game == 1
        downrs = rewards(downinds);
        uprs = rewards(upinds);
    elseif game == 2 | game == 4 % game 2 rewards must be sampled from varreward vector
        downrs = varrewards(downinds);
        uprs = varrewards(upinds);
    else
        downrs = varrewards(detecteddown);
        uprs = varrewards(detectedup);
    end
    % game 3 is from xid =1 so is different

    % the gammas
    downgs = [];
    upgs = [];
    if game ~= 3 % cos game 3 is done differently
        for p=1:length(downrs), downgs(p) = env.get_gamma(downrs(p)); end;
        for p=1:length(uprs), upgs(p) = env.get_gamma(uprs(p)); end;
        analysis.uprs = uprs;
        analysis.downrs = downrs;
    else
        analysis.upr1s = upr1s;
        analysis.downr1s = downr1s;
        analysis.upr2s = upr2s;
        analysis.downr2s = downr2s;
        for p=1:length(downr1s), downgs(p) = env.get_gamma(downr1s(p),downr2s(p)); end;
        for p=1:length(upr1s), upgs(p) = env.get_gamma(upr1s(p),upr2s(p)); end;
    end
    try
        analysis.upgs = upgs;
        analysis.downgs = downgs;
        analysis.meanupg = mean(upgs);
        analysis.meandowng = mean(downgs);
        analysis.meang = mean([upgs downgs]);
        analysis.stdupg = std(upgs);
        analysis.stddowng = std(downgs);
        analysis.stdg = std([upgs downgs]);
        analysis.steupg = utils.ste(upgs);
        analysis.stedowng = utils.ste(downgs);
        analysis.steg = utils.ste([upgs downgs]');
    catch thrown
        warning(sprintf('Failed to store all analysis with error: %s',thrown.message()));
    end
end
