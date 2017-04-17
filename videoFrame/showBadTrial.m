%locate box on face and get RGB value
allPath = 'RoughFaceFlag/';
allFlist = dir(allPath);
savePath = 'BoxFaceValue/';

for i = 3:length(allFlist)
    person = allFlist(i).name;
    personPath = fullfile(allPath, person);
    
    flagPath = fullfile(personPath,'beframe.mat');
    flag = load(flagPath);
    flag = flag.beframe;
    
    flagSize = size(flag);
    
    for m = 1:flagSize(1)
        rowSum = sum(flag(m,:));
        if rowSum == 3000
            continue;
        elseif rowSum > 0 && rowSum < 3000
            disp([person,' trial',num2str(m),' frameNum = ',num2str(rowSum)]);
        elseif rowSum == 0
            disp([person,' trial',num2str(m),' frameNum = ',num2str(rowSum)]);
        end
    end  
end
            
        
