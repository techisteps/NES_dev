# NES Dev

This is a simple development environment for NES development and testing.

> The environment is based on [devcontainers](https://containers.dev/) and uses [docker](https://docker.com/) to run the development environment.

Before you start, create a Docker Image from Dockerfile.

```
docker build -t nesbuild:latest .
```

Once you have created the Docker Image, you can start the development environment. Open VSCode from the project folder and run the command `Reopen in Container` or click on `Open a Remote Window` (*Green button on bottom left of VSCode*) and select `Reopen in Container` option.

> All commands and settings are stored in the `.devcontainer/devcontainer.json` file.
Refer ```.devcontainer/devcontainer.json``` for more information and Dockerfile for more information.

All commands for CC65 are available in the `/cc65/bin` directory.

```
/workspaces/nes # ls -lrt /cc65/bin/
total 2156
-rwxr-xr-x    1 root     root         53600 Sep 14 00:26 ar65
-rwxr-xr-x    1 root     root        381936 Sep 14 00:27 ca65
-rwxr-xr-x    1 root     root        713776 Sep 14 00:27 cc65
-rwxr-xr-x    1 root     root         39344 Sep 14 00:27 chrcvt65
-rwxr-xr-x    1 root     root         57680 Sep 14 00:27 co65
-rwxr-xr-x    1 root     root        101288 Sep 14 00:27 cl65
-rwxr-xr-x    1 root     root        257032 Sep 14 00:27 da65
-rwxr-xr-x    1 root     root         56632 Sep 14 00:27 grc65
-rwxr-xr-x    1 root     root        190616 Sep 14 00:27 ld65
-rwxr-xr-x    1 root     root         61584 Sep 14 00:27 od65
-rwxr-xr-x    1 root     root        179104 Sep 14 00:27 sim65
-rwxr-xr-x    1 root     root         89208 Sep 14 00:27 sp65
```

Check seup by checking version of commands installed

```bash
/workspaces/NES_dev # cc65 --version
cc65 V2.19 - Git 357f64e4e
/workspaces/NES_dev # ca65 --version
ca65 V2.19 - Git 357f64e4e
/workspaces/NES_dev # 
```