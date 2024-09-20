FROM mono-base

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