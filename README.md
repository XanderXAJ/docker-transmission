# ![](/transmission-qt.svg) Transmission

A simple Transmission Docker image. It assumes you already have your own config or want to start with the defaults.

[transmission]: https://transmissionbt.com

## Usage

Inside the container, downloads and configuration are written to `/var/lib/transmission`. You'll likely want to turn this entire directory in to a bind mount or volume.

### Using a bind mount to the host

This option makes the files easy to access, but requires a little extra thought when setting up. Despite that, this is likely the option you want.

When using a bind mount, the Transmission process inside the container will need to have write permission to the location you specify. To achieve this, choose a storage location for your files and then the UID and GID of a user and group that can write to that location. Substitute the storage location, UID and GID in to this command:

```sh
docker run --detach --restart unless-stopped --userns host --user $UID:$GID --volume $STORAGE_LOCATION:/var/lib/transmission xanderxaj/transmission
```

By using `--user`, the container never has to run as `root`.

The equivalent can be done in Docker Compose (while substituting the same values):

```yaml
version: '3.7'
services:
  transmission:
    image: xanderxaj/transmission
    restart: unless-stopped
    user: $GID:$UID
    userns_mode: host
    volumes:
      - $STORAGE_LOCATION:/var/lib/transmission
```

### Using a volume

This is simpler to set up, since you don't need to worry about permissions, but the files will require some more effort to access. Only use this if you're familiar with how to handle volumes.

By default, the container will run as a non-root user.

```sh
docker run --detach --restart unless-stopped --volume transmission:/var/lib/transmission xanderxaj/transmission
```

## Issues

Please report issues by [raising a GitHub issue][github-issues].

[github-issues]: https://github.com/XanderXAJ/docker-transmission/issues

