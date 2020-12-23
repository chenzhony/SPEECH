% generate batch mfc file and read batch speech file

% firstName = 'speechfile/SPEECH20_S';
% firstName2 = '.wav';
% secName = 'MFCC/SPEECH20_S';
% secName2 = '.mfc';
% 
% for k = 11:20
%     speechFileName = [firstName, num2str(k), firstName2];
%     mfcspeechFileName = [secName, num2str(k), secName2];
    [x, fs] = audioread(speechFileName);           % reading a audio signal using MATLAB
    %figure(1);
    %subplot(5,1,1);
    %plot(x)
    preEmphasis = [1 -0.97];                 % pre-emphasis filtered signal
    preEmphasisSignal = filter(preEmphasis, 1, x);
    %subplot(5,1,2);
    %plot(preEmphasisSignal)
    %sound(preEmphasisSignal, fs)

    startPos=1;                              % keep start position for per frame
    numChannel = 30;                         % the number of data per vector
    signalSize = length(preEmphasisSignal);  % size of signal
    hammingSize = length(hamming(320));      % size of hamming window
    numberVec = fix(length(x) / 160) -1;     % number of vector
  
    % MFCC file head information
    mfcfile = fopen( mfcspeechFileName, 'w', 'ieee-be' );       % mfcspeechFileName is .mfc file 'w' and 'ieee-be' is the writing type
        fwrite( mfcfile, numberVec, 'int32' );          
        fwrite( mfcfile, 40000, 'int32' );              % 100 ns unit, 40000 sample 4ms per frame 4000us 4000000ns/100 = 40000
        fwrite( mfcfile, 120, 'int16' );                % the number of data per frame 30, 4 byte per data
        fwrite( mfcfile, 9, 'int16' );                  % 9 is USER 6 is MFCC more detail in HTK book

    while (startPos + hammingSize <= signalSize)                                        
        hammingSignal = preEmphasisSignal(startPos : startPos + hammingSize - 1) .* w;      % applying hamming window
        frequencySignal = fft(hammingSignal);                                               % fft to the hamming signal
        shortTimeMag = abs(frequencySignal(1 : hammingSize / 2));                           % magnitude spectra of the first half
        %subplot(5,1,3);
        %plot(shortTimeMag)
        
        fbank = linearRectangularFilterbank(shortTimeMag, numChannel);                      % applying linear filterbank
        %subplot(5,1,4);
        %plot(fbank)

        logSignal = log((fbank));                                               % log of the magnitude of filterbank output
        dctSignal = dct(logSignal);                                             % applying DCT
        %disp(dctSignal)    ##display DCT signal to help understand                                                    
        %subplot(5,1,5) 
        %plot(dctSignal)
        
        startPos = startPos + hammingSize/2;                                    % next window

        % write MFCC file, DCT Signal is dataset, no index
        for j = 1:numChannel
            fwrite(mfcfile, dctSignal(j), 'float32');                           
        end
    end    
%end
% function for generating rectangular filter bank
function fbank = linearRectangularFilterbank(magSpec, numChannel)

        numSample = floor(length(magSpec) / numChannel);             
        startChannelPos = 1;
        
        for numFbank = 1:numChannel
            fbank(numFbank) = sum(magSpec(startChannelPos : startChannelPos + numSample - 1));
            startChannelPos = startChannelPos + numSample;
        end
end
