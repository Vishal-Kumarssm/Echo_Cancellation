function [output,error ] = rls(x,xe)

inp = xe;
N=length(inp);
n = randn(N,1);


%-----------------------x-------------------x------------------x---------------x------------------
% Unknown System for Desired signal
[b,a] = butter(2,0.25);
Gz = tf(b,a,-1);
h=[b -a(2:length(a))];
y = lsim(Gz,x);
n = n * std(y)/(15*std(n));
d = y + n;                             %add some noise

%-----------------------x-------------------x------------------x---------------x------------------
%channel system order fixed as we have 5 elements (3 in a and 2 in b)
inporder=3;
outorder=2;
sysorder = inporder + outorder ;
totallength = size(d,1);
N=100 ;                                  %Number of iteration in training period
lamda = 0.999 ;                         %forgetting factor	
delta = 1e2 ;		 
P = delta * eye (sysorder ) ;
w = zeros ( sysorder  , 1 ) ;
for n = inporder : N 
	u = inp(n:-1:n-inporder+1) ;
    outp= d(n-1:-1:n-outorder) ;
    u=[u ; outp];
    phi = u' * P ;
	k = phi'/(lamda + phi * u );
    y(n)=w' * u;
    e(n) = d(n) - y(n) ;
	w = w + k * e(n) ;
	P = ( P - k * phi ) / lamda ;
end 

%RLS Adaptive Model
for n =  N+1 : totallength
	u = inp(n:-1:n-inporder+1) ;
    outp= d(n-1:-1:n-outorder) ;    
    u=[u ; outp];
    y(n) = w' * u ;
    e(n) = d(n) - y(n) ;
    signal_power = sum(d(n).^2) ;
    noise_power = sum(e(n).^2) ;
    ERLE(n) = 10*log10(signal_power/noise_power);
end 

%-----------------------x-------------------x------------------x---------------x------------------
% Visualization and Observation

figure()
plot(ERLE,'g');
title('System output') ;
xlabel('Samples')
ylabel('Power(dB)')
legend('ERLE')

figure()
xc = xcorr(y,d);
plot(xc);
title('Cross Correlation') ;
xlabel('Samples');
ylabel('Magnitude');

%-----------------------x-------------------x------------------x---------------x------------------
% Visualization and Observation

figure()
hold on
plot(d,'b');
plot(y,'r');
semilogy((abs(e)),'y') ;
title('System output') ;
xlabel('Samples');
ylabel('True and estimated output');
legend('Desired','Output','Error');


figure()
stem(h, 'b')
hold on
stem(w, 'r')
legend('Filter weights','Estimated filter weights');
title('Comparison of the filter weights and estimated weights') ;

%-----------------------x-------------------x------------------x---------------x------------------
% Return output
output = y;
error = e;
end