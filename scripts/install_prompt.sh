#!/bin/bash -e

# First check makes sure we don't override a user's custom alias
if [ "$(checkFileContent "$HOME/.bash_profile" "alias")" == "Found" ];
then
    echo "---------------------------------"
    echo "---Previous alias statement(s)---"
    echo "---------------------------------"
    echo ""
    # Second tjeck if git_prompt are found
    if [ "$(checkFileContent "$HOME/.bash_profile" "git_prompt ()")" == "Found" ];
    then
        echo "-----------------------------------------------------"
        echo "---Seems like you have installed parentnode prompt---"
        echo "-----------------------------------------------------"
        # Updates git_prompt()
        copyParentNodePromptToFile
        echo ""
    else 
        echo "--------------------------------------------------------"
        echo "---Seems like you haven't installed parentnode prompt---"
        echo "--------------------------------------------------------"
        
        echo "----------------"
        echo "---Installing---"
        echo "----------------"
        echo ""
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
        echo "------------------------------------------------"
        echo "---You allready have parentNode Configuration---"
        echo "------------------------------------------------"
        echo ""
        copyParentNodePromptToFile
        echo ""
    else 
        echo "--------------------------------------"
        echo "---Copying parentNode Configuration---"
        echo "--------------------------------------"
        echo ""
        copyParentNodePromptToFile
        echo ""
    fi
    # Installs alias
    echo ""
    handleAlias
    echo ""    
fi

