#!/bin/bash -e

# First check makes sure we don't override a user's custom alias
if [ "$(checkFileContent "$HOME/.bash_profile" "alias")" == "Found" ];
then
    echo "Previous alias statement(s)"
    # Second tjeck if git_prompt are found
    if [ "$(checkFileContent "$HOME/.bash_profile" "git_prompt ()")" == "Found" ];
    then
        echo ""
        echo "Seems like you have installed parentnode prompt"
        # Updates git_prompt()
        copyParentNodePromptToFile
        echo ""
    else 
        echo ""
        echo "Seems like you haven't installed parentnode prompt"
        echo ""
        echo "Installing"
        # Installs git_prompt()
        copyParentNodePromptToFile
        echo ""
    fi
    # Updates parentnode alias
    handleAlias 

else
    # Second tjeck if git_prompt are found for an edge case of deleted alias,
    # or if only base .bash_profile are created 
    if [ "$(checkFileContent "$HOME/.bash_profile" "git_prompt ()")" == "Found" ];
    then
        echo "You allready have parentNode Configuration"
        copyParentNodePromptToFile
    else 
        echo "Copying parentNode Configuration"
        copyParentNodePromptToFile

    fi
    # Installs alias
    handleAlias    
fi

