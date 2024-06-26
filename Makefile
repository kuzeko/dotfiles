.PHONY: all
all: bin dotfiles requirements config ## Installs the bin directory files and the dotfiles but not etc because they are dangerous.

.PHONY: bin
bin: ## Installs the bin directory files.
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name "*-backlight" -not -name ".*.swp"); do \
		if ! grep -qFw "bin/$$file" $(CURDIR)/.excludes; then \
			f=$$(basename $$file); \
			sudo ln -sf $$file /usr/local/bin/$$f; \
		fi \
	done

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	# Clean any macOs DS_Store file first
	find . -type f -name '*.DS_Store' -ls -delete
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".travis.yml" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	gpg --list-keys || true;
	ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
	ln -sfn $(CURDIR)/.gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf;
	ln -fn $(CURDIR)/gitignore $(HOME)/.gitignore;
	ln -sfn $(CURDIR)/.gittemplates $(HOME)/.gittemplates;
	git update-index --skip-worktree $(CURDIR)/.gitconfig;
	mkdir -p $(HOME)/.config;
	ln -snf $(CURDIR)/.i3 $(HOME)/.config/sway;
	mkdir -p $(HOME)/.local/share;
	ln -snf $(CURDIR)/.fonts $(HOME)/.local/share/fonts;
	ln -snf $(CURDIR)/.bash_profile $(HOME)/.profile;
	if [ -f /usr/local/bin/pinentry ]; then \
		sudo ln -snf /usr/bin/pinentry /usr/local/bin/pinentry; \
	fi;
	#mkdir -p $(HOME)/Pictures;
	#ln -snf $(CURDIR)/central-park.jpg $(HOME)/Pictures/central-park.jpg;
	@echo '.extra' >> .gitignore

.PHONY: etc
etc: ## Installs the etc directory files.
	sudo mkdir -p /etc/docker/seccomp
	for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo mkdir -p $$(dirname $$f); \
		sudo ln -f $$file $$f; \
	done
	systemctl --user daemon-reload || true
	sudo systemctl daemon-reload

	# https://github.com/systemd/systemd/issues/9450
	if [ -f /run/systemd/resolve/stub-resolv.conf ]; then \
		sudo ln -snf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf \
	fi

.PHONY: keygen
keygen: ## Generates SSH key if this is not already present.
	mailaddr=$$(grep -e 'export GMAIL=' .extra | sed -e 's|export GMAIL=||'); \
	echo "Mail address set to $$mailaddr in .extra"; \
	ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C  $$(echo $$mailaddr)


.PHONY: requirements
requirements: ## Checks for commands to be installed.
	is_ubuntu=$$( grep -q "Ubuntu" /etc/*release &> /dev/null && cat /etc/*release | grep ^VERSION | tr -d 'VERSION="' | head -c 2); \
	for cmd in 'mapfile' 'screen' 'htop' 'gpg-connect-agent' 'docker' 'xclip' 'unzip'; do \
		command -v $$cmd >/dev/null 2>&1 || { echo >&2 "$$cmd it's not installed."; } \
	done
	@## && [ $$cmd = docker ] && [ $$(echo $$is_ubuntu) -lt 17 ] && { echo "use the install_docker.md"; } ];\
	ls $(HOME)/.ssh/id_* >/dev/null 2>&1 || echo "You need to setup SSH keys, use make keygen";

.PHONY: config
config: ## Shows how to configure basic stuff
	@echo "Configure .excludes file";
	@echo "";
	@sed -e 's/# //' .excludes;
	@echo "";
	@echo "Configure .extra file"
	@echo "";
	@sed -e 's/# //' .extra;

.PHONY: test
test: shellcheck ## Runs all the tests on the files in the repository.

# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

.PHONY: shellcheck
shellcheck: ## Runs the shellcheck tests on the scripts.
	docker run --rm -i $(DOCKER_FLAGS) \
		--name df-shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		r.j3ss.co/shellcheck ./test.sh

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
