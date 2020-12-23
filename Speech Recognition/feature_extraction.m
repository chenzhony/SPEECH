
% Declaring all the configuration parameters required
project_dir         = "E:\TODO\UEA\AVP\cw\wip";
code_dir            = strcat(project_dir,"\code");
speech_sig_dir      = strcat(project_dir,"\speech_signals");
speech_sig_dir_norm = strcat(speech_sig_dir,"\demo");
mfcc_dir            = strcat(project_dir,"\MFCCs\demo\");
desired_sampl_freq  = 16000;
show_graph          = 0;

% changing the matlab to the project directory
cd(code_dir);

% reading all files and generating feature vectors for each of them
all_files = dir(fullfile(speech_sig_dir_norm,"*.wav"));
for k = 1:length(all_files)
    base_file_name = all_files(k).name;
    full_file_name = fullfile(speech_sig_dir_norm, base_file_name);
    fprintf("\n\nProcessing %s:\n", base_file_name)

    % reading a audio signal and sampling the signal if required
    speech_sig = resampling(full_file_name, desired_sampl_freq);
    if show_graph == 1
        figure(1); subplot(2,1,1); plot(speech_sig); title("speech signal")
    end
    
    % applying pre-emphasis filter to the audio signal
    pre_emp_fil_sig = pre_emphasis_filter(speech_sig);
    if show_graph == 1
        figure(1); subplot(2,1,2); plot(pre_emp_fil_sig); title("pre-emphasized speech signal")
    end

    % splitting the audio signal into 20msec blocks
    % applying hamming window to the audio signal
    len_sig = length(pre_emp_fil_sig);
    len_sml_blck = 320;
    pos=1;

    numVectors = len_sig/(len_sml_blck/2)-1;	% number of channels for the signal
    vectorPeriod = 100000;                      % representing in 100ns units
    numDims = 30;
    parmKind = 9;                               % 6-MFCC and 9-USER
    
    % Opening file for writing
    file_nm = split(base_file_name, ".");
    fid = fopen(strcat(mfcc_dir,file_nm{1},'.mfc'), 'w', 'ieee-be');
    % Writing the header information
    fwrite(fid, numVectors, 'int32');   % number of vectors in file (4 byte int)
    fwrite(fid, vectorPeriod, 'int32'); % sample period in 100ns units (4 byte int)
    fwrite(fid, numDims * 4, 'int16');  % number of bytes per vector (2 byte int)
    fwrite(fid, parmKind, 'int16');     % code for the sample kind (2 byte int)
    
    
    while (pos+len_sml_blck <= len_sig)                                 % while enough signal left
        sml_blk = pre_emp_fil_sig(pos:pos+len_sml_blck-1);
        sig_with_hamming = hamming_window(sml_blk);                     % applying hamming window
        [shortTimeMag, shortTimePhase] = mag_phase(sig_with_hamming);
        fbank = filterbank(shortTimeMag, 30);                           % applying linear filterbank
        log_trnsfrmd_sgnl = log(fbank);                                 % log of the magnitude of filterbank output
        dct_signal = dct(log_trnsfrmd_sgnl);                            % applying DCT
        %dct_signal = energy_comp(dct_signal);                           % adding energy component
        
        %pause

        % writing the data to .mfc file, one coefficient at a time
        for i = 1:numDims
            fwrite(fid, dct_signal(i), 'float32');
        end

        pos = pos + len_sml_blck/2;                                     % next window


        if show_graph == 1
            figure(2); 
            t = pos:1:pos+len_sml_blck-1;
            subplot(2,3,1); plot(t,sml_blk); title("original 20 msec block");
            subplot(2,3,2); plot(t,sig_with_hamming); title("20 msec block after applying haming signal");
            subplot(2,3,3); plot(shortTimeMag); title("magnitude spectra of 20 msec block");
            subplot(2,3,4); plot(fbank); title("linear rectangular filterbank output of 20 msec block");
            subplot(2,3,5); plot(log_trnsfrmd_sgnl); title("log output of 20 msec block");
            subplot(2,3,6); plot(dct_signal); title("DCT output of 20 msec block");
            disp(dct_signal)
            
            %pause
        end

    end

    fclose(fid);
    fprintf("\tMFCC file generated successfully\n")
end
