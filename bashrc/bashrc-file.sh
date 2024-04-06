# Filename: ~/github/dotfiles-latest/bashrc/bashrc-file.sh

# #############################################################################
# Do not delete the `UNIQUE_ID` line below, I use it to backup original files
# so they're not lost when my symlinks are applied
# UNIQUE_ID=do_not_delete_this_line
# #############################################################################

boldGreen="\033[1;32m"
boldYellow="\033[1;33m"
boldRed="\033[1;31m"
boldPurple="\033[1;35m"
boldBlue="\033[1;34m"
noColor="\033[0m"

# Current number of entries Zsh is configured to store in memory (HISTSIZE)
# How many commands Zsh is configured to save to the history file (SAVEHIST)
# echo "HISTSIZE: $HISTSIZE"
# echo "SAVEHIST: $SAVEHIST"
# Store 10,000 entries in the command history
HISTFILE=~/.bash_history
HISTSIZE=10000
SAVEHIST=10000
# Check if the history file exists, if not, create it
if [[ ! -f $HISTFILE ]]; then
	touch $HISTFILE
	chmod 600 $HISTFILE
fi

# Common settings and plugins
alias ll='ls -lh'
alias lla='ls -alh'
alias python='python3'
# Shows the last 30 entries, default is 15
alias history='history -30'
alias v='nvim'

# kubernetes, if you need help, just run 'kgp --help' for example
alias k='kubectl'
alias kga='kubectl get all'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgpo='kubectl get pods -o wide'

# Detect OS
case "$(uname -s)" in
Darwin)
	OS='Mac'
	;;
Linux)
	OS='Linux'
	;;
*)
	OS='Other'
	;;
esac

# macOS-specific configurations
if [ "$OS" = 'Mac' ]; then

	# Starship
	# https://starship.rs/config/#prompt
	if command -v starship &>/dev/null; then
		export STARSHIP_CONFIG=$HOME/github/dotfiles-latest/starship-config/starship.toml
		eval "$(starship init bash)" >/dev/null 2>&1
	fi

	# ls replacement
	# exa is unmaintained, so now using eza
	# https://github.com/ogham/exa
	if command -v eza &>/dev/null; then
		alias ls='eza'
		alias ll='eza -lhg'
		alias lla='eza -alhg'
		alias tree='eza --tree'
	fi

	# Bat -> Cat with wings
	# https://github.com/sharkdp/bat
	if command -v bat &>/dev/null; then
		# --style=plain - removes line numbers and got modifications
		# --paging=never - doesnt pipe it through less
		alias cat='bat --paging=never --style=plain'
		alias catt='bat'
		alias cata='bat --show-all --paging=never'
	fi

	# Changed from z.lua to zoxide, as it's more maintaned
	# smarter cd command, it remembers which directories you use most
	# frequently, so you can "jump" to them in just a few keystrokes.
	# https://github.com/ajeetdsouza/zoxide
	# https://github.com/skywind3000/z.lua
	if command -v zoxide &>/dev/null; then
		eval "$(zoxide init bash)"

		alias cd='z'
		# Alias below is same as 'cd -', takes to the previous directory
		alias cdd='z -'

		#Since I migrated from z.lua, I can import my data
		# zoxide import --from=z "$HOME/.zlua" --merge

		# Useful commands
		# z foo<SPACE><TAB>  # show interactive completions
	fi

	# Initialize fzf if installed
	# https://github.com/junegunn/fzf
	# Useful commands
	# ctrl+r - command history
	# ctrl+t - search for files
	# ssh ::<tab><name> - shows you list of hosts in case don't remember exact name
	# kill -9 ::<tab><name> - find and kill a process
	# telnet ::<TAB>
	if [ -f ~/.fzf.bash ]; then

		# After installing fzf with brew, you have to run the install script
		# echo -e "y\ny\nn" | /opt/homebrew/opt/fzf/install

		source ~/.fzf.bash

		# Preview file content using bat
		export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"

		# Use :: as the trigger sequence instead of the default **
		export FZF_COMPLETION_TRIGGER='::'
	fi

fi