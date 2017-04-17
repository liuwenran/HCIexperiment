%save rough face to roughFace
clear all;
allFrameDir = 'videoFrameData/';
allFrameFlist = dir(allFrameDir);

addpath('mex_functions/');
addpath('models/');

% % Load Models
fitting_model='models/Chehra_f1.0.mat';
load(fitting_model);   

faceDetector = vision.CascadeObjectDetector();



flagPath = 'RoughFaceFlag/';
facePath = 'RoughFace/';
pointPath = 'point/';

sessionNum = length(allFrameFlist);

for i = 3:sessionNum
    session = allFrameFlist(i).name;
    sessionFrameDir = [allFrameDir,session];
    sessionFrameFlist = dir(sessionFrameDir);
    
    beframe = zeros(1,length(sessionFrameFlist) - 2);
	nobox = zeros(1,length(sessionFrameFlist) - 2);
	trialBox = zeros(1,4);

    disp([num2str(i-2),' in ',num2str(sessionNum -2),' is ',session]);
    for j = 3:length(sessionFrameFlist)
       
        frameName = sessionFrameFlist(j).name;
        frameDir = fullfile(sessionFrameDir,frameName);
        
        if mod(j-2,100) == 0
            disp([num2str(j-2),' in ',num2str(length(sessionFrameFlist) -2),' is ',frameName]);
        end
        
        if frameName(end-2:end) ~= 'png'
            continue;
        end
        frameNo = nameToNumber(frameName);
        beframe(frameNo) = 1;
        im = imread(frameDir);
 		test_image=im2double(im);
        
%         if videoNo == 8
%             stop = 0;
%         end

 		if (sum(trialBox(1,:)) == 0)
%             shift = 10;
%             im_new = imread(fullfile(personFrameDir, personFrameFlist(j+shift).name));
%             test_image_new = im2double(im_new);
    		bbox = step(faceDetector, test_image);
            if ~isempty(bbox)
                boxsize = bbox(3) * bbox(4);
            end
    		if isempty(bbox) || numel(bbox) ~= 4 || boxsize < 20000
    			nobox(1,frameNo) = 1;
    			beginF = 1;
                while (isempty(bbox))||(numel(bbox)~=4 || boxsize < 20000)
                	tframeName = sessionFrameFlist(j+beginF).name;
                	tframeDir = fullfile(sessionFrameDir, tframeName);
                	tim = imread(tframeDir);
                	ttest_image = im2double(tim); 
                	bbox = step(faceDetector, ttest_image);
                    if ~isempty(bbox)
                        boxsize = bbox(3) * bbox(4);
                    end
                	beginF = beginF + 1;
                	if beginF == 1000
                        % bbox = trialBox(videoNo - 1,:);
                        bbox = tempbox;
                		error('you dare believe that there is no valid bbox in 1000 frame!!');
                	end
                end
            end
            trialBox(1,:) = bbox;
        else
        	bbox = trialBox(1,:);
            tempbox = trialBox;
        end
    	faceim = test_image(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3),:);

    	if exist(fullfile(facePath,session)) == 0
    		mkdir(fullfile(facePath,session));
        end
        
        roughfaceName = ['session','_',session, '_', num2str(frameNo),'.png'];
        faceimPath = fullfile(facePath,session, roughfaceName);
    	imwrite(faceim, faceimPath,'png');

    	test_init_shape = InitShape(bbox,refShape);
    	test_init_shape = reshape(test_init_shape,49,2);    
    	if size(test_image,3) == 3
        	test_input_image = im2double(rgb2gray(test_image));
    	else
        	test_input_image = im2double((test_image));
    	end
       
    	% % Maximum Number of Iterations 
    	% % 3 < MaxIter < 7
    	MaxIter=6;
    	points = Fitting(test_input_image,test_init_shape,RegMat,MaxIter);
        
        if exist(fullfile(pointPath,session)) == 0
    		mkdir(fullfile(pointPath,session));
        end
        points(:,1) = points(:,1) - bbox(1);
        points(:,2) = points(:,2) - bbox(2);
        pointsName = fullfile(pointPath,session,frameName);
    	pointsName = [pointsName(1:end-4),'.mat'];
    	save(pointsName, 'points');
    end
    if exist(fullfile(flagPath,session)) == 0
    	mkdir(fullfile(flagPath,session));
    end
    beframeName = [fullfile(flagPath,session),'/beframe.mat'];
    save(beframeName, 'beframe');
    noboxName = [fullfile(flagPath,session),'/nobox.mat'];
    save(noboxName, 'nobox');
    trialBoxName = [fullfile(flagPath,session),'/trialBox.mat'];
    save(trialBoxName, 'trialBox');
    rmdir(sessionFrameDir,'s');
end
