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
		"comment")
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
			if [ -z "$2" ];
			then
				echo "No comments"
			fi
			echo
			;;
		"section")
			echo
			echo 
			echo "{---$2---}"	
			echo
			echo
			;;
		"exit")
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

# Asking user for input based on type
ask(){
	#$1 - output query text for knowing what to ask for.
	#$2 - array of valid chacters:
	#$3 - type eg. Password
	# If type is:  
	## Password hide prompt input, allow special chars, allow min and max length for the string 
	## Email: valid characters(restrict to email format (something@somewhere.com))
	## Username: valid characters(letters and numbers)
	valid_answers=("$2")
	
	
	if [ "$3" = "Password" ]; then
		read -s -p "$1: "$'\n' question
	else 
		read -p "$1: " question 
	fi
	for ((i = 0; i < ${#valid_answers[@]}; i++))
    do
        if [[ "$question" =~ ^(${valid_answers[$i]})$ ]];
        then 
           	#echo "Valid"
			echo "$question"
        else
			
			#ask "$1" "${valid_answers[@]}"
			if [ "$3" = "Password" ];
			then
				ask "Invalid $3, try again" "$2" "$3"
			else
				ask "Invalid $3, try again" "$2" "$3"
			fi
        fi

    done
	

}
export -f ask

# Check if program/service are installed
testCommand(){
# Usage: returns a true if a program or service are located in 
# P1: kommando
# P2: array of valid responses
	valid_response=("$@")
	for ((i = 0; i < ${#valid_response[@]}; i++))
	do
		command_to_test=$($1 | grep -E "${valid_response[$i]}" || echo "")
		if [ -n "$command_to_test" ]; then
			echo "$command_to_test" 
		fi

	done

}
export -f testCommand

checkGitCredential(){
	value=$(git config user.$1)
	echo "$value"

}
export -f checkGitCredential

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

fileExists(){
	#$1 file to check for
	if [ -f $1 ]; then
		echo "true"
	else
		echo "false"
	fi
}
export -f fileExists

checkMariadbPassword(){
	if [ "$(fileExists "/mnt/c/srv/packages/$mariadb.zip")" = false ]; then
		if [ "$(fileExists "/mnt/c/srv/packages/$mariadb_alt")" = false ]; then
			password_is_set="false"
		fi	
	else
		password_is_set="true"
	fi
	echo "$password_is_set"
}
export -f checkMariadbPassword
deleteAndAppendSection(){
    sed -i "/$1/,/$1/d" "$3" 
    readdata=$( < $2)
    echo "$readdata" | sed -n "/$1/,/$1/p" >> "$3"
}
export -f deleteAndAppendSection

syncronizeAlias(){
    
	# Uncomment this source and destination when testing, comment out when done
	#source=$(</srv/sites/parentnode/ubuntu_environment/tests/test_syncronize_alias/source)
	#destination=/srv/sites/parentnode/ubuntu_environment/tests/test_syncronize_alias/destination
	
	# Comment out this source and destination when testing, uncomment when done
	source=$(<$2)
	destination=$3

	readarray -t source_key <<< $(echo "$source" | grep "$1" | cut -d \" -f2) 
    readarray -t source_value <<< $(echo "$source" | grep "$1" | cut -d \" -f3,4,5) 
    
    for i in "${!source_key[@]}"
    do
        sed -i 's%'"${source_key[$i]}.*"'%'"$(trimString "${source_value[$i]}")"'%g' $destination
        
    done
}
export -f syncronizeAlias

# Updates all the sections in the .bash_profile file with files in parentnode dot_profile
createOrModifyBashProfile(){
	# if $shell_interactive have value, the computer is accessed with an login prompt normally a server
	conf="/mnt/c/srv/tools/conf/dot_profile"
	conf_alias="/mnt/c/srv/tools/conf/dot_profile_alias"
	install_bash_profile=$(grep -E ". $HOME/.bash_profile" $HOME/.bashrc || echo "")
	#install_bash_profile=$(grep -E "\$HOME\/\.bash_profile" /home/$install_user/.bashrc || echo "")
	if [ -z "$install_bash_profile" ]; then
		outputHandler "comment" "Setting up .bash_profile"
		# Add .bash_profile to .bashrc
		echo "" >> $HOME/.bashrc
		echo "if [ -f \"$HOME/.bash_profile\" ]; then" >> $HOME/.bashrc
		echo " . $HOME/.bash_profile" >> $HOME/.bashrc
		echo "fi" >> $HOME/.bashrc
	else
		outputHandler "comment" ".bash_profile Installed"
	fi
	if [ "$(fileExists "$HOME/.bash_profile")" = true ]; then
		outputHandler "comment" ".bash_profile Exist"
		bash_profile_modify_array=("[Yn]")
		bash_profile_modify=$(ask "Do you want to modify existing .bash_profile (Y/n) !this will override existing .bash_profile!" "${bash_profile_modify_array[@]}" "option bash profile")
		export bash_profile_modify
	else
		#outputHandler "comment" "Installing \.bash_profile"´
		sudo cp $conf $HOME/.bash_profile
	fi
	if [ "$bash_profile_modify" = "Y" ]; then 
		outputHandler "comment" "Modifying existing .bash_profile"
		# Switch case checking for either a git prompt definition is present or alias is present allready
		case "true" in 
			$(checkFileContent "git_prompt ()" "$HOME/.bash_profile") | $(checkFileContent "alias" "$HOME/.bash_profile"))
				# if git prompt definition is provided by parentnode
				if [ "$(checkFileContent "# parentnode_git_prompt" "$HOME/.bash_profile")" = "true" ]; then
					# update existing git prompt definition section
					deleteAndAppendSection "# parentnode_git_prompt" "$conf" "$HOME/.bash_profile"
				fi
				# if alias is provided by parentnode
				if [ "$(checkFileContent "# parentnode_alias" "$HOME/.bash_profile")" = "true" ]; then
					# update existing alias section
					deleteAndAppendSection "# parentnode_alias" "$conf" "$HOME/.bash_profile"
				else
					# if alias is not parentnode alias add them  
					syncronizeAlias
				fi	
				# if more than one user is present at the system (client only) add the multiuser section
				deleteAndAppendSection "# parentnode_multi_user" "$conf" "$HOME/.bash_profile"
				;;
			# if .bash_profile is not listing any of the above, we must asume .bash_profile is broken.
			*)
				sudo rm $HOME/.bash_profile
				sudo cp $conf $HOME/.bash_profile
				;;
		esac
	else
		# parentnode alias is necessary for a parentnode environment
		syncronizeAlias "alias" "$conf_alias" "$HOME/.bash_profile"
	fi
	
}
export -f createOrModifyBashProfile

# Removes leading and following spaces
trimString()
{
	trim=$1
	echo "${trim}" | sed -e 's/^[ \t]*//'
}
export -f trimString

# Checks a file for a content based on a string
checkFileContent(){
	query=$1
	source=$(<$2)
	check_query=$(echo "$source" | grep "$query" || echo "")
	if [ -n "$check_query" ]; then
		echo "true"
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

