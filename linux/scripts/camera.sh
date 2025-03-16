#!/bin/bash

HOSTNAME=$(cat /etc/hostname)

echo "This machine is $HOSTNAME"

if [ $HOSTNAME == "surfacego" ];
then
	CAMERANAME='\\_SB_.PCI0.LNK1'
else
	CAMERANAME='\\_SB_.PCI0.I2C2.CAMF'
fi

echo "Camera is $CAMERANAME"

gst-launch-1.0 libcamerasrc camera-name=$CAMERANAME ! 
    video/x-raw,width=1280,height=720,framerate=30/1,format=NV12 
    ! videoconvert ! video/x-raw,format=YUY2 ! videoconvert ! 
    v4l2sink device=/dev/video42
