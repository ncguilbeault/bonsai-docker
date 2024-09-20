FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 as cuda-stage

FROM bonsai-vision

COPY --from=cuda-stage / /

COPY archive.zip /archive.zip
WORKDIR /
RUN unzip /archive.zip
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/libtensorflow.conf
RUN echo "/usr/local/cuda-11.8/lib64" > /etc/ld.so.conf.d/libcuda.conf
ENV PATH=${PATH}:/usr/local/cuda-11.8/bin
RUN ldconfig

ENTRYPOINT ["initialize_bonsai_environment.sh"]
CMD []