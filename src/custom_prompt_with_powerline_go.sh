#!/bin/bash

printf "==> 1) Install Go, jq, curl, git, unzip \n"
sudo apt -yqq install curl jq git unzip wget fontconfig > "/dev/null" 2>&1
# sudo apt -yqq install golang-go  # (18.04: go1.10.4, 20.04: go1.13.8)
sudo snap install go --classic     # (18.04: go1.15.8) 

printf "==> 2) Install Powerline-Go \n"
go get -u github.com/justjanne/powerline-go

printf "==> 3) Set the Ubuntu prompt configuration ('-newline' param sets prompt in 2 lines) \n"
## The delimiting identifier is quoted to avoid the shell substitutes all variables, commands 
## and special characters before passing the here-document lines to the command.
## https://linuxize.com/post/bash-heredoc/
cat << 'EOF' > powerline-go-loader.sh
#!/bin/bash

GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

function _update_ps1() {
    PS1="$($GOPATH/bin/powerline-go -newline -error $?)"
}
if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
EOF
chmod +x powerline-go-loader.sh
mv -f powerline-go-loader.sh $HOME/powerline-go-loader.sh
echo '# Loading Powerline-Go' >> ~/.bashrc
echo '. $HOME/powerline-go-loader.sh' >> ~/.bashrc

printf "==> 4) Install MS Cascadia fonts with Powerline glyphs \n"
PL_FONTS_URL=$(curl -s https://api.github.com/repos/microsoft/cascadia-code/releases/latest | jq -r -M '.assets[].browser_download_url')
PL_FONTS_FILENAME="${PL_FONTS_URL##*/}"
# PL_FONTS_FILENAME=$(basename -- "$PL_FONTS_URL")
PL_FONTS_NAME="${PL_FONTS_FILENAME%.*}"
PL_FONTS_EXTENSION="${PL_FONTS_FILENAME##*.}"
mkdir -p $HOME/.fonts/powerline/$PL_FONTS_NAME
wget -q $PL_FONTS_URL
unzip -oq $PL_FONTS_NAME -d $HOME/.fonts/powerline/$PL_FONTS_NAME
fc-cache -f $HOME/.fonts  

printf "==> 5) Reload the init bash script to apply the new styled Ubuntu prompt \n"
. ~/.bashrc
printf "\t. ~/.bashrc \n"

printf "==> 6) Installation and configuration completed \n\n"
