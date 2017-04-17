function [ output_args ] = sigPeak( signal )
%SIGPEAK Summary of this function goes here
%   Detailed explanation goes here
siglen = length(signal);
sigdiffabs = abs(diff(signal));
diffmax = max(sigdiffabs);
lowIndex = find(sigdiffabs < (diffmax / 2) );
newdiff = sigdiffabs;
newdiff(lowIndex) = 0;

peaklocs = [];
distance = 40;
i = 1;
while i < length(newdiff)
    if newdiff(i) > 0 
        lflag = i;
        rflag = i;
        for j = 1:distance
            if (i + j) <= length(newdiff)
                if newdiff(i + j) > 0
                    rflag = i + j;
                end
            end
        end
        newpeaklocs = round((lflag + rflag) /2);
        peaklocs = [peaklocs, newpeaklocs];
        i = i + distance;
    end
    i = i + 1;
end

locs = [];
strechlen = 8;
for i = 1: length(peaklocs)
    nowarch = peaklocs(i);
    if nowarch > strechlen
        cutl = nowarch - 8;
    else
        cutl = 1;
    end
    if nowarch < siglen - 8
        cutr = nowarch + 8;
    else
        cutr = siglen;
    end
    
    [y, cutmaxlocs] = max(signal(cutl:cutr));
    locs = [locs,cutl - 1 + cutmaxlocs];
end

output_args = locs;

