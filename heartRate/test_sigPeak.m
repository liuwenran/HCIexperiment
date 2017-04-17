sessionRootPath = '/net/liuwenran/datasets/HCI/allSessions/Sessions';
sessionFlist = dir(sessionRootPath);

pick = 300;
session = sessionFlist(pick).name;
sessionPath = fullfile(sessionRootPath, session);
fileflist = dir(sessionPath);
for i = 3:length(fileflist)
	if strcmp(fileflist(i).name(end-2:end),'bdf')
		bdfname = fileflist(i).name;
		break;
	end
end

bdfname = fullfile(sessionPath, bdfname);
[data,numChan,labels,txt,fs,gain,prefiltering,ChanDim] = eeg_read_bdf(bdfname,'all','n');
status = data(47,:);
statusdiff = diff(status);
statusIndex = find(statusdiff > 0);
sig = data(35,:);
sigtest = sig(statusIndex(1) + 1 : statusIndex(2) + 1);
locs = sigPeak(sigtest);
figure;
plot(sigtest);
hold on;
plot(locs,sigtest(locs),'ro');
% title(['person ',num2str(person - 2),' video ',num2str(video),...
       % ' monolen ',num2str(monolen),' cutlen ',num2str(cutlen)]);
set(gcf,'outerposition',get(0,'screensize'));


% newlocs = clearAdjcent(locs);
% figure;
% plot(sigtest);
% hold on;
% plot(newlocs,sigtest(newlocs),'ro');
% title(['person ',num2str(person - 2),' video ',num2str(video),...
%        ' monolen ',num2str(monolen),' cutlen ',num2str(cutlen)]);
% set(gcf,'outerposition',get(0,'screensize'));


% bestlocs = clearFar(newlocs);
% figure;
% plot(sigtest);
% hold on;
% plot(bestlocs,sigtest(bestlocs),'ro');
% title(['person ',num2str(person - 2),' video ',num2str(video),...
%        ' monolen ',num2str(monolen),' cutlen ',num2str(cutlen)]);
% set(gcf,'outerposition',get(0,'screensize'));

% greatlocs = bestMax(sigtest, bestlocs, 15);
% figure;
% plot(sigtest);
% hold on;
% plot(greatlocs,sigtest(greatlocs),'ro');
% title(['person ',num2str(person - 2),' video ',num2str(video),...
%        ' monolen ',num2str(monolen),' cutlen ',num2str(cutlen)]);
% set(gcf,'outerposition',get(0,'screensize'));


