downloadFolder = fullfile(tempdir,'YAMNetDownload');
loc = websave(downloadFolder,'https://ssd.mathworks.com/supportfiles/audio/yamnet.zip');
YAMNetLocation = tempdir;
unzip(loc,YAMNetLocation)
addpath(fullfile(YAMNetLocation,'yamnet'))
for e = 1:40
    disp(e);
    filename1 = ['/Users/chenzhongye/Downloads/Lukasz/test/',num2str(e),'.WAV'];
    filename2 = ['/Users/chenzhongye/Downloads/Lukasz/testLabel/',num2str(e),'.txt'];
    [audioIn,fs] = audioread(filename1);
    threshold = 0.75;
    minimumSoundSeparation = 0.3;
    minimumSoundDuration = 0.3;
    [sounds,timeStamps] = classifySound(audioIn,fs,'Threshold',threshold,'MinimumSoundSeparation',minimumSoundSeparation,'MinimumSoundDuration',minimumSoundDuration);
    [m,n] = size(timeStamps);
    disp(timeStamps);
    string1 = "Speech";
    string2 = ["Alex" "Amelia" "Anushka" "Chandupraveen" "Charlotte" "Ergun" "Georgiana" "Jake" "Jardel" "Joe" "Jordan" "Josephine" "Lukasz" "Matt" "Rob" "Shaun" "Thomas" "Tim" "Toby" "Will" "Alex" "Amelia" "Anushka" "Chandupraveen" "Charlotte" "Ergun" "Georgiana" "Jake" "Jardel" "Joe" "Jordan" "Josephine" "Lukasz" "Matt" "Rob" "Shaun" "Thomas" "Tim" "Toby" "Will"];
   
    
    t = (0:numel(audioIn)-1)/fs;
    plot(t,audioIn)
    xlabel('Time (s)')
    axis([t(1),t(end),-1,1])

    textHeight = 1.1;
    for idx = 1:numel(sounds)
        patch([timeStamps(idx,1),timeStamps(idx,1),timeStamps(idx,2),timeStamps(idx,2)], ...
            [-1,1,1,-1], ...
            [0.3010 0.7450 0.9330], ...
            'FaceAlpha',0.2);
        text(timeStamps(idx,1),textHeight+0.05*(-1)^idx,sounds(idx))
    end
    pause
    fid = fopen(filename2,'wt');
    for i=1:m  
        if i == 1 
            k=(vpa(timeStamps(i,1),4))*10000000; 
            fprintf(fid, '%d %d ',0,k);
            fprintf(fid, '%s ', "sil");
            fprintf(fid,'\n');
        else
            j=(vpa(timeStamps(i,1),4))*10000000; 
            fprintf(fid, '%d %d ',nextk,j);
            fprintf(fid, '%s ', "sil");
            fprintf(fid,'\n');
        end
        j=(vpa(timeStamps(i,1),4))*10000000; 
        k=(vpa(timeStamps(i,2),4))*10000000; 
        fprintf(fid, '%d %d ',j,k);
        fprintf(fid, '%s ', string2(e));
        fprintf(fid,'\n');
        nextk=k; 
    end
    fclose(fid);
end









% t = (0:numel(audioIn)-1)/fs;
% plot(t,audioIn)
% xlabel('Time (s)')
% axis([t(1),t(end),-1,1])
% 
% textHeight = 1.1;
% for idx = 1:numel(sounds)
%     patch([timeStamps(idx,1),timeStamps(idx,1),timeStamps(idx,2),timeStamps(idx,2)], ...
%         [-1,1,1,-1], ...
%         [0.3010 0.7450 0.9330], ...
%         'FaceAlpha',0.2);
%     text(timeStamps(idx,1),textHeight+0.05*(-1)^idx,sounds(idx))
% end
% 
% 
% %%
%     fid = fopen(filename2,'wt');
%     for i=1:m    
%         if string1 == sounds(i)
%             j=(vpa(timeStamps(i,1),4))*10000000; 
%             k=(vpa(timeStamps(i,2),4))*10000000; 
%             fprintf(fid, '%d %d ',j,k);
%             fprintf(fid, '%s ', string2(e));
%             fprintf(fid,'\n');
%         else
%             j=(vpa(timeStamps(i,1),4))*10000000; 
%             k=(vpa(timeStamps(i,2),4))*10000000; 
%             fprintf(fid, '%d %d ',j,k);
%             fprintf(fid, '%s ', "sil");
%             fprintf(fid,'\n');
%         end
%     end
%        
%     fclose(fid);