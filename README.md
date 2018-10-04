## dotfiles

[![Travis CI](https://travis-ci.org/kuzeko/dotfiles.svg?branch=master)](https://travis-ci.org/kuzeko/dotfiles)

### To install:

```console
$ make
```

This will create symlinks from this repo to your home folder.

This repo contains also files/configurations to be deployed globally in the `etc` directory.
They may be dangerous for your system, please review the contents in the `etc/`folder before proceeding (e.g., check `etc/ssh/`).

If you want to proceed go with:

```console
$ make etc
```


### To customize:

Save env vars, etc in a `.extra` file, that looks something like
this:

```bash
###
### Git credentials
###

GIT_AUTHOR_NAME="Your Name"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="email@you.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
GH_USER="nickname"
git config --global github.user "$GH_USER"

###
### Gmail credentials for mutt
###
export GMAIL=email@you.com
export GMAIL_NAME="Your Name"
export GMAIL_FROM=from-email@you.com
```

### Here be Dragons

This repo is full of features, opinionated confings, scripts, and functions.
I've broken a couple of them after forking (see the `/etc` case).
Each file is fairly documented, if you can understand what the comment is saying.

Things may break unexpectedly because some file somewhere in this repo is overriding some default, you are warned.
Yet, a lot of useful things are introduced, you should really look around (maybe on the original repo).
Every time I do it, I learn something new!

#### `.vim`

For `jessfraz` `.vimrc` and `.vim` dotfiles see
[github.com/jessfraz/.vim](https://github.com/jessfraz/.vim).


#### `.nanorc`

This repo embeds conf files for `nano`.
Yes, I'm not taking any part in the ``Editor War'': when I code, I don't do it in a terminal.


### Tests

The tests use [shellcheck](https://github.com/koalaman/shellcheck). You don't
need to install anything. They run in a container.

```console
$ make test
```
