methods={'window_smooth','ratio_smooth'};
markers = ['x','+','s','d','o'];
cc=lines(10);
% lik=zeros(9,4,length(methods));
lik(:,:,1:3)=zeros(9,4,3);
for subject=1:9
    for game=1:4
        try
        data=analyse.load_xdata(2,subject,game)
        actions=data.actions;
        states=data.states;
        visit=states==1;
        visit=visit(1:end-1);
        
        p1=[];p2=[];p3=[];
        figure('Position', [100, 100, 1049, 500]);
        for i=1:length(methods)
            switch methods{i}
                case {'window_smooth','ratio_smooth','window_best','ratio_best','evidence'}
                    %Harmonic weights
                    for j=min(states):max(states)
                        indicator=actions(visit)==j;
                        [ probests domests ] = analyse.inference.infer_policy(indicator,'method',methods{i},'scheme','harmonic');
                        if j==1
                            s(2)=subplot(3,1,2);
                            hold on;
                            p2=[p2 plot(domests,'color',cc(i,:),'marker',markers(i),'MarkerSize',4)];
                            s(3)=subplot(3,1,3);
                            hold on;
                            p3=[p3 plot(probests,'color',cc(i,:),'marker',markers(i),'MarkerSize',4)];
                        end
                    end
                case 'sarsa'
                    analysis = analyse.maxliksearch_rlalg(subject,game,'agenttype',methods{i},'policytype','softmax','trials',10);
                    lik(subject,game,i)=analysis.logprob;
                case 'qlearn'
                    analysis = analyse.maxliksearch_rlalg(subject,game,'agenttype',methods{i},'policytype','egreedy');
                    lik(subject,game,i)=analysis.logprob;
            end
        end
        hL=legend(p2,'window harm','window inverse sqr','ratio harmonic','ratio inverse sqr','Location','best');
        set(hL,...
    'Position',[0.838630243088649 0.478166666666667 0.158245948522402 0.158666666666667]);
        xlabel(s(3),'Step');
        ylabel(s(2),'Dominant Action');
        ylabel(s(3),'Probability of Action 1');
        set(s(2),'YLim',[-0.1 1.1])
        %Action Plot
        s(1)=subplot(3,1,1);
        plot(actions(visit),'x');
        set(gca,'YLim',[0.8 2.2])
        ylabel('Action');
        title(sprintf('Subject %d, Game %d',subject,game));
        saveas(gcf,['inference_' sprintf('s%dg%d',subject,game) '.eps'],'epsc');
        close all
        catch err
            warning('Analysis failed on subject %d, game %d',subject,game)
        end
    end
end
lik;

% hold off
%
% figure();

% for i=1:5
%
%     [ probests domests ] = analyse.inference.infer_policy(data.actions-1,'method','ratio','k',i);
%     plot(domests,[markers(i) '-'],'color',cc(i,:),'markersize',5)
%     hold on;
% end
