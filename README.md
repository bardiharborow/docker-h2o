# docker-h2o ![](https://img.shields.io/docker/build/bardiharborow/h2o?style=flat-square) ![](https://img.shields.io/docker/pulls/bardiharborow/h2o?style=flat-square)
Dockerfile for H2O – an optimized HTTP/1, HTTP/2 server.

## Usage
```shell
$ docker run --name h2o \
             --read-only \
             --publish 80:80 --publish 443:443 \
             --mount type=tmpfs,destination=/tmp/,tmpfs-mode=1700 \
             --mount type=bind,source=/var/www/,destination=/var/www/,readonly \
             --mount type=bind,source=/etc/h2o.conf,destination=/etc/h2o.conf,readonly \
             bardiharborow/h2o
```

## License
Licensed under the [MIT License](https://github.com/bardiharborow/docker-h2o/blob/master/LICENSE). This software is provided on an "as is" basis, without warranties of any kind.
