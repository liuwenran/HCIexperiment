%check if every box has its face
RoughFacePath = 'RoughFace/';
faceFlist = dir(RoughFacePath);
savePath = 'checkface_1000/';


for i = 3:length(faceFlist)
	sessionName = faceFlist(i).name;
	sessionPath = [RoughFacePath,sessionName];
	sessionFlist = dir(sessionPath);
	imname = sessionFlist(1000).name;
	copyfile(fullfile(sessionPath,imname),fullfile(savePath,imname));
end

		