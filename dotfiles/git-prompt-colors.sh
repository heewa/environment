override_git_prompt_colors() {
  GIT_PROMPT_THEME_NAME="Emoji"

  # Nerd Font Symbols
  NF_X=$'\uf00d'
  NF_CHECK=$'\uf00c'
  NF_PLUS=$'\uf44d'
  NF_PLUS_CIRCLED=$'\uf055'
  NF_FLAG=$'\Uf0240'
  NF_BOOKMARK=$'\uf02e'
  NF_PIN=$'\Uf0403'
  NF_MENU=$'\ueb94'
  NF_PENCIL=$'\Uf064f'
  NF_QUESTION=$'\uf128'
  NF_COMMIT_LOCAL=$'\Uf071b'
  NF_LINK=$'\uf0c1'
  NF_BROKEN_LINK=$'\uf127'
  NF_BRANCH=$'\Uf062c'
  NF_CURVED_OPEN=$'\ue0b7'
  NF_CURVED_CLOSE=$'\ue0b5'
  NF_ANGLED_OPEN=$'\ue0b3'
  NF_ANGLED_CLOSE=$'\ue0b1'
  NF_DOTTED_VERT=$'\ue621'
  NF_DOWN=$'\ue340'
  NF_UP=$'\ue353'

  # Heewa: show seconds in time
  #Time12a="\$(date +%H:%M:%S)"
  # PathShort="\w";

  ## These are the color definitions used by gitprompt.sh
  GIT_PROMPT_PREFIX=""                 # start of the git info string
  GIT_PROMPT_SUFFIX=""                 # the end of the git info string
  GIT_PROMPT_SEPARATOR="${NF_DOTTED_VERT}"              # separates each item

  GIT_PROMPT_BRANCH="${Magenta}${NF_BRANCH} "        # the git branch that is active in the current directory
  GIT_PROMPT_STAGED="${Green}${NF_PLUS_CIRCLED}"   # the number of staged files/directories
  GIT_PROMPT_CONFLICTS="${BoldRed}${NF_X} "           # the number of files in conflict
  GIT_PROMPT_CHANGED=" ${BoldYellow}${NF_PENCIL} "         # the number of changed files

  # GIT_PROMPT_REMOTE=" "                 # the remote branch name (if any) and the symbols for ahead and behind
  GIT_PROMPT_UNTRACKED=" ${Red}${NF_QUESTION} "       # the number of untracked files/dirs
  GIT_PROMPT_STASHED=" ${White}${NF_PIN}"    # the number of stashed files/dir
  GIT_PROMPT_CLEAN="${BoldGreen}${NF_CHECK} "      # a colored flag indicating a "clean" repo

  ## For the command indicator, the placeholder _LAST_COMMAND_STATE_ 
  ## will be replaced with the exit code of the last command
  ## e.g.
  GIT_PROMPT_COMMAND_OK=""    # indicator if the last command returned with an exit code of 0
  GIT_PROMPT_COMMAND_FAIL="${Red}${NF_X} _LAST_COMMAND_STATE_${ResetColor} "    # indicator if the last command returned with an exit code of other than 0

  ## template for displaying the current virtual environment
  ## use the placeholder _VIRTUALENV_ will be replaced with 
  ## the name of the current virtual environment (currently CONDA and VIRTUAL_ENV)
  # GIT_PROMPT_VIRTUALENV="(${Blue}_VIRTUALENV_${ResetColor}) "

  # template for displaying the current remote tracking branch
  # use the placeholder _UPSTREAM_ will be replaced with
  # the name of the current remote tracking branch
  # GIT_PROMPT_UPSTREAM=" {${Blue}_UPSTREAM_${ResetColor}}"

  ## _LAST_COMMAND_INDICATOR_ will be replaced by the appropriate GIT_PROMPT_COMMAND_OK OR GIT_PROMPT_COMMAND_FAIL
  GIT_PROMPT_START_USER="_LAST_COMMAND_INDICATOR_${Yellow}${PathShort}${ResetColor}"
  GIT_PROMPT_START_ROOT="_LAST_COMMAND_INDICATOR_${GIT_PROMPT_START_USER}"
  GIT_PROMPT_END_USER="${ResetColor}) "
  GIT_PROMPT_END_ROOT="${Red}#${ResetColor} "

  ## Please do not add colors to these symbols
  GIT_PROMPT_SYMBOLS_AHEAD="${NF_UP}"             # The symbol for "n versions ahead of origin"
  GIT_PROMPT_SYMBOLS_BEHIND="${NF_DOWN}"            # The symbol for "n versions behind of origin"
  # GIT_PROMPT_SYMBOLS_PREHASH=":"            # Written before hash of commit, if no name could be found
  GIT_PROMPT_SYMBOLS_NO_REMOTE_TRACKING="${NF_BROKEN_LINK} " # This symbol is written after the branch, if the branch is not tracked 
}

reload_git_prompt_colors "Emoji"
