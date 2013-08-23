gammas=[0.5 0.6 0.7 0.8 0.9]
for i=1:5
[gamma logprob]=generate_synthetic(gammas(i));
save(sprintf('results\\bottom_up\\gamma_%d.mat',i),'gamma')
save(sprintf('results\\bottom_up\\logprob_%d.mat',i),'logprob')
end