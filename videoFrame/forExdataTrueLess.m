%make boxfacevalue to fc exdata
clear all;
faceValuePath = 'BoxFaceValue/';
hrPath = '/net/liuwenran/datasets/DEAP/experiment/ex1_fc_gt/GTHR_norm_sigPeak1024_2';
correspondMatPath = '/net/liuwenran/datasets/DEAP/correspond.mat';
correspondMat = load(correspondMatPath);
correspondMat = correspondMat.correspond;

faceValueFlist = dir(faceValuePath);

exdataR = zeros(22*40*53,400);
exdataG = zeros(22*40*53,400);
exdataB = zeros(22*40*53,400);
exdataHR = zeros(22*40*53,1);
count = 0;
for i = 3:length(faceValueFlist)
	disp([num2str(i-2),' in ',num2str(length(faceValueFlist) - 2)]);
	personName = faceValueFlist(i).name;
	hrName = fullfile(hrPath,[personName,'_norm.mat']);
	faceValueName = fullfile(faceValuePath,personName,'BoxFaceRGB.mat');
	faceValue = load(faceValueName);
	faceValue = faceValue.BoxFaceRGB;
	hr = load(hrName);
	hr = hr.heartRate;

	personCorInd = find(correspondMat(:,1) == (i-2));
	personCor = correspondMat(personCorInd,:);

	faceValueSize = size(faceValue);
	for j = 1:faceValueSize(1)
		if sum(faceValue(j,:)) == 0
			disp([num2str(i-2),' trial ',num2str(j),' is zero']);
			continue;
		end
		trialCorInd = find(personCor(:,2) == j);
		trialCor = personCor(trialCorInd,3);
		for k = 1:53
			if hr(trialCor,k) > 0
				count = count + 1;
				startpt = (k - 1) * 50 + 1;
				stoppt = (k - 1 + 8) * 50;
				exdataR(count,:) = faceValue(j, startpt:stoppt, 1);
				exdataG(count,:) = faceValue(j, startpt:stoppt, 2);
				exdataB(count,:) = faceValue(j, startpt:stoppt, 3);
				exdataHR(count) = hr(trialCor,k);
			end
		end
	end
end

exdataR = exdataR(1:count,:);
exdataG = exdataG(1:count,:);
exdataB = exdataB(1:count,:);
exdataHR = exdataHR(1:count);

count
save('exdataTrueLess/exdataR.mat','exdataR');
save('exdataTrueLess/exdataG.mat','exdataG');
save('exdataTrueLess/exdataB.mat','exdataB');
save('exdataTrueLess/exdataHR.mat','exdataHR');
