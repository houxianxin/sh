#!/bin/bash

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
rm /tmp/tools.zip && \

# 安装homebrew
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \

# 写入环境变量到.myshrc
echo '
export MY_ROOT_HOME=/
export ZSH_HOME=~/.oh-my-zsh
export CONDA_HOME=~/miniconda3
export JAVA_HOME=~/.sdkman/candidates/java/current
export ANDROID_HOME=~/android-sdk
export PATH=\$PATH:\$JAVA_HOME/bin
export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=\$PATH:\$ANDROID_HOME/emulator
export PATH=\$PATH:\$ANDROID_HOME/tools
export PATH=\$PATH:\$ANDROID_HOME/tools/bin
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
export PATH=\$PATH:\$CONDA_HOME/bin
' >> ~/.myshrc && \

zsh -c "source ~/.zshrc"
