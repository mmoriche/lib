
manage_submodule() {
  local module_path="$1"
  local action="$2"

  if [[ -z "$module_path" || -z "$action" ]]; then
    echo "Usage: manage_submodule <submodule_path> <init|deinit>"
    return 1
  fi

  case "$action" in
    init)
      echo "Initializing submodule: $module_path"
      #git submodule update --init --remote --recursive -- "$module_path"
      git submodule update --init "$module_path"
      cd "$module_path" || { echo "Error: Cannot enter $module_path"; return 1; }
      #git checkout main || git checkout -b main origin/main
      git checkout main 
      git pull origin main
      cd - > /dev/null
      ;;
    
    deinit)
      echo "Deinitializing submodule: $module_path"
      git submodule deinit -f "$module_path"
      rm -rf ".git/modules/$module_path"
      ;;
    
    *)
      echo "Invalid action: $action"
      echo "Usage: manage_submodule <submodule_path> <init|deinit>"
      return 1
      ;;
  esac
}

