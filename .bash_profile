#!/bin/bash

# Load .bashrc and other files...
for file in ~/.{functions,bashrc,bash_prompt,aliases,path,dockerfunc,extra,exports}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done
unset file
