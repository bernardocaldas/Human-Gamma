ssh matrix18
cd ~/academic/projects/parkinsons/kesh/
matlab -nodisplay -nosplash -singleCompThread

clear
xid = 2
trials = 1
for game = 3
for subject=3:9, try
[ analysis ] = analyse.maxliksearch_rlalg(subject,game,'trials',trials,'agenttype','modelbased','policytype','egreedy','xid',xid,'outdir','../kesh/analysis/maxliksearch')
catch thrown
fprintf('searches ended with error: %s\n', thrown.message());
end, end
for subject=1:9, try
[ analysis ] = analyse.maxliksearch_rlalg(subject,game,'trials',trials,'agenttype','modelbased','policytype','softmax','xid',xid,'outdir','../kesh/analysis/maxliksearch')
catch thrown
fprintf('searches ended with error: %s\n', thrown.message());
end, end
for subject=1:9, try
[ analysis ] = analyse.maxliksearch_rlalg(subject,game,'trials',50,'agenttype','sarsa','policytype','softmax','xid',xid,'outdir','../kesh/analysis/maxliksearch')
catch thrown
fprintf('searches ended with error: %s\n', thrown.message());
end, end
for subject=1:9, try
[ analysis ] = analyse.maxliksearch_rlalg(subject,game,'trials',50,'agenttype','qlearn','policytype','softmax','xid',xid,'outdir','../kesh/analysis/maxliksearch')
catch thrown
fprintf('searches ended with error: %s\n', thrown.message());
end, end
end

