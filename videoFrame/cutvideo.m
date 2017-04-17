rootPath = '/net/liuwenran/datasets/HCI/allSessions/Sessions';
flist = dir(rootPath);
sessionNo = [];
videoFrames = [];
errorNo = 0;
for i = 3:length(flist)
    disp([num2str(i-2),' in ',num2str(length(flist)-2)]);
    sessionName = flist(i).name;
    sessionPath = fullfile(rootPath,sessionName);
    onepieceFlist = dir(sessionPath);
    bdfname = [];
    flag = 0;
    for j = 3:length(onepieceFlist)
        tempname = onepieceFlist(j).name;
        if strcmp(tempname(end-2:end), 'bdf')
            bdfname = fullfile(sessionPath,tempname);
            flag = 1;
            break;
        end
    end
    if flag == 0
        errorNo = errorNo + 1;
        continue;
    end
    [data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf(bdfname,'all','n');
    status = data(47,:);
    statusdiff = diff(status);
    statusIndex = find(statusdiff > 0);
    duration = (statusIndex(2) - statusIndex(1)) / 256;
    watchTime = duration * 61;
    sessionNo = [sessionNo,str2num(sessionName)];
    videoFrames = [videoFrames, round(watchTime)];
end
disp(['errorNo is ',num2str(errorNo)]);
save('cutnumbers.mat','sessionNo','videoFrames');

    
    