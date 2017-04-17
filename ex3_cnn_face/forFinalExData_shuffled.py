import os
import os.path as osp
import sys
import numpy as np
from os import listdir
from os.path import isfile,join
import scipy.io as sio
import h5py

allFacePath = '/net/liuwenran/datasets/HCI/experiment/videoFrame/RoughFace'
allLabelPath = '/net/liuwenran/datasets/HCI/experiment/heartRate/GTHR_norm'
allFaceFlist = listdir(allFacePath)
allLabelFlist = listdir(allLabelPath)

faceIm = ['' for x in range(50000)]
label = np.zeros(50000)
count = 0
for i, sessionName in enumerate(allFaceFlist):

    print str(i+1) + ' in ' + str(len(allFaceFlist)) + ' session'
    
    sessionFacePath = join(allFacePath, sessionName)
    sessionFaceFlist = listdir(sessionFacePath)
    
    sessionLabelName = join(allLabelPath, sessionName, 'heartRate.mat')
    sessionLabel = h5py.File(sessionLabelName)
    sessionLabel = sessionLabel[sessionLabel.keys()[0]]
    sessionLabel = np.array(sessionLabel)
    
    pngcount = len(sessionFaceFlist)
    
    for k in range(len(sessionLabel)):
        if sessionLabel[k][0] > 0:
            stoppt = k * 61 + 61 * 8
            if stoppt <= pngcount :
                startpt = k * 61 + 1
            else:
                startpt = pngcount - 61 * 8 + 1

            frameName = sessionName+'/' + 'session' +\
                        '_'+ sessionName + '_' + str(startpt)+'.png'
                
            faceIm[count] = frameName
            label[count] = sessionLabel[k]
            count = count + 1


faceIm = faceIm[:count]
label = label[:count]
# label = np.floor(label*100)
num = len(label)
num

newperm = np.random.permutation(np.arange(num))
finalLabel = [label[i] for i in newperm]
finalIm = [faceIm[i] for i in newperm]

allfile = h5py.File('finalExData_shuffled/final.h5','w')
allfile.create_dataset('finalIm', data = finalIm)
allfile.create_dataset('finalLabel', data = finalLabel)
allfile.create_dataset('count',data = count)
allfile.close()


label = finalLabel[:30000]
faceIm = finalIm[:30000]
trainfile = h5py.File('finalExData_shuffled/train_float.h5','w')
trainfile.create_dataset('faceIm', data = faceIm)
trainfile.create_dataset('label', data = label)
trainfile.create_dataset('count',data = len(label))
trainfile.close()

label = finalLabel[30000:]
faceIm = finalIm[30000:]
testfile = h5py.File('finalExData_shuffled/test_float.h5','w')
testfile.create_dataset('faceIm', data = faceIm)
testfile.create_dataset('label', data = label)
testfile.create_dataset('count',data = len(label))
testfile.close()


