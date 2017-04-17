sessionRootPath = '/net/liuwenran/datasets/HCI/allSessions/Sessions';
sessionFlist = dir(sessionRootPath);

siglen = 256 * 8;
step = 256;
maxnum = 308;
minnum = 108;
for i = 3:length(sessionFlist)
    disp([num2str(i-2),' in ',num2str(length(sessionFlist)-2)]);
    
	session = sessionFlist(i).name;
	sessionPath = fullfile(sessionRootPath, session);
	fileflist = dir(sessionPath);
    
    flag = 0;
	for j = 3:length(fileflist)
		if strcmp(fileflist(j).name(end-2:end),'bdf')
			bdfname = fileflist(j).name;
            flag = 1;
			break;
		end
    end
    
    if flag == 0
        continue;
    end


	bdfname = fullfile(sessionPath, bdfname);
	[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf(bdfname,'all','n');
	status = data(47,:);
	statusdiff = diff(status);
	statusIndex = find(statusdiff > 0);
	sig = data(35,:);
	sigtest = sig(statusIndex(1) + 1 : statusIndex(2) + 1);

	locs = sigPeak(sigtest);

	startpt = 1;
	stoppt = siglen;
	heartRate = [];
	while stoppt < length(sigtest)
		snip = [];
        for m = 1:length(locs)
            if locs(m) >= startpt && locs(m) <= stoppt
                snip = [snip,locs(m)];
            end
            if locs(m) > stoppt
                break;
            end
        end
            
        locsdiff = diff(snip);
        overidx = find(locsdiff>maxnum);
        locsdiff(overidx) = [];
        belowidx = find(locsdiff<minnum);
        locsdiff(belowidx) = [];

        if isempty(locsdiff)
            diffmean = 0;
        else
            diffmean = mean(locsdiff);
        end

        %normalization 
		if (diffmean < minnum) || (diffmean >= maxnum)
                diffmean = 0;
        end
        diffmean =  (diffmean - minnum) / (maxnum -minnum);
        heartRate = [heartRate,diffmean];

        startpt = startpt + step;
        stoppt = stoppt + step;
    end
	if exist(fullfile('GTHR_norm',session)) == 0
    	mkdir(fullfile('GTHR_norm',session));
    end

    heartRateFile = fullfile('GTHR_norm',session,'heartRate.mat');
    save(heartRateFile, 'heartRate');
end
