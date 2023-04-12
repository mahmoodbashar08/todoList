#!/bin/bash

if [ $# -eq 0 ]; then
    echo "╔═════════════════════════════════════════════╗"
    echo "║         welocme to my todoList app          ║"
    echo "║          for using it please type           ║"
    echo "║             todoList [option]               ║"
    echo "║     never forget if you need anything       ║"
    echo "║                 just type                   ║"
    echo "║                todoList -h                  ║"
    echo "║  mahmood :)                                 ║"
    echo "╚═════════════════════════════════════════════╝"

    exit 0
fi
path="path-to-folder"
while getopts :hda:r:c-: opt; do
    case ${opt} in
    h)
        echo "Options:"
        echo "  -h  Display this help message"
        echo "  -d  Display all todos"
        echo "  -a  Add a new todo you should use = > \"todo name\" < = this syntax"
        echo -e "      for example if you want to add new todo you should type todoList -a \"buy new pc\"\n"
        echo "  -r  Remove the todo you should enter the exact name of the todo using = > \"todo name\" < = this syntax"
        echo -e "      for example if you want to remove a todo you should type todoList -r \"buy new pc\"\n"
        echo "  -c To clear the todo list"
        echo "  --af Add a todo to the first of the file"
        exit 0
        ;;
    a)
        name=$OPTARG
        if grep -q "\<$name\>" "$path"; then
            echo "Todo already exists: $name"
        else
            echo -e "$name" >>"$path"
            echo "Todo added successfully: $name"
        fi
        ;;
    d)
        if test ! -s "$path"; then
            echo -e "No todos to display.\n"
        else
            cat "$path"
            # echo -e "\n"
        fi
        ;;
    c)
        if test ! -s "$path"; then
            echo -e "the todos already empty good job :)"
        else
            truncate -s 0 "$path"
            echo -e "done all todos has been removed good job"
        fi
        ;;
    r)
        if ! grep -q "^${OPTARG}$" "$path"; then
            echo "Error: Todo does not exist in the file"
            exit 1
        else
            name=$OPTARG
            sed -i "/^$name$/d" "$path"
            echo "Todo removed successfully: $name"
            echo -e "Todo still to go\n"
            cat "$path"
        fi
        ;;
    -)
        case ${OPTARG} in
        af)
            if [ -z "${!OPTIND}" ] || [[ "${!OPTIND}" == -* ]]; then
                echo "Error: Option --$OPTARG requires an argument like --af FILENAME" >&2
                exit 1
            else
                name="${!OPTIND}"
                if grep -q "\<$name\>" "$path"; then
                    echo "Todo already exists: $name"
                else
                    sed -i "1i$name" "$path"
                    echo -e "done\n todos to go \n"
                    cat "$path"
                fi
            fi
            ;;
        *)
            echo "Invalid option: --$OPTARG" >&2
            echo "Usage: todoList [option] type -h for help" >&2
            exit 1
            ;;
        esac
        ;;
    \?)
        echo "Invalid option: -$OPTARG" 1>&2
        echo "Usage: todoList [option] type -h for help" 1>&2
        exit 1
        ;;
    :)
        case $OPTARG in
        a)
            echo "Error: Option -$OPTARG requires an argument like -a \"complete task\""
            exit 1
            ;;
        r)
            echo "Error: Option -$OPTARG requires an argument like -r \"completed task\""
            exit 1
            ;;
        *)
            echo "Error: Unknown error occurred"
            exit 1
            ;;
        esac
        ;;
    esac
done
