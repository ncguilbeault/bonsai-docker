FROM bonsai-base 

RUN apt-get update && apt-get install -y libcanberra-gtk-module v4l-utils libv4l-dev
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" 
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 
RUN apt-key export C0B21F32 | gpg --dearmour -o /etc/apt/trusted.gpg.d/libjasper.gpg
RUN apt-get update && apt-get install -y build-essential curl cmake libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-dev

COPY archive.zip /archive.zip
WORKDIR /
RUN unzip /archive.zip
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/libopencv.conf
RUN ldconfig
RUN rm /archive.zip

RUN apt-get update && apt-get install -y libgl1-mesa-dev libosmesa6-dev mesa-utils
RUN apt-get update && apt-get install -y libsdl2-dev

ENTRYPOINT ["initialize_bonsai_environment.sh"]
CMD []