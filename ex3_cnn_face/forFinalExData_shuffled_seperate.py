import os
import os.path as osp
import sys
import numpy as np
from os import listdir
from os.path import isfile,join
import scipy.io as sio
import h5py
import xml.dom.minidom as xdm

allFacePath = '/net/liuwenran/datasets/HCI/experiment/videoFrame/RoughFace'
allLabelPath = '/net/liuwenran/datasets/HCI/experiment/heartRate/GTHR_norm'
allXmlPath = '/net/liuwenran/datasets/HCI/allSessions/Sessions'

allFaceFlist = listdir(allFacePath)
allLabelFlist = listdir(allLabelPath)

faceIm = ['' for x in range(50000)]
label = np.zeros(50000)
subject = np.zeros(50000)
count = 0
for i, sessionName in enumerate(allFaceFlist):

    print str(i+1) + ' in ' + str(len(allFaceFlist)) + ' session'
    
    sessionFacePath = join(allFacePath, sessionName)
    sessionFaceFlist = listdir(sessionFacePath)
    
    sessionLabelName = join(allLabelPath, sessionName, 'heartRate.mat')
    sessionLabel = h5py.File(sessionLabelName)
    sessionLabel = sessionLabel[sessionLabel.keys()[0]]
    sessionLabel = np.array(sessionLabel)
    
    sessionXMLPath = join(allXmlPath, sessionName, 'session.xml')
    sessionXML = xdm.parse(sessionXMLPath)
    root = sessionXML.documentElement
    itemlist = root.getElementsByTagName('subject')
    item = itemlist[0]
    subid = item.getAttribute("id")
    subid = int(subid)

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
            subject[count] =  subid
            count = count + 1


faceIm = faceIm[:count]
label = label[:count]
subject = subject[:count]
# label = np.floor(label*100)
num = len(label)
num

sortarg = np.argsort(subject)
faceImnew = ['' for x in range(num)]
labelnew = np.zeros(num)
subjectnew = np.zeros(num)
for i in range(num):
    faceImnew[i] = faceIm[sortarg[i]]
    labelnew[i] = label[sortarg[i]]
    subjectnew[i] = subject[sortarg[i]]

# newperm = np.random.permutation(np.arange(num))
# finalLabel = [label[i] for i in newperm]
# finalIm = [faceIm[i] for i in newperm]
finalLabel = labelnew
finalIm = faceImnew
allfile = h5py.File('finalExData_shuffled/final_seperate.h5','w')
allfile.create_dataset('finalIm', data = finalIm)
allfile.create_dataset('finalLabel', data = finalLabel)
allfile.create_dataset('count',data = count)
allfile.close()

tempbegin = 30000
trainSize  = 30000
for i in range(tempbegin, count):
    if subjectnew[i] != subjectnew[i-1]:
        trainSize = i
        break
print 'trainSize is ' + str(trainSize) + ' personLast is ' + \
       str(subjectnew[trainSize - 1]) + ' personNOTtrain is ' + \
       str(subjectnew[trainSize])
       
newperm = np.random.permutation(np.arange(trainSize))
label = [labelnew[i] for i in newperm]
faceIm = [faceImnew[i] for i in newperm]


trainfile = h5py.File('finalExData_shuffled/train_float_seperate.h5','w')
trainfile.create_dataset('faceIm', data = faceIm)
trainfile.create_dataset('label', data = label)
trainfile.create_dataset('count',data = len(label))
trainfile.close()

label = finalLabel[trainSize:]
faceIm = finalIm[trainSize:]
testfile = h5py.File('finalExData_shuffled/test_float_seperate.h5','w')
testfile.create_dataset('faceIm', data = faceIm)
testfile.create_dataset('label', data = label)
testfile.create_dataset('count',data = len(label))
testfile.close()


