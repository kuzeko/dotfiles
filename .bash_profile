#!/bin/bash

# Load .bashrc, which loads: ~/.{functions,bash_prompt,aliases,path,dockerfunc,extra,exports}

if [[ -r "${HOME}/.bashrc" ]]; then
	# shellcheck source=/dev/null
	source "${HOME}/.bashrc"
fi

