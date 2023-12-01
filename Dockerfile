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
        julia tmux xsel xclip gh gcc-c++-riscv64-linux-gnu gcc-riscv64-linux-gnu -y

RUN pip install pynvim && gem install neovim && sudo npm install -g neovim
RUN go install github.com/jesseduffield/lazygit@latest && \
    go install github.com/dundee/gdu/v5/cmd/gdu@latest

RUN cargo install tree-sitter-cli bat bottom du-dust fd-find lsd broot ripgrep sd

RUN git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim && \
    git clone https://github.com/PennixRv/astronvim_config.git ~/.config/nvim/lua/user

RUN nvim --headless -c "Lazy! sync" +qa

RUN for n in \
  "arduino_language_server" \
  "asm-lsp" \
  "autotools_ls" \
  "bashls" \
  "clangd" \
  "cmake" \
  "docker_compose_language_service" \
  "dockerls" \
  "gopls" \
  "gradle_ls" \
  "html" \
  "java_language_server" \
  "jsonls" \
  "jsonnet_ls" \
  "julials" \
  "kotlin_language_server" \
  "lua_ls" \
  "pyright" \
  "rust_analyzer" \
  "sqlls" \
  "yamlls"; \
  do nvim --headless -c "LspInstall --sync ${n}" -c 'q'; done

RUN for n in \
  "bash-debug-adapter" \
  "codelldb" \
  "cpptools" \
  "debugpy" \
  "java-debug-adapter" \
  "go-debug-adapter" \
  "vscode-java-decompiler"\
  "cmakelang" \
  "cmakelint" \
  "commitlint" \
  "cpplint" \
  "gitleaks" \
  "gitlint" \
  "glint" \
  "golangci-lint" \
  "gospel" \
  "jsonlint" \
  "luacheck" \
  "markdownlint" \
  "markdownlint-cli2" \
  "markuplint" \
  "pydocstyle" \
  "pyflakes" \
  "pylama" \
  "pylint" \
  "shellcheck" \
  "shellharden" \
  "textlint" \
  "yamllint"; \
  do nvim --headless -c "MasonInstall --sync ${n}" -c 'q'; done

RUN for n in \
  "asmfmt" \
  "autopep8" \
  "clang-format" \
  "autoflake" \
  "beautysh" \
  "cmakelang" \
  "csharpier" \
  "docformatter" \
  "doctoc" \
  "dprint" \
  "fixjson" \
  "gofumpt" \
  "goimports" \
  "goimports-reviser" \
  "golines" \
  "gomodifytags" \
  "google-java-format" \
  "gotests" \
  "luaformatter" \
  "markdown-toc" \
  "markdownlint" \
  "markdownlint-cli2" \
  "mdformat" \
  "prettier" \
  "prettierd" \
  "rubyfmt" \
  "rustywind" \
  "shfmt" \
  "stylua" \
  "yamlfix" \
  "yamlfmt"; \
  do nvim --headless -c "MasonInstall --sync ${n}" -c 'q'; done


RUN for n in \
  "asm" \
  "diff" \
  "dockerfile" \
  "git-rebase" \
  "gitcommit" \
  "gitignore" \
  "meson" \
  "ninja" \
  "rust" \
  "toml" \
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

RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"  \
    && git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
    && git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone --depth=1 https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions \
    && sed -i 's#^ZSH_THEME=.*$#ZSH_THEME="powerlevel10k/powerlevel10k"#' $HOME/.zshrc \
    && sed -i 's#^plugins=.*$#plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting )#' $HOME/.zshrc

COPY .p10k.zsh $HOME
RUN mkdir -p $HOME/go
RUN <<EOF cat >> $HOME/.zshrc
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
POWERLEVEL9K_DISABLE_GITSTATUS=true
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

export TERM=xterm-256color
export GOPATH=\$HOME/go
export PATH=\$PATH:\$HOME/bin
export PATH=\$PATH:\$HOME/.local/bin
export PATH=\$PATH:\$GOPATH/bin
export PATH=\$PATH:\$HOME/.cargo/bin

alias vim='nvim'
EOF
SHELL ["/usr/bin/zsh", "-c"]
RUN source $HOME/.zshrc

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
RUN <<EOF cat >> $HOME/.config/tmuxp/dev.yaml
session_name: rivai
windows:
  - window_name: dev1
    layout: tiled
    panes:
      - pane
      - pane
      - pane
      - pane
  - window_name: dev2
    layout: tiled
    panes:
      - pane
      - pane
      - pane
      - pane
EOF
########################################################################################################################
### github configurations
# RUN echo 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 > gh_token && gh auth login -h github.com --with-token < gh_token
RUN <<EOF cat >> $HOME/.gitconfig
[cola]
        startupmode = list
[user]
        email = pennaliflake@gmail.com
        name = pennix
[credential "https://github.com"]
        helper =
        helper = !/usr/bin/gh auth git-credential
[credential "https://gist.github.com"]
        helper =
        helper = !/usr/bin/gh auth git-credential
EOF

ENTRYPOINT ["/usr/bin/zsh", "-c", "nvim"]