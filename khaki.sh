#!/bin/bash

## This is a script for C projects




## Config

typeset -A config
config=(
  [USER]="ME!"
)

## Args

ACTION=$1
TARGET=$2
OPTION=$3


## Colors

WHITE="\e[0;37m"
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
BLUE="\e[0;34m"
PURPLE="\e[0;35m"
CYAN="\e[0;36m"
RESET="\e[0m"

## Functions

if [ -z $ACTION ]; then
  echo "
  Usage: khaki <command> [options]

  Commands:
    new <name>          Create a new C project with src/, include/, 
                        README.md, and main.c
    run <output> [...]  Compile all .c files in the current directory into <output>
                        Additional arguments are passed to the compiler
    show -L <depth>     Display project tree using 'tree' if available
    config              Placeholder (no functionality yet)

  Examples:
    khaki new myproj
    khaki run app -O2 -Wall
    khaki show -L 2
"
  if ! command -v norminette >/dev/null 2>&1; then
    echo -e "${YELLOW}WARNING:${RESET} norminette is not in your path"
  fi

  if ! command -v trees >/dev/null 2>&1; then 
    echo -e "${YELLOW}WARNING:${RESET} tree is not in your path"
  fi
fi


new_fn() {
  local NAME="New Project"

  if [ -n "$TARGET" ]; then
    NAME="$TARGET"
  fi
  
  mkdir -p "$NAME"
  
  touch "${NAME}/main.c"
  echo "#include <stdio.h>
int main(int argc, char **argv)
{
  printf(\"Hello, ${config[USER]}!\n\");
  return 0;
}" > "${NAME}/main.c"
  touch "${NAME}/README.md"
  echo "# ${NAME}



## Highlights



## Overview



### Authors

List contributors or the maintaining group.



## Usage



## Installation

" > "${NAME}/README.md"
  
  mkdir "${NAME}/src"
  mkdir "${NAME}/include"
  
  echo -e "${CYAN}Created the directory${RESET} ${NAME}\n"

  tree -C $NAME

  if [[ -z "$OPTION" || "$OPTION" != "--open-not" ]]; then
    cd "$NAME" || retrun 1
  fi

}

create_fn() { 
  if [ -n "$TARGET" ]; then 
  case "$TARGET" in
    main.c)
      printf '#include <stdio.h>

int main(int argc, char **argv)
{
  printf("Hello, %s!\\n");
  return 0;
}
' "${config[USER]}" > "main.c"
      ;;
    *)
      touch -- "$TARGET"
      ;;
   esac
  else
    printf "${PURPLE}NOTE:${RESET} Need target!\n"
  fi

}

run_fn() {

  # cfiles: list of .c in the project diractory
  # OPTION: compiler flags
  # TARGET: the name of the excutable

  cfiles=$(find . -maxdepth 1 -type f -name "*.c")  

  if [ ${#cfiles[@]} -ne 0 ]; then
    echo -e "${CYAN}Running project in${RESET} ${PWD}...\n"
   
    if [ -n "$OPTION" -a -n "$TARGET" ]; then
     gcc ${cfiles[@]} "$OPTION" -o "$TARGET" "${$3..$10}"
    else
     gcc ${cfiles[@]} -o a.out
    fi
    
    if [ $? -eq 0 ]; then
      ./"$TARGET"
      if [ $? -eq 0 ]; then
        echo -e "\n${GREEN}Project execution finished${RESET}"
      else
        echo -e "\n${RED}ERROR:${RESET} Project execution failed"
      fi
    else
      echo -e "\n${RED}ERROR:${RESET} Compilation failed"
    fi
  else
    echo -e "\n${YELLOW}WARNING:${RESET} no .c were found"  
  fi      
}

config_fn() {
  echo Set a user name:
}

## Cases
case "$ACTION" in
  new) new_fn;;
  create) create_fn;;
  run) run_fn;;
  show)
    echo "Current project directory:"
    tree $TARGET $OPTION
  ;;
  config) config_fn;;
esac
