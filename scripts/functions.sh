#!/bin/bash -e

# Get username for current user, display and store for later use
getUsername(){
	echo "$SUDO_USER"
}
export -f getUsername

# Invoke sudo command
enableSuperCow(){
	sudo ls &>/dev/null
}
export -f enableSuperCow

# Helper function for text output and format 
outputHandler(){
	#$1 - type eg. Comment, Section, Exit
	#$2 - text for output
	#$3,4,5 are extra text when needed
	case $1 in 
		"Comment")
			echo
			echo "$2"
			if [ -n "$3" ];
			then
				echo "$3"
			fi
			if [ -n "$4" ];
			then
				echo "$4"
			fi
			if [ -n "$5" ];
			then
				echo "$5"
			fi
			if [ -z "$2"];
			then
				echo "No comments"
			fi
			echo
			;;
		"Section")
			echo
			echo 
			echo "{---$2---}"	
			echo
			echo
			;;
		"Exit")
			echo
			echo "$2 -- Goodbye see you soon"
			exit 0
			;;
		#These following commentary cases are used for installing and configuring setup
		*)
			echo 
			echo "Are you sure you wanted output here can't recognize: ($1)"
			echo
			;;

	esac
}
export -f outputHandler

updateStatementInFile(){
    check_statement=$1
	input_file=$2
	output_file=$3
	read_input_file=$(<"$input_file")
	read_output_file=$( < "$output_file")
	check=$(echo "$read_output_file" | grep -E ^"$check_statement" || echo "")
	if [ -n "$check" ];
	then 
		sed -i "/# $check_statement/,/# end $check_statement/d" "$output_file"
		echo "$read_input_file" | sed -n "/# $check_statement/,/# end $check_statement/p" >> "$output_file"
	fi
	echo ""	
}

export -f updateStatementInFile

# Updates all the sections in the .bash_profile file with files in parentnode dot_profile
copyParentNodePromptToFile(){
	updateStatementInFile "admin check" "/mnt/c/srv/tools/conf/dot_profile" "$HOME/.bash_profile"
	updateStatementInFile "running bash" "/mnt/c/srv/tools/conf/dot_profile" "$HOME/.bash_profile"
	updateStatementInFile "set path" "/mnt/c/srv/tools/conf/dot_profile" "$HOME/.bash_profile"
	## Updates the git_prompt function found in .bash_profile 
	# simpler version instead of copyParentNodeGitPromptToFile. awaiting approval 
	updateStatementInFile "enable git prompt" "/mnt/c/srv/tools/conf/dot_profile_git_promt" "$HOME/.bash_profile"
	
}
export -f copyParentNodePromptToFile

# Removes leading and following spaces
trimString()
{
	trim=$1
	echo "${trim}" | sed -e 's/^[ \t]*//'
}
export -f trimString

# Checks a file for a content based on a string
checkFileContent(){
	#dot_profile
	file=$1
	
	check=$2
	
	statement=$(grep "$check" $file || echo "")

	if [ -n "$statement" ];
	then 
		echo "Found"
    else 
        echo "Not Found"
	fi
		
}
export -f checkFileContent

# If an alias from parentnode exists then this script will update it, else it will parse it
handleAlias(){
    IFS=$'\n'
    read_alias_file=$( < "/mnt/c/srv/tools/conf/dot_profile_alias" )

    # The key komprises of value between the first and second quotation '"'
    default_keys=( $( echo "$read_alias_file" | grep ^\" |cut -d\" -f2) )

    #The value komprises of value between the third, fourth and fifth quotation '"'
    default_values=( $( echo "$read_alias_file" | grep ^\" |cut -d\" -f3,4,5) )
    unset IFS    
    for line in "${!default_keys[@]}"
    do		
        if [ "$(checkFileContent "$HOME/.bash_profile" "${default_keys[line]}")" == "Found" ];
        then
            echo "Updated ${default_values[line]}"
            sed -i -e "s,${default_keys[line]}\=.*,$(trimString "${default_values[line]}"),g" "$HOME/.bash_profile"
        else 
            echo "None or not all parentnode alias present" 
            echo " copying $(trimString "${default_values[line]}") "
            echo "$(trimString "${default_values[line]}")" >> "$HOME/.bash_profile"
        fi
    done
	echo ""
}
export -f handleAlias

# Checks if a folder exists if not it will be created
checkFolderOrCreate(){
	folderName=$1
	if [ -e $folderName ];
	then
		echo "$folderName already exists"
	else 
		echo "Create directory $folderName"
    	mkdir -p $folderName;
	fi
	echo ""
}
export -f checkFolderOrCreate

# Setting Git credentials if needed
git_configured(){
	git_credential=$1
	credential_configured=$(git config --global user.$git_credential || echo "")
	if [ -z "$credential_configured" ];
	then 
		echo "No previous git user.$git_credential entered"
		echo
		read -p "Enter your new user.$git_credential: " git_new_value
		git config --global user.$git_credential "$git_new_value"
		echo
	else 
		echo "Git user.$git_credential allready set"
	fi
	echo ""
}
export -f git_configured

