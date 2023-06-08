#!/bin/bash

# 使用apt安装基础包
export DEBIAN_FRONTEND=noninteractive && \
apt-get update && apt-get install -y --no-install-recommends zsh curl git autojump direnv vim openssh-server zip unzip wget openssl sudo tar lrzsz rsync gcc g++ make locales tzdata tmux openvpn && \
apt-get clean && rm -rf /var/lib/apt/lists/* && \
    
# 初始化设置utf-8编码
locale-gen en_US.UTF-8 && \
update-locale LANG=en_US.UTF-8 && \

# 安装更新CA证书
wget http://archive.ubuntu.com/ubuntu/pool/main/c/ca-certificates/ca-certificates_20230311ubuntu1_all.deb && \
dpkg -i ./ca-certificates_20230311ubuntu1_all.deb && \
rm ./ca-certificates_20230311ubuntu1_all.deb && \

# 创建~/.myshrc
echo '. /usr/share/autojump/autojump.sh' >> ~/.myshrc && \

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

# 安装miniconda
export SHELL=/usr/bin/zsh && \
wget --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
chmod +x ~/miniconda.sh && \
yes | ~/miniconda.sh -b -p $HOME/miniconda && \
rm ~/miniconda.sh && \

# 安装nvm
export GIT_SSL_NO_VERIFY=true && \
wget --no-check-certificate -qO- https://ghproxy.com/https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.myshrc && \
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.myshrc && \
echo '
# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
local nvmrc_path
nvmrc_path="$(nvm_find_nvmrc)"

if [ -n "$nvmrc_path" ]; then
local nvmrc_node_version
nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

if [ "$nvmrc_node_version" = "N/A" ]; then
nvm install
elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
nvm use
fi
elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
echo "Reverting to nvm default version"
nvm use default
fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc' >> ~/.zshrc && \

# 安装sdkman
wget -O- "https://get.sdkman.io" | bash && \
source "$HOME/.sdkman/bin/sdkman-init.sh" && \

# 安装gvm
bash < <(curl -s -S -L https://ghproxy.com/https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer) && \
zsh -c "source /root/.gvm/scripts/gvm" && \

# 安装android command line tools
export ANDROID_HOME=~/android-sdk && \
mkdir -p ${ANDROID_HOME}/cmdline-tools && \
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/tools.zip && \
unzip /tmp/tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \

# 安装homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \

# 设置默认shell
chsh -s /bin/zsh && \
zsh -c "source ~/.zshrc"
