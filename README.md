This is a [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) client docker image, with [simple-obfs](https://github.com/shadowsocks/simple-obfs) support.

### Usage

#### Build

```bash
cd docker-shadowsocks-client
sh build.sh
```

#### Connect to a simple-obfs shadowsocks server

```bash
sudo docker run --name shadowsocks-client \
    --restart=always \
    -d \
    -p 127.0.0.1:1080:1080 \
    -e SERVER_ADDR=server \
    -e SERVER_PORT=443 \
    -e METHOD=aes-256-gcm \
    -e PASSWORD=yourpassword \
    -e OBFS_ARG="obfs=http;obfs-host=www.bing.com" \
    shadowsocks-client
```

#### Connect to a common shadowsocks server

```bash
sudo docker run --name shadowsocks-client \
    --restart=always \
    -d \
    -p 127.0.0.1:1080:1080 \
    -e SERVER_ADDR=server \
    -e SERVER_PORT=443 \
    -e METHOD=aes-256-gcm \
    -e PASSWORD=yourpassword \
    shadowsocks-client
```
