# bonsai-linux-docker-base

Recommended to install docker rootless -> see here (https://docs.docker.com/engine/security/rootless/)

To build image:

```
docker build --tag "bonsai-base" .
```

The docker image does not by default have access to the host system, meaning any paths must be specified relative to the container. When launching the bonsai-base container, it will always look for a `.bonsai` folder inside of the working directory. The default working directory is set to `/bonsai`. Thus, the container will launch inside of the `/bonsai` folder, which will contain a bonsai environment inside of the `.bonsai` folder. You can change the working directory of the application by specifying the `WORKDIR` environment variable like so:

```
docker run -e WORKDIR=/custom/path bonsai-base
```

By default, the docker container is ephemeral, meaning any changes to the bonsai environment will not persist after restarting. You can add a persistent volume to the container using 2 approaches:

1) create a dedicated docker volume that will contain persistent data. This volume is managed by docker and is isolated on the host OS.
   ```
   docker volume create name_of_persistent_volume
   docker run -v name_of_persistent_volume:/path/in/container bonsai-base
   ```
2) bind an existing host volume to the docker container. This volume is managed by the host OS but docker can make changes to this volume.
   ```
   docker run -v /path/in/host:/bonsai bonsai-base
   ```

Arguments appended to the docker run command will be passed onto the call to Bonsai.exe. Thus, if you wish to open a specific workflow for example, you would do:

```
docker run bonsai-base /path/in/container
```

Lets say you wanted to run bonsai with an existing workflow you created on the host OS. Perhaps you may even have a .bonsai environment created already. You would bind the folder containing the workflow on the host OS to a custom working directory and specify the working directory like so:

```
docker run -v /path/in/host:/custom-working-directory -e WORKDIR=/custom-working-directory bonsai-base /custom-working-directory/workflow.bonsai
```

To run with GUI editor, attach display to container like so:

```
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bonsai-base
```

To attach a device for example a video camera, do:

```
docker run --device=/dev/video0:/dev/video0 bonsai-base
```

The docker container may also errors regarding openGL/MESA, printing messages like: "MESA: error: Failed to query drm device." To fix this, you can also attach the dri device to the container like so:

```
docker run --device=/dev/dri:/dev/dri bonsai-vision
```

To zip files into a zip folder, do:

```
while IFS= read -r file; do zip -yur archive.zip "$file"; done < /path/to/install_manifest.txt
```

Full command:

```
docker run --rm --runtime=nvidia -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --device=/dev/video0:/dev/video0 --device=/dev/dri:/dev/dri -v /home/nicholas/movenet-example:/movenet-example -e WORKDIR=/movenet-example --gpus all bonsai-cuda
```