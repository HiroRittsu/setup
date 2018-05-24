#!/bin/sh

echo "rosjavaをインストールしますか?(y/n)"
read rosjava

echo "rosjava: "$rosjava
echo
echo "これで大丈夫ですか？(y/n)"
read ok

if [ $ok = 'y' ]; then

	#rospy&roscpp
	sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
	sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
	sudo apt-get update
	sudo apt-get install ros-kinetic-desktop-full
	sudo rosdep init
	rosdep update
	echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
	source ~/.bashrc
	sudo apt-get install python-rosinstall

	if [ $rosjava = 'y' ]; then

		#java
		sudo add-apt-repository ppa:webupd8team/java
		sudo apt-get update
		sudo apt-get -f install
		sudo apt-get install oracle-java8-installer

		#rosjava
		sudo apt-get install ros-kinetic-rosjava

	fi

	echo
	echo "finish"

fi

exit 1
