#!/bin/bash
#Inherited version: 1.0

echo "Cleaning profile settings..."
echo "#Inherited version: 1.0" > ~/.bash_profile
echo "Setting rights..."
chmod +x ~/Utilities/*.sh ~/Utilities/Examples/*.sh

echo "Configuring your account now..."
sleep 1.5s
echo "We can notify you by e-mail about program statuses."
sleep 1.5s
echo "Enter your address below or leave the field empty to skip."
sleep 1s
echo -n "E-mail: "
read mail
echo "Telegram users can also receive notifications."
sleep 1.5s
echo "To do so enter code from @ailurus_bot (More -> Get code)."
sleep 1s
echo -n "Telegram Code: "
read telegram
while ! [[ "${telegram}" =~ '^[0-9]+$' || "" == ${telegram} ]] ; do
    echo "Code should only contain numbers!"
    echo -n "Telegram Code: "
    read telegram
done
echo "..."
sleep 1s
echo "Please, check your data."
echo "Username: $(whoami)"
echo "E-mail: ${mail}"
echo "Telegram: ${telegram}"
echo -n "Continue? (Y/n) "
read item
case "$item" in
    n|N) echo "Exiting..."
        exit 0
        ;;
    *) 
        ;;
esac
echo "..."

echo "Creating configuration file..."
cd ~/
echo "username=\"$(whoami)\"
mail=\"${mail}\"
telegram=\"${telegram}\"
baseDir=\"$(pwd)\""> ~/user.cfg

echo "Updating bash profile..."
echo "alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias la='ls'
alias qq='squeue -i 1'
alias ww='top -u starobinskiieb'
alias bc='bc -liq'
alias space='du -chs .'
alias python3='/lustre/opt/software/python/3.5.2/bin/python3'

sccInfo(){
    sccIP=\$(ip a | grep \"global enp\" | awk '{print \$2}' | head -n 2 | tail -n 1)
    
    echo \"IP: \${sccIP}\"
    
    sacctmgr show assoc | awk '/cpu/{print \"Limits: \" \$4 \", disk=1TB\"}'
    
    echo \"CPUs per node: \$(nproc --all)\" 
}

setTime(){
    scontrol update jobid=\${2} TimeLimit=\${1}
}

clean(){
    $(pwd)/Utilities/clean.sh \${@}
}

notify(){
    source /home/ipmmtm/starobinskiieb/user.cfg
    
    curl --data \"message=\${1}&telegram=\${telegram}&mail=\${mail}\" https://ailurus.ru/stands/scc/server/daemon.php
}

publish(){
    source /home/ipmmtm/starobinskiieb/user.cfg
    
    result=\$(curl -F data=@\${1} https://ailurus.ru/stands/scc/server/savior.php)
    firstTerm=\$(echo \"\${result}\" | awk -F'\"' '{print \$2}')
    
    if [ \"name\" = \"\${firstTerm}\" ]; then
        echo \"\${result}\" | awk -F'\"' '{print \"Your link is\n\" \$8}' | sed -e 's/\\\\\\//\\//g'
    else
        echo \"An error occured.\"
        echo \"\${result}\"
    fi
}

calc(){
    answer=\$(echo \"\${@}\" | tr -d ' ' | bc -liq | tail -n 1)
    
    echo \"\${@} = \${answer}\"
}

multiDo(){
    while sleep 1s; do 
        \${@}
    done
}

#do not edit this block unless you know what you are doing
PROMPT_COMMAND='echo -ne \"\\033]0;SCC Connect\\007\"'

export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:\$(pwd)/Utilities/AiLibrary

shopt -s histappend
PROMPT_COMMAND='history -a'

export HISTCONTROL='ignoredups'

export HISTIGNORE='&:ls:[bf]g:exit'

shopt -s cdspell

shopt -s cmdhist

#set +H
" >> ~/.bash_profile

echo "Including Intel modules..."
echo "module load null" > ~/.modules
module initadd compiler/intel/2017.2.174
module initadd mpi/impi/2017.2.174

tput bold
echo -e "\nModules and profile functions will be added at the next log in."
tput setaf 2
echo "Done"
tput sgr0
