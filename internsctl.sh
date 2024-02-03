
show_help() {
    echo "Usage: xyx [options]"
    echo "Options:"
    echo "  --help     Show this help message"
    
}

create_man_page(){
     sudo cp internsctl.man /usr/share/man/man1/internsctl.1
     sudo mandb
}

show_version(){
	echo "1.0.0"

}

show_memory(){
	free

}

show_cpu(){
    lscpu
}

add_user(){
    echo Adding User "$1" 
    sudo useradd -m "$1"
    exit 0

}

get_user(){
    awk -F: '{print $1}' /etc/passwd
}

get_sudo_only(){
    getent group sudo | awk -F: '{print $4}'
}

file_info(){


    echo File:  `ls -la "$1" | awk '{print $9}'`
    echo Access:  `ls -la "$1" | awk '{print $1}'`
    echo Size\(B\):  `ls -la "$1" | awk '{print $5}'`
    echo Owner:  `ls -la "$1" | awk '{print $3}'`
    echo Modified Time:  `ls -la "$1" | awk '{print $8}'`
}


if [[ -e "/usr/share/man/man1/internsctl.1" ]]; then
    echo ""
else
    create_man_page
fi


if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi


if [[ "$1" == "--version" ]]; then
	show_version
	exit 0
fi

# if [[ "$1" == "memory getinfo" ]]; then
#         show_memory
#         exit 0
# fi

if [[ "$1" == "memory" && "$2" == "getinfo" ]]; then
 	show_memory
	exit 0
fi

if [[ "$1" == "cpu" && "$2" == getinfo ]]; then
        show_cpu
        exit 0
fi

if [[ "$1" == "user" && "$2" == create ]]; then
        if [[ -z "$3" ]] ; then
            echo "No Username Given"
        else
            add_user "$3"
        fi
        exit 0
fi

if [[ "$1" == "user" && "$2" == "list" ]]; then
    if [[ "$3" == "--sudo-only" ]]; then
        get_sudo_only
    else
        get_user
    fi
    exit 0
fi



if [[ "$1" == "file" && "$2" == getinfo ]]; then
        if [[ -z "$3" ]] ; then
            echo "No Filename Given"
        else
            if [[ "$3" == "--size" || "$3" == "-s" ]]; then
                echo Size\(B\):  `ls -la "$4" | awk '{print $5}'`
            fi
            if [[ "$3" == "--permission" || "$3" == "-p" ]]; then
                echo Permission:  `ls -la "$4" | awk '{print $1}'`
            fi
            if [[ "$3" == "--owner" || "$3" == "-o" ]]; then
                echo Owner:  `ls -la "$4" | awk '{print $3}'`
            fi
            if [[ "$3" == "--last-modified" || "$3" == "-m" ]]; then
                echo Modified Time:  `ls -la "$4" | awk '{print $8}'`
            fi

            if [[ "$3" != "--size" && "$3" != "--permission"  && "$3" != "--owner" && "$3" != "--last-modified" && "$3" != "-s" && "$3" != "-p" && "$3" != "-o" && "$3" != "-m" ]]; then
                file_info "$3"
            fi
        fi
        exit 0
fi




