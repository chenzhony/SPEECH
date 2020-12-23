%{
    Function    : resampling
    Input       : audio signal file name, desired sampling frequency
    Output      : audio signal with desired frequency
    Description : This function reads the audio signal, checks if the
    signal has desired frequency, if not resample the signal
%}
function resampled_sig = resampling(file_name, desired_sampl_freq)
    [audio_sig, sig_fs] = audioread(file_name);
    %[thr,sorh,keepapp]=ddencmp( 'den', 'wv', audio_sig);
    %[audio_sig, cxc, lxc, perf0, perfl2]=wdencmp( 'gbl' ,audio_sig, 'db3' ,2,thr,sorh,keepapp);
    
    if sig_fs ~= desired_sampl_freq
        [p,q] = rat(desired_sampl_freq / sig_fs);

        % normalise the audio signal
        audio_sig_norm = 0.99 * audio_sig / max(abs(audio_sig));

        resampled_sig = resample(audio_sig_norm,p,q);
        fprintf("\tnormalized the signal and resampled from %d to %d samples\n", sig_fs, desired_sampl_freq)
    else
        resampled_sig = audio_sig;
        fprintf("\tresampling not required, received a signal with %d samples\n", desired_sampl_freq)
    end
end