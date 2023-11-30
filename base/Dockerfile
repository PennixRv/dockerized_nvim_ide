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

########################################################################################################################
### nvim configurations
RUN sudo dnf update -y && \
    sudo dnf install git rust cargo gcc gcc-c++ autoconf automake           \
        cmake golang llvm clang-tools-extra clang bear nodejs lua           \
        ruby ruby-devel zsh neovim shadow-utils openssl fzf pip wget        \
        luarocks composer php java-devel java-openjdk-headless java-openjdk \
        julia tmux -y

RUN pip install pynvim && gem install neovim && sudo npm install -g neovim
RUN go install github.com/jesseduffield/lazygit@latest && \
    go install github.com/dundee/gdu/v5/cmd/gdu@latest

RUN cargo install tree-sitter-cli bat bottom du-dust fd-find lsd broot ripgrep sd

RUN git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim && \
    git clone https://github.com/PennixRv/astronvim_config.git ~/.config/nvim/lua/user

RUN nvim --headless -c "Lazy! sync" +qa

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
########################################################################################################################
### zsh configurations
COPY zsh-in-docker.sh /tmp

RUN /tmp/zsh-in-docker.sh \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p 'history-substring-search'

COPY .p10k.zsh $HOME
RUN mkdir -p $HOME/go
RUN <<EOF cat >> $HOME/.zshrc
export GOPATH=\$HOME/go
export PATH=\$PATH:\$HOME/bin
export PATH=\$PATH:\$HOME/.local/bin
export PATH=\$PATH:\$GOPATH/bin
export PATH=\$PATH:\$HOME/.cargo/bin
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
alias vim='nvim'
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

########################################################################################################################
### tmux configurations
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

RUN <<EOF cat >> $HOME/.tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'catppuccin/tmux'

setw -g mouse on

set -g @catppuccin_window_right_separator "█ "
set -g @catppuccin_window_number_position "right"
set -g @catppuccin_window_middle_separator " | "
set -g @catppuccin_window_default_fill "none"
set -g @catppuccin_window_current_fill "all"
set -g @catppuccin_status_modules_right "application session date_time"
set -g @catppuccin_status_left_separator "█"
set -g @catppuccin_status_right_separator "█"
set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"

run '~/.tmux/plugins/tpm/tpm'
EOF

RUN  $HOME/.tmux/plugins/tpm/bin/install_plugins
RUN pip install --user tmuxp && mkdir -p $HOME/.config/tmuxp
RUN <<EOF cat >> $HOME/.config/tmuxp/work.yaml
session_name: work
windows:
  - window_name: dev
    layout: tiled
    shell_command_before:
      - cd ~/
    panes:
      - shell_command:
          - cd ~
      - shell_command:
          - ssh pfu@10.102.11.129
      - null
      - null
EOF

########################################################################################################################