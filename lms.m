function [output,error ] = lms(x,di,sysorder)
%sysorder = 5;                   % System Order
N = length(x);                   % the number of Itterations
b  = fir1(sysorder-1,0.5);       % FIR system to be identified 
n  = 0.01*randn(N,1);            % Uncorrelated noise signal 
d  = filter(b,1,di)+n;           % Desired signal = output of H + Uncorrelated noise signal
w = zeros (sysorder, 1) ;        % Initially filter weights are zero

%-----------------------x-------------------x------------------x---------------x------------------
% LMS Algoritham
% System Training
for n = sysorder : N 
	u = x(n:-1:n-sysorder+1) ;
    y(n)= w' * u;                % output of the adaptive filter
    e(n) = d(n) - y(n) ;         % error signal = desired signal - adaptive filter output
    mu=0.001;                    % step size
    w = w + mu * u * e(n) ;      % filter weights update
  
end 

% Output of Adaptive filter
for n = sysorder : N 
	u = x(n:-1:n-sysorder+1) ;
    y(n)= w' * u;                % output of the adaptive filter
    e(n) = d(n) - y(n) ;         % error signal = desired signal - adaptive filter output
    signal_power = sum(d(n).^2) ;
    noise_power = sum(e(n).^2) ;
    ERLE(n) = 10*log10(signal_power/noise_power);
    SNR(n) = 20*log10(rms(u)/rms(e(n)));
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
xc = xcorr(y,x);
plot(xc);
title('Cross Correlation') ;
xlabel('Samples');
ylabel('Magnitude');


%-----------------------x-------------------x------------------x---------------x------------------
% Visualization and Observation


figure()
hold on       
plot(d,'g');
plot(y,'r');
semilogy((abs(e)),'m') ;
title('System output') ;
xlabel('Samples');
ylabel('True and estimated output');
legend('Desired','Output','Error');
axis([0 N -2 2.5]);

figure()
stem(b', 'k');
hold on
stem(w, 'r');
legend('Actual weights','Estimated weights');
title('Comparison of the actual weights and the estimated weights') ;


%-----------------------x-------------------x------------------x---------------x------------------
% Return output
output = y;
error = e;
end