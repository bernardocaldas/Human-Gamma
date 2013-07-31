agenttype = 'sarsalambda'
policytype = 'egreedy'
xid = 2
for s=9:-1:1, for g=1:4 , try
        analysis = analyse.maxliksearch_rlalg(s,g,...
            'indir','../kesh/experiments',...
            'outdir','../kesh/analysis/maxliksearch',...
            'agenttype',agenttype,'policytype',policytype,'xid',xid)
catch
    fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
end, end, end

% agenttype = 'sarsalambda'
% policytype = 'softmax'
% xid = 1
% for s=9:-1:1, for g=1:4 , try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch',...
%             'agenttype',agenttype,'policytype',policytype,'xid',xid)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% agenttype = 'sarsa'
% policytype = 'egreedy'
% xid = 1
% for s=9:-1:1, for g=1:4 %, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'policytype',policytype,'xid',xid)
% %catch
%  %   fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end%, end
% 
% agenttype = 'qlearn'
% policytype = 'egreedy'
% xid = 1
% for s=9:-1:1, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'policytype',policytype,'xid',xid)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% agenttype = 'sarsa'
% policytype = 'softmax'
% xid = 1
% for s=9:-1:1, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'policytype',policytype,'xid',xid)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% 
% agenttype = 'qlearn'
% policytype = 'softmax'
% xid = 1
% for s=9:-1:1, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'policytype',policytype,'xid',xid)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% agenttype = 'qp'
% critictype = 'sarsa'
% xid = 1
% for s=9:-1:1, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'critictype',critictype,'xid',xid)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% agenttype = 'qp'
% critictype = 'qlearn'
% xid = 1
% for s=9:-1:1, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'critictype',critictype,'xid',xid)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% 
% 
% agenttype = 'sarsa'
% policytype = 'egreedy'
% numstates = 1;
% xid = 1
% for s=1:9, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'policytype',policytype,'xid',xid,'numstates',numstates)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% 
% agenttype = 'qlearn'
% policytype = 'egreedy'
% numstates = 1;
% xid = 1
% for s=1:9, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'policytype',policytype,'xid',xid,'numstates',numstates)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% agenttype = 'sarsa'
% policytype = 'softmax'
% numstates = 1;
% xid = 1
% for s=1:9, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'policytype',policytype,'xid',xid,'numstates',numstates)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% 
% agenttype = 'qlearn'
% policytype = 'softmax'
% numstates = 1;
% xid = 1
% for s=1:9, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'policytype',policytype,'xid',xid,'numstates',numstates)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% agenttype = 'qp'
% critictype = 'sarsa'
% numstates = 1;
% xid = 1
% for s=1:9, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'critictype',critictype,'xid',xid,'numstates',numstates)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% agenttype = 'qp'
% critictype = 'qlearn'
% numstates = 1;
% xid = 1
% for s=1:9, for g=1:4, try
%         analysis = analyse.maxliksearch_rlalg(s,g,...
%             'indir','../kesh/experiments',...
%             'outdir','../kesh/analysis/maxliksearch/',...
%             'agenttype',agenttype,'critictype',critictype,'xid',xid,'numstates',numstates)
% catch
%     fprintf('Failed to run experiment for subject %d, game %d\n',s,g)
% end, end, end
% 
% 
% 
