#!/bin/bash

# Load .bashrc and other files...
for file in ~/.{functions,bashrc,bash_prompt,aliases,path,dockerfunc,extra,exports}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
        #echo "$file"
		source "$file"
	fi
done
unset file

export PATH="$HOME/.cargo/bin:$PATH"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/kuzeko/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
