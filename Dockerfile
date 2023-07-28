FROM alpine:latest

# 安装 zsh、oh-my-zsh 以及插件
RUN export ZSH_CUSTOM=~/.oh-my-zsh/custom \
	&& apk add --no-cache zsh curl git \
    && sh -c "$(curl -fsSL https://ghproxy.com/https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone https://ghproxy.com/https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://ghproxy.com/https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc \
	&& sed -i "s/^typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'.*$/typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'/g" $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
    && rm -rf /var/cache/apk/*

# 设置默认 shell 为 zsh
CMD ["zsh"]
