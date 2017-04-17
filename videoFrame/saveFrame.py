#read avi and save every frame
import cv2
import os
from os import listdir
from os.path import isfile,join
import h5py

allSavePath = '/net/liuwenran/datasets/HCI/experiment/videoFrame/videoFrameData'
allVideoPath = '/net/liuwenran/datasets/HCI/allSessions/Sessions'
infoPath = '/net/liuwenran/datasets/HCI/experiment/videoFrame/cutnumbers.mat'

cutinfo = h5py.File(infoPath)
infokeys = cutinfo.keys()
sessionNo = cutinfo[infokeys[0]].value
FrameNo = cutinfo[infokeys[1]].value

sessionNo = sessionNo[425::]
FrameNo = FrameNo[425::]

for i in range(len(sessionNo)):
	nowSession = str(int(sessionNo[i][0]))
	sessionSavePath = join(allSavePath, str(nowSession))
	if not os.path.exists(sessionSavePath):
		os.makedirs(sessionSavePath)
	sessionVideoPath = join(allVideoPath, str(nowSession))

	sessionFlist = listdir(sessionVideoPath)
	for filename in sessionFlist:
		if cmp(filename[(len(filename)- 3)::], 'avi') == 0:
			nowVideo = filename
			break


	videoSavePath = join(sessionSavePath,nowVideo[0:len(nowVideo) - 4])
	videoPath = join(sessionVideoPath, nowVideo)
	capture = cv2.VideoCapture(videoPath)
	count = 0
	frameCount = int(FrameNo[i][0])
	print 'session ' + str(i) + ' in ' + str(len(sessionNo)) +' frameCount ' + str(frameCount)
	while(capture.isOpened()):
		flag, frame = capture.read()
		if flag:
			count = count + 1
			cv2.imwrite(videoSavePath + '_' + str(count) + '.png', frame)
			if count%100 == 0:
				print 'session ' + str(i)  + ' ' + str(count)
			if count == frameCount:
				break
		else:
			break

