for i=1:10
[gamma logprob]=generate_synthetic(0.65);
save(sprintf('results\\bottom_up\\gamma_%d.mat',i),'gamma')
save(sprintf('results\\bottom_up\\logprob_%d.mat',i),'logprob')
end