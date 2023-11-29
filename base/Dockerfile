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

RUN mkdir -p $HOME/go &&                                           \
    echo 'export GOPATH=$HOME/go' >> $HOME/.zshrc &&               \
    echo 'export PATH=$PATH:$GOPATH/bin' >> $HOME/.zshrc &&        \
    echo 'export PATH=$PATH:$HOME/.cargo/bin' >> $HOME/.zshrc &&   \
    source $HOME/.zshrc

RUN cargo install tree-sitter-cli bat bottom du-dust fd-find lsd broot ripgrep sd


RUN git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim && mkdir -p ~/.config/nvim/lua/user

RUN nvim --headless "+Lazy! sync" +"sleep 15" +qa

RUN nvim --headless +AstroUpdatePackages +qa

RUN nvim --headless +"LspInstall    asm-lsp bash-language-server bzl cmake-language-server                  \
                                    clangd deno dockerfile-language-server docker-compose-language-service  \
                                    gopls java-language-server json-lsp lua-language-server pyright         \
                                    rust-analyzer vim-language-server yaml-language-serve jsonls luals" +qa

RUN nvim --headless +"DapInstall    bash-debug-adapter codelldb debugpy go-debug-adapter " +qa

RUN nvim --headless +"MasonInstall  asmfmt autopep8 beautysh clang-format \
                                    cmakelint commitlint cpplint gitlint gitui markdownlint prettier pylint" +qa

RUN nvim --headless +"TSInstall jsonc" +qa

COPY zsh-in-docker.sh /tmp

RUN /tmp/zsh-in-docker.sh \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p 'history-substring-search'
