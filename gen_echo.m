function out = gen_echo(sample)
% Add Echo signal 
len = length(sample);
del = zeros(1,len);
del(10)   = 0.8;
del(2000) = 0.8;
del(4000) = 0.8;

%-----------------------x-------------------x------------------x---------------x------------------

ec = conv(sample,del);                % Echo signal = real_signal + time_delay_of_real_signal
ec = ec(1:len);
ec = ec';
%-----------------------x-------------------x------------------x---------------x------------------
% Visualization and Observation
figure                                                   %Visualazation
subplot(2,1,1)
plot(ec)
title('Echo signal and its spectrogram') ;
xlabel('Time')
ylabel('Amplitude')
subplot(2,1,2)
spectrogram(ec)


out = ec;
end
