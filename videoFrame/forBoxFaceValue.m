%locate box on face and get RGB value
allPath = 'RoughFace/';
allFlist = dir(allPath);
pointPath = 'point/';
savePath = 'BoxFaceValue/';

for i = 3:length(allFlist)
    person = allFlist(i).name;
    personPath = fullfile(allPath, person);
    personFlist = dir(personPath);
    
    BoxFaceRGB = zeros(40,3000,3);
    
    disp([num2str(i-2),' in ',num2str(length(allFlist) -2),' is ',person]);
    
    for j = 3:length(personFlist)
        
        trial = personFlist(j).name;
        trialPath = fullfile(personPath, trial);
        trialFlist = dir(trialPath);
        
        disp([num2str(j-2),' in ',num2str(length(personFlist) -2),' is ',trial]);
        
        for k = 3:length(trialFlist)
            
            frame = trialFlist(k).name;
            framePath = fullfile(trialPath,frame);
            [videoNo, frameNo] = nameToNumber(frame);
            im = imread(framePath);
            im = im2double(im);
            
            points = [frame(1:end-4),'.mat'];
            pointsPath = fullfile(pointPath,person,trial,points);
            pt = load(pointsPath);
            pt = pt.points;
            
            keyPoints = locateKeyPoints(pt);
            mask = roipoly(im,keyPoints(:,1),keyPoints(:,2));
            r1=im(:,:,1).*double(mask);
            g1=im(:,:,2).*double(mask);
            b1=im(:,:,3).*double(mask);
            framer = sum(sum(r1)) / sum(sum(mask));
            frameg = sum(sum(g1)) / sum(sum(mask));
            frameb = sum(sum(b1)) / sum(sum(mask));
            
            if isnan(framer)
                error([num2str(videoNo),' ', num2str(frameNo),' ','frame r is nan']);
            end
            
            BoxFaceRGB(videoNo,frameNo,:) = [framer,frameg,frameb];
            
        end
    end
    
    if exist(fullfile(savePath,person)) == 0
        mkdir(fullfile(savePath,person));
    end
    
    saveName = fullfile(savePath,person,'BoxFaceRGB.mat');
    save(saveName, 'BoxFaceRGB');
end
            
        
