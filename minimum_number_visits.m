e=[0.1,0.2,0.25,0.33,0.5];
N=[1 2 3 4 5 6 7 8 9 10];
x=[0.3 0.4 0.5 0.6 0.7 0.8 0.9];
for i=1:length(e)
    for j=1:length(N);
        for l=1:length(x)
            
        k=binoinv(1-e(i),N(j),0.6481);
        b(l,j,i)=1-binocdf(k, N(j),x(l))+binopdf(k, N(j),x(l));
        end
    end
end
