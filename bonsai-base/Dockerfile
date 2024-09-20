FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget gnupg apt-transport-https software-properties-common ca-certificates

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update && apt-get install -y mono-devel

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update && apt-get install -y dotnet-sdk-8.0
RUN rm packages-microsoft-prod.deb

RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/ncguilbeault/bonsai-linux-environment-template

RUN dotnet new --install ./bonsai-linux-environment-template/Bonsai.LinuxEnvironmentTemplate
RUN apt-get update && apt-get install -y unzip libxml2-utils xmlstarlet
RUN dotnet new bonsaienvl --allow-scripts yes

COPY initialize_bonsai_environment.sh /usr/local/bin/initialize_bonsai_environment.sh
RUN chmod +x /usr/local/bin/initialize_bonsai_environment.sh

ENTRYPOINT ["initialize_bonsai_environment.sh"]
CMD []
# ENTRYPOINT ["tail", "-f", "/dev/null"]