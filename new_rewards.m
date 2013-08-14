function rewards = new_rewards()
N=600;
step=0.05;
stepsize=5;
r(1:stepsize)=0.6;
% values=[1,0.3.0.90,0.35,0.80,0.40,0.75,0.45,0.70,0.5,0.65];
values=[0.95,0.20,0.80,0.25,0.75,0.30,0.70,0.35,0.65,0.40,0.6];
% values=[0.2,0.8,0.8,0.2,0.8,0.2,0.8,0.2,0.8,0.2,0.8,0.2];
current=0;
for i=1:length(values)%N/stepsize
    l=poissrnd(60);
    r(current+1:current+l)=values(i);
    current=current+l;
%     p=rand;
%     if p>=2/3
%         r(stepsize*i+1:stepsize*i+stepsize+1)=r(stepsize*i);
%     elseif p<tolerance(r(stepsize*i))
%         if r(stepsize*i)-step<=0;
%             r(stepsize*i+1:stepsize*i+stepsize+1)=0;
%         else
%             r(stepsize*i+1:stepsize*i+stepsize+1)=r(stepsize*i)-step;
%         end
%     else
%         if r(stepsize*i)+step>=1;
%             r(stepsize*i+1:stepsize*i+stepsize+1)=1;
%         else
%             r(stepsize*i+1:stepsize*i+stepsize+1)=r(stepsize*i)+step;
%         end
%     end
%      r(stepsize*i+1:stepsize*i+stepsize+1)=0.60+0.3*sin(3.75*stepsize*i);
    
    
end
rewards=r;
end

function tol = tolerance(x)
lim_inf=0.4;
lim_sup=0.8;
max_prob=2/3;
if x <lim_inf
    tol=x*(max_prob*0.5)/(lim_inf);
elseif x>lim_sup
    tol=x*((max_prob)-(max_prob*0.5))/(1-lim_sup) + ((max_prob)-((max_prob)-(max_prob*0.5))/(1-lim_sup));
else
    tol=max_prob*0.5;
end

end
