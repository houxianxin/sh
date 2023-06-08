#!/bin/bash

# 使用apt安装基础包
export DEBIAN_FRONTEND=noninteractive && \
apt-get update && apt-get install -y --no-install-recommends zsh curl git autojump direnv vim openssh-server zip unzip wget openssl sudo tar lrzsz rsync gcc g++ make locales tzdata tmux openvpn && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* && \
    
# 初始化设置utf-8编码
locale-gen en_US.UTF-8 && \
update-locale LANG=en_US.UTF-8 && \

# 安装更新CA证书
wget http://archive.ubuntu.com/ubuntu/pool/main/c/ca-certificates/ca-certificates_20230311ubuntu1_all.deb && \
dpkg -i ./ca-certificates_20230311ubuntu1_all.deb && \
rm ./ca-certificates_20230311ubuntu1_all.deb && \

# 创建~/.myshrc
echo "" > ~/.myshrc

# 安装ohmyzsh及其插件
export GIT_SSL_NO_VERIFY=true && \
export ZSH_CUSTOM=~/.oh-my-zsh/custom && \
yes | sh -c "$(curl -fsSL -k https://ghproxy.com/https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
git clone https://ghproxy.com/https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions && \
git clone https://ghproxy.com/https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting && \
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="ys"/' ~/.zshrc && \
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc && \
sed -i "s/^typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'.*$/typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'/g" $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh && \
printf "source ~/.myshrc\n$(cat ~/.zshrc)" > ~/.zshrc && \
printf "source ~/.myshrc\n$(cat ~/.bashrc)" > ~/.bashrc && \

# 安装vim配色
git clone https://ghproxy.com/https://github.com/altercation/solarized.git --depth=1 && \
mkdir -p ~/.vim/colors && \
cp solarized/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/ && \
printf "syntax enable\nset background=dark\ncolorscheme solarized\nset number\n" >> ~/.vimrc && \
rm -rf ./solarized && \

# 设置默认shell
chsh -s /bin/zsh && \
zsh -c "source ~/.zshrc"
