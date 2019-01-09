#!/bin/bash -e

if [ "$(checkFileContent "$HOME/.bash_profile" "alias")" == "Found" ];
then
    echo "Previous alias statement(s)"
    if [ "$(checkFileContent "$HOME/.bash_profile" "git_prompt ()")" == "Found" ];
    then
        echo ""
        echo "Seems like you have installed parentnode prompt"
        copyParentNodePromptToFile
        echo ""
    else 
        echo ""
        echo "Seems like you haven't installed parentnode prompt"
        echo ""
        echo "Installing"
        copyParentNodePromptToFile
        echo ""
    fi
    #sudo chown "$username:$username" "$HOME/.profile"
    handleAlias 

else

    if [ "$(checkFileContent "$HOME/.bash_profile" "git_prompt ()")" == "Found" ];
    then
        echo "You allready have parentNode Configuration"
    else 
        echo "Copying parentNode Configuration"
        copyParentNodePromptToFile

    fi
    handleAlias    
fi

