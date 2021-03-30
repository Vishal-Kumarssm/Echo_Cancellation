clear all;
close all;
clc;

%-----------------------x-------------------x------------------x---------------x------------------
%% Original audio/read the audio signal 
[X,Fs] = audioread('speech_dft.wav');                    %read sound
len_aud = length(X);
soundsc(X,Fs);                                           %Speaker
figure                                                   %Visualazation
subplot(2,1,1)
plot(X);
title('Real signal and its spectrogram') ;
xlabel('Sample');
ylabel('Amplitude');
subplot(2,1,2)
spectrogram(X);
pause(len_aud/Fs);                                       %programe intrupt/programe wait

%-----------------------x-------------------x------------------x---------------x------------------
%% Audio with ECHO(Call function gen_echo)
Xe = gen_echo(X);                                        %Call echo function to generate echo
soundsc(Xe,Fs);                                          %Speaker
pause(length(Xe)/Fs);                                    %programe intrupt/programe wait

filename = 'Echo_signal.wav';                            %file name
audiowrite(filename,Xe,Fs);                              %Save the audio in local file

%-----------------------x-------------------x------------------x---------------x------------------
%% Adaptive filter with lms algorithm
[filtered_signal , error_signal ] = lms(X,Xe,1024);

figure                                                          %Visualazation
subplot(2,1,1)
plot(filtered_signal);
title('LMS output and its spectrogram') ;
xlabel('Sample');
ylabel('Amplitude');
subplot(2,1,2)
spectrogram(filtered_signal);

soundsc(filtered_signal,Fs);                                   %Speaker
pause(length(filtered_signal)/Fs);

soundsc(error_signal,Fs);                                      %Speaker
pause(length(error_signal)/Fs);

filename = 'lmsoutput_code.wav';                                  %file name
audiowrite(filename,filtered_signal,Fs);                                    %Save the audio in local file

%-----------------------x-------------------x------------------x---------------x------------------
%% Adaptive filter with nlms algorithm

[filtered_signal , error_signal ] = nlms(X,Xe,1024);

figure                                                         %Visualazation
subplot(2,1,1)
plot(filtered_signal);
title('NLMS output and its spectrogram') ;
xlabel('Sample');
ylabel('Amplitude');
subplot(2,1,2)
spectrogram(filtered_signal);

soundsc(filtered_signal,Fs);                                   %Speaker
pause(length(filtered_signal)/Fs);

soundsc(error_signal,Fs);                                      %Speaker
pause(length(error_signal)/Fs);

filename = 'nlmsoutput_code.wav';                                  %file name
audiowrite(filename,filtered_signal,Fs);                                    %Save the audio in local file

%-----------------------x-------------------x------------------x---------------x------------------
%% Adaptive filter with rls algorithm

[filtered_signal , error_signal ] = rls(X,Xe);

figure()                                                         %Visualazation
subplot(2,1,1)
plot(filtered_signal);
title('RLS output and its spectrogram') ;
xlabel('Sample');
ylabel('Amplitude');
subplot(2,1,2)
spectrogram(filtered_signal);

soundsc(filtered_signal,Fs);                                   %Speaker
pause(length(filtered_signal)/Fs);

soundsc(error_signal,Fs);                                      %Speaker
pause(length(error_signal)/Fs);

filename = 'rlsoutput_code.wav';                                  %file name
audiowrite(filename,filtered_signal,Fs);                                    %Save the audio in local file

% THE END