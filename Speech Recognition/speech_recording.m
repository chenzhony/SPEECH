% STEP-1: Recording audio signals for training and testing ASR %

% Declaring the required configuration parameters
recordings_location_orig     = "E:\TODO\UEA\AVP\cw\wip\speech_signals\demo\";
recordings_location_norm     = "E:\TODO\UEA\AVP\cw\wip\speech_signals\demo\";
file_name_prefix             = "DEMO_";
num_signals                  = 1;
sampling_freq                = 16000;
speech_sig_len               = 10;   % in seconds

for fileNumber = 1:num_signals
    % prompt speaker to say utterance and record the audio
    fs = sampling_freq;
    r = audiorecorder(fs,16,1);
    disp("Press any key to start recording signal-"+fileNumber);
    pause
    disp('Start speaking.');
    recordblocking(r, speech_sig_len);
    disp('End of Recording.');
    
    %Extracting the audio as doubles
    x = getaudiodata(r, 'double');
    
    %plotting the audio signal with time on x-axis
    t = (1/fs: 1/fs: length(x)/fs);
    figure(1)
    subplot(2,1,1)
    plot(t,x)
    title('audio signal with time on xaxis')
    xlabel('time in seconds')
    ylabel('amplitude')


    % normalise the audio signal
    xNorm = 0.99 * x / max(abs(x));
        
    %plotting the normalized audio signal with time on x-axis
    subplot(2,1,2)
    plot(t,xNorm)
    title('Normalized audio signal with time on xaxis')
    xlabel('time in seconds')
    ylabel('amplitude')
    
    % save the original audio to .wav file
    %file_name_orig = strcat(recordings_location_orig, file_name_prefix, '_SN', int2str(fileNumber), '.wav');
    %audiowrite(file_name_orig, x, 16000);
    
    % save normalized audio to .wav file
    file_name_norm = strcat(recordings_location_norm, file_name_prefix, 'S', int2str(fileNumber), '.wav');
    audiowrite(file_name_norm, xNorm, 16000);    
end
