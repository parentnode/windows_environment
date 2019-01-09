#!/bin/bash -e
copyParentNodeGitPromptToFile(){
    read_git_prompt_file=$( < "/mnt/c/srv/tools/conf/dot_profile_git_promt")
	read_dot_bash_profile=$( < "$HOME/.bash_profile")
    #echo "$source_file" | sed -n "/$source_text_start/,/$source_text_start/p" >> "$destination_file"
    ref_prompt=$( echo "$read_git_prompt_file" | sed -n '/# enable git prompt/,/# end enable git prompt/p')
	replace_prompt=$( echo "$read_dot_bash_profile" | sed -n '/# enable git prompt/,/# end enable git prompt/p')
	if [ "$ref_prompt" != "$replace_prompt" ]; 
	then
		echo "Updated version of parentnode prompt available"
		sed -i '/# enable git prompt/,/# end enable git prompt/d' $HOME/.bash_profile
		echo "Deleted old version"
		echo "$ref_prompt" >> $HOME/.bash_profile
        echo "" >> $HOME/.bash_profile
		echo "Added new one"
	else
		echo "Allready on newest version"
	fi
}
export -f copyParentNodeGitPromptToFile

copyParentNodePromptToFile(){
    read_prompt_file=$( < "/mnt/c/srv/tools/conf/dot_profile")
	admin_check= $( echo $read_prompt_file | grep -E ^"# ADMIN CHECK WINDOWS ONLY")
	if [ -z "$admin_check"]; 
	then
		echo "$read_prompt_file" | sed -n '/# ADMIN CHECK WINDOWS ONLY/,/# END ADMIN CHECK WINDOWS ONLY/p' >> $HOME/.bash_profile
	fi
	running_bash= $( echo $read_prompt_file | grep -E ^"# if running bash")
	if [ -z "$running_bash"]; 
	then
		echo "$read_prompt_file" | sed -n '/# if running bash/,/# end if running bash/p' >> $HOME/.bash_profile
	fi
	set_path= $( echo $read_prompt_file | grep -E ^"# set PATH so it includes users private bin if it exists")
	if [ -z "$set_path"]; 
	then
		echo "$read_prompt_file" | sed -n '/# set PATH so it includes users private bin if it exists/,/# end set PATH so it includes users private bin if it exists/p' >> $HOME/.bash_profile	
	fi
	
	copyParentNodeGitPromptToFile
}
export -f copyParentNodePromptToFile

trimString()
{
	trim=$1
	echo "${trim}" | sed -e 's/^[ \t]*//'
}
export -f trimString

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
            echo "" >> "$HOME/.bash_profile"
            echo "$(trimString "${default_values[line]}")" >> "$HOME/.bash_profile"
        fi
    done

}
export -f handleAlias

checkFolderOrCreate(){
	folderName=$1
	if [ -e $folderName ];
	then
		echo "$folderName already exists"
	else 
		echo "Create directory $folderName"
    	mkdir -p $folderName;
	fi

}