# bonsai-docker

This repo contains docker files for building containerized linux environments that support running [bonsai-rx](https://github.com/bonsai-rx).

## Getting Started

Some familiarity with [docker](https://www.docker.com/) is important. To run the docker containers, you must have at least [docker engine](https://docs.docker.com/engine/) installed. It is recommended to install docker in [rootless mode](https://docs.docker.com/engine/security/rootless/). Your docker engine must also be set up to run linux OS, as these docker containers are designed to run on linux. If you are new to docker, it is recommended to read the [get started page](https://docs.docker.com/get-started/docker-overview/).

You can run the docker images by pulling the images directly from docker hub using the following:


## Build

To build, you should run the following:

```
cd /path/to/bonsai-docker
docker build --tag mono-base mono-base
docker build --tag bonsai-base bonsai-base
```

The bonsai-base docker container is sufficient to run basic bonsai workflows and launch the editor. However, many bonsai packages require additional configuration. For example, packages that require OpenCV.Net, such as Bonsai.Vision, require additional [steps to install OpenCV on linux](https://github.com/orgs/bonsai-rx/discussions/1101). I have started to create new docker files that build upon the base image for specific configurations. One method to do this is to run the installation steps directly in the docker file. However, the approach I have opted for is to download the dll/binary files on the host and create a zipped archive using the install manifest file, which can then be easily copied into the docker contained and expanded into the appropriate locations. For this, run the following to create the archive in the appropriate folder and then build:

```
cd /path/to/bonsai-docker/bonsai-vision
while IFS= read -r file; do zip -yur archive.zip "$file"; done < /path/to/opencv/release/install_manifest.txt
docker build --tag bonsai-vision .
```

## Useful Notes

Below I have compiled a list of useful notes, commands, and examples.

### Changing Working Directory

By design, the docker image does not have access to the host system. However, when running the container, it is possible to pass paths from the host system to the container. The default working directory is set to `/bonsai`, but this can be changed by changing the `WORKDIR` environment variable using the following:

```
docker run -e WORKDIR=/path/in/container bonsai-base
```

### Persistent Volumes

When launching the bonsai-base container, the container will look for a bonsai environment located in the `.bonsai` folder. If no `.bonsai` folder is found in the working directory, the container will initialize a new bonsai environment inside of the `.bonsai` folder. Keep in mind that by default, the docker container is ephemeral, such that any changes to the bonsai environment will not persist after restarting. You can add a persistent volume to the container using 2 approaches:

1) Create a dedicated docker volume that will contain your persistent data. This volume is managed by docker and is isolated on the host OS. You will need to attach the volume to the container each time you run the docker command, otherwise docker will not see the changes.
   ```
   docker volume create name_of_persistent_volume
   docker run -v name_of_persistent_volume:/path/in/container bonsai-base
   ```

2) Bind an existing host volume to the docker container. This volume is managed by the host OS but docker can make changes to this volume. Again, you will need to attach the volume to the container each time you run the docker command, otherwise docker will not see the changes.
   ```
   docker run -v /path/in/host:/path/in/container bonsai-base
   ```

#### Example

Lets say you wanted to run bonsai with an existing workflow called `workflow.bonsai` and you have a `.bonsai` environment already created in the same folder on your system called `bonsai_workflow`. On your host system, it would look something like this:

```
bonsai_workflow/
├── .bonsai/
│   ├── Packages/
│   ├── Gallery/
│   └── Bonsai.exe
│   ...
└── workflow.bonsai
... 
```

You could bind the `bonsai_workflow` folder on the host OS to a custom working directory in the container and specify the working directory. This has the consequence of the docker container gaining access to the hosts `bonsai_workflow` directory, and by default will bootstrap bonsai using the `.bonsai` environment contained in the folder.

```
docker run -v /path/to/bonsai_workflow:/custom-working-directory -e WORKDIR=/custom-working-directory bonsai-base /custom-working-directory/workflow.bonsai
```

### Bonsai CLI

Arguments appended to the docker run command will be passed onto the call to the bonsai executable. For example, if you wanted to open a specific workflow at runtime, you could do:

```
docker run bonsai-base /path/in/container/workflow.bonsai
```

You may also want to run the workflow right away without displaying the editor. In that case, the command would look like:
```
docker run bonsai-base /path/in/container/workflow.bonsai --start --no-editor
```

### Bonsai GUI

It is possible to launch the bonsai editor in the docker container, but requires a few additional arguments. Basically, you need to make the X11 display server on your host OS accessible from within your docker container. It is possible to do this with the following commands:

```
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bonsai-base
```

### Sharing Devices

It is possible to attach devices that are connected to your host OS to your docker container. For example, if you wanted to attach a USB video camera to your container, you would do:

```
docker run --device=/dev/video0:/dev/video0 bonsai-base
```

### OpenGL

Sometimes, you may encounter errors regarding openGL/MESA running bonsai in the docker container. For example, you may see an error message like this: "MESA: error: Failed to query drm device." To fix this, you can also attach the dri device to the container like so:

```
docker run --device=/dev/dri:/dev/dri bonsai-vision
```

### Full Command Usage Running Tensorflow

```
docker run --rm --runtime=nvidia -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --device=/dev/video0:/dev/video0 --device=/dev/dri:/dev/dri -v /path/to/tensorflow-example:/tensorflow-example -e WORKDIR=/tensorflow-example --gpus all bonsai-tensorflow
```

## Instructions for macOS

It is possible to run bonsai on macOS using the bonsai-base docker image. Keep in mind, the only way to access the Bonsai editor is to attach it to an X11 server. This is possible using mac's X11 server [XQuartz](https://www.xquartz.org/). I found [this discussion](https://gist.github.com/cschiewek/246a244ba23da8b9f0e7b11a68bf3285) on getting docker and xquartz working on macOS to be useful. 

After installing docker as well as xquartz on your system, you should check that the X11 server is functioning properly. If you run `xclock` in the macOS terminal and a window appears, then it is working. After this, you need to make sure that XQuartz is running and that it is configured to allow X11 server connections from the docker container. To do this, launch xquartz and go to Settings > Security > Allow connections from network clients. In your terminal, run `xhost +`, and it will say something like `allowing connections from anywhere`. Finally, you can modify the docker run command using:

```
docker run --network host -e DISPLAY=host.docker.internal:0 bonsai-base
```