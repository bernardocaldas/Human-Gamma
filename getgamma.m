methods={'window_smooth'};
markers = ['x','+','s','d','o'];
cc=lines(10);
for subject=1:9
    for game=1:4
        try
            [ data, env, stem, indir, summary ]=analyse.load_xdata(2,subject,game);
            actions=data.actions;
            states=data.states;
            visit=states==1;
            visit=visit(1:end-1);
            varrewards=env.varrewards(1:length(states)-1);
            rewards = data.rewards;
            lastreward=[0 rewards(1:end-1)];
            
            p1=[];p2=[];p3=[];
            figure('Position', [100, 100, 1049, 500]);
            for i=1:length(methods)
                switch methods{i}
                    case {'window_smooth','ratio_smooth','window_best','ratio_best','evidence'}
                        [probests domests] = analyse.inference.infer_policy(actions(visit)==2,'method',methods{i},'scheme','harmonic');
                        s(2)=subplot(4,1,2);
                        hold on;
                        p2=[p2 plot(domests+1,'color',cc(i,:),'marker',markers(i),'MarkerSize',4)];
                        s(3)=subplot(4,1,3);
                        hold on;
                        p3=[p3 plot(probests,'color',cc(i,:),'marker',markers(i),'MarkerSize',4)];
                        s(4)=subplot(4,1,4);
                        plot(lastreward(visit));
                        xestimate=analyse.inference.get_x(varrewards,visit,actions,domests);
                        gamma(subject, game, i)=env.get_gamma(xestimate);

                end
            end
            hL=legend(p2,'window smooth','ratio smooth','Location','best');
            set(hL,...
                'Position',[0.838630243088649 0.478166666666667 0.158245948522402 0.158666666666667]);
            xlabel(s(3),'Step');
            ylabel(s(2),'Dominant Action');
            ylabel(s(3),'Probability of Action 1');
            set(s(2),'YLim',[0.9 2.1])
            %Action Plot
            s(1)=subplot(4,1,1);
            plot(actions(visit),'x');
            set(gca,'YLim',[0.8 2.2])
            ylabel('Action');
            title(sprintf('Subject %d, Game %d',subject,game));
            saveas(gcf,['img\inference\visit\inference_' sprintf('s%dg%d',subject,game) '.eps'],'epsc');
            saveas(gcf,['img\inference\visit\inference_' sprintf('s%dg%d',subject,game) '.jpg']);
            close all
        catch err
            warning('Analysis failed on subject %d, game %d',subject,game)
        end
    end
end

% hold off
%
% figure();

% for i=1:5
%
%     [ probests domests ] = analyse.inference.infer_policy(data.actions-1,'method','ratio','k',i);
%     plot(domests,[markers(i) '-'],'color',cc(i,:),'markersize',5)
%     hold on;
% end
