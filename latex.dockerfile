FROM ubuntu:latest

WORKDIR /
SHELL ["bash", "-c"]
# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -o Dpkg::Options::="--force-confnew" \
                    python3-pip git iputils-ping net-tools netcat screen less \
                    python3-sympy \
                    exuberant-ctags \
                    cmake \
                    build-essential \
                    texlive-latex-extra \
                    texlive-pictures \
                    wget jsonlint libxml2-utils patchelf \
                    vim vim-gtk texlive-pictures gnuplot chktex exuberant-ctags \
                    pandoc maven \
                    && rm -rf /var/lib/apt/lists/* && \
        chmod 777 /etc/vim && \
        mkdir -p /etc/vim/bundle && \
        chmod 777 /etc/vim/bundle && \
        git clone https://github.com/VundleVim/Vundle.vim.git /etc/vim/bundle/Vundle.vim && \
        git clone https://github.com/vim-latex/vim-latex.git /etc/vim/bundle/vim-latex && \
        git clone https://github.com/preservim/tagbar.git /etc/vim/bundle/tagbar && \
        git clone https://github.com/jlanzarotta/bufexplorer.git /etc/vim/bundle/bufexplorer && \
        git clone https://github.com/dense-analysis/ale.git /etc/vim/bundle/ale && \
        git clone https://github.com/aklt/vim-substitute.git /etc/vim/bundle/vim-substitute && \
        git clone https://github.com/SirVer/ultisnips.git /etc/vim/bundle/ultisnips && \
        git clone https://github.com/honza/vim-snippets.git /etc/vim/bundle/vim-snippets && \
        git clone https://github.com/tpope/vim-fugitive.git /etc/vim/bundle/vim-fugitive && \
        git clone https://github.com/sukima/xmledit.git /etc/vim/bundle/xmledit && \
        git clone https://github.com/preservim/nerdtree.git /etc/vim/bundle/nerdtree && \
        git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git /etc/vim/bundle/nerdtree-git-plugin && \
        git clone https://github.com/lfv89/vim-interestingwords.git /etc/vim/bundle/vim-interestingwords && \
        git clone --depth 5 https://github.com/languagetool-org/languagetool.git /languagetool-build

RUN cd /languagetool-build && mvn clean test 

RUN cd /languagetool-build && \
        ./build.sh languagetool-standalone package -DskipTests && \
        mkdir /languagetool && \
        mv $(dirname $(find languagetool-standalone/ -name "languagetool-commandline.jar"))/* /languagetool && \
        cd / && rm -rf /languagetool-build && \
        pip3 install  git+https://github.com/matze-dd/YaLafi.git@master && \
        wget https://raw.githubusercontent.com/matze-dd/YaLafi/master/editors/lty.vim \
                -O /etc/vim/bundle/ale/ale_linters/tex/lty.vim

COPY configfiles/vimrc_latex /etc/vim/vimrc
