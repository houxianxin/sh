# sh

```bash
apt-get update && apt-get install -y --no-install-recommends curl && \
apt-get clean && rm -rf /var/lib/apt/lists/* && \
yes | bash -c "$(curl -fsSL -k https://ghproxy.com/https://raw.githubusercontent.com/houxianxin/sh/main/sh_ubuntu_init.sh)"
```
