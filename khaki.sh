## This is a script for C projects

## Args

ACTION=$1
TARGET=$2
OPTION=$3

## Functions

new_fn() {
  local DIR="New Project"

  if [ -n "$TARGET" ]; then
    DIR="$TARGET"
  fi
  
  mkdir -p "$DIR"
  
  touch "${DIR}/main.c"
  touch "${DIR}/README.md"
  
  echo "Created the directory ${DIR}"

  if [[ -z "$OPTION" || "$OPTION" != "--open-not" ]]; then
    cd "$DIR" || retrun 1
  fi

  if command -v tree >/dev/null 2>&1; then
    tree -C
  else
    echo "tree command not found"
  fi
}

create_fn() {
  if [ -n "$TARGET" ]; then
    touch $TARGET
  else
    echo "You need to add the name of the file you want to create"
  fi
}

run_fn() {
  if [ -e "main.c" ]; then
    echo "Running project in ${PWD}..."
   
    if [ -n "$OPTION"]; then
     gcc main.c $OPTION -o "$TARGET"
    else
     gcc main.c -o "$TARGET"
    fi
    
    if [ $? -e 0 ]; then
      ./"$TARGET"
      if [ $? -eq 0 ]; then
        echo "Project execution finished"
      else
        echo "Project execution failed"
      fi
    else
      echo "Compilation failed"
    fi
  else
    echo "main.c not found"  
  fi      
}

config_fn() {
  echo no config for now
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
  *) echo "there is nothing to do"
esac
