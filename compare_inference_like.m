methods={'window_smooth'}%,'ratio_smooth','window_best','ratio_best'};
markers = ['x','+','s','d','o'];
lmethods=length(methods);
% loglik=zeros(9,4,length(methods));
for subject=1:9
    for game=3:4
        [model, sim, env ] = games.get(2,game)
        try
        trace=analyse.load_xdata(2,subject,game);
        for i=1:lmethods
%             loglik(subject,game,i)=analyse.inference.topdown_logprob(trace,'method',methods{i})
             [logprobr(subject,game,:) gammar(subject,game,:)] =analyse.inference.compare_methods(trace,env,game);
        end

        catch err
            warning('Analysis failed on subject %d, game %d',subject,game)
        end
    end
end