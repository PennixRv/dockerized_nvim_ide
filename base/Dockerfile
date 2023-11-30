FROM fedora:latest

ARG APP_UID=1000
ARG APP_GID=1000
ARG APP_USER=pennix
ARG APP_GROUP=pennix
ARG APP_HOME=/home/pennix

RUN groupadd -g ${APP_GID} ${APP_GROUP}
RUN useradd -d ${APP_HOME}/${APP_USER} --uid ${APP_UID} --gid ${APP_GID} ${APP_USER}
RUN echo "${APP_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -aG root ${APP_USER}

WORKDIR ${APP_HOME}/${APP_USER}
RUN chown -R ${APP_UID}:${APP_GID} ${APP_HOME}/${APP_USER}
USER ${APP_USER}

RUN sudo dnf update -y && \
    sudo dnf install git rust cargo gcc gcc-c++ autoconf automake           \
        cmake golang llvm clang-tools-extra clang bear nodejs lua           \
        ruby ruby-devel zsh neovim shadow-utils openssl fzf pip wget        \
        luarocks composer php java-devel java-openjdk-headless java-openjdk \
        julia tmux -y

RUN pip install pynvim && gem install neovim && npm install neovim && \
    go install github.com/jesseduffield/lazygit@latest && \
    go install github.com/dundee/gdu/v5/cmd/gdu@latest

RUN cargo install tree-sitter-cli bat bottom du-dust fd-find lsd broot ripgrep sd

RUN git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim && \
    git clone https://github.com/PennixRv/astronvim_config.git ~/.config/nvim/lua/user

RUN nvim --headless "+Lazy! sync" +"sleep 15" +AstroUpdatePackages +qa

RUN for n in "asm_lsp" \
  "bashls" \
  "clangd" \
  "cmake" \
  "neocmake" \
  "autotools-language-server" \
  "denols" \
  "dockerls" \
  "docker_compose_language_service" \
  "clangd" \
  "gopls" \
  "jsonls" \
  "java_language_server" \
  "julials" \
  "lua_ls" \
  "swift_mesonls" \
  "pyright" \
  "ruby_ls" \
  "rust_analyzer" \
  "yamlls" \
  "yamlls"; \
  do nvim --headless -c "LspInstall --sync ${n}" -c 'q'; done

RUN for n in "bash-debug-adapter" \
  "codelldb" \
  "debugpy" \
  "cpptools"; \
  do nvim --headless -c "MasonInstall ${n}" -c 'q'; done

RUN for n in \
  "dockerfile" \
  "go" \
  "java" \
  "javascript" \
  "json" \
  "jsonc" \
  "kotlin" \
  "yaml"; \
  do nvim --headless -c "TSInstallSync ${n}" -c 'q'; done

COPY zsh-in-docker.sh /tmp

RUN /tmp/zsh-in-docker.sh \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p 'history-substring-search'

COPY .p10k.zsh $HOME
RUN mkdir -p $HOME/go &&                                                        \
    echo 'export GOPATH=$HOME/go' >> $HOME/.zshrc &&                            \
    echo 'export PATH=$PATH:$GOPATH/bin' >> $HOME/.zshrc &&                     \
    echo 'export PATH=$PATH:$HOME/.cargo/bin' >> $HOME/.zshrc &&                \
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> $HOME/.zshrc &&      \
    echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >> $HOME/.zshrc &&    \
    source $HOME/.zshrc

################################################################################################
### tmux ###
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

RUN <<EOF cat >> $HOME/.tmux.conf
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin "janoamaral/tokyo-night-tmux"
set -g @plugin 'laktak/extrakto'
set -g @plugin 'Morantron/tmux-fingers'

run '~/.tmux/plugins/tpm/tpm'
EOF