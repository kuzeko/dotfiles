# Using these dotfiles on a shared server account

Some servers have one Linux account, such as `ubuntu`, that several people
log into. Everyone on it shares the same home directory, shell setup and git
configuration. This page covers installing the dotfiles there and working on
the account without stepping on each other.

## Installing, once per server

Log in as the shared account. Server images often lack `make`, so install
the prerequisites first (Debian and Ubuntu):

```console
sudo apt-get update
sudo apt-get install -y git make gnupg screen htop unzip
```

Then clone the repository and check that nothing is missing:

```console
git clone https://github.com/kuzeko/dotfiles.git
cd dotfiles
git checkout -b local
make requirements
```

`make requirements` names each missing command, or prints "All required
commands are installed." It also suggests Docker when it is missing; the
dotfiles work without it. If you install it, note that adding the shared
account to the `docker` group gives everyone on it root-equivalent access.
Install whatever it names as required, then run:

```console
make dotfiles
```

Log out and back in. The prompt changes to two lines, with the host name
followed by ⚡️ on a virtual machine. If it does not, check that
`~/.bash_profile`, `~/.bashrc` and `~/.bash_prompt` are symlinks into the
clone.

On Linux, `make` defaults to `PROFILE=server`: shell and git configuration
only, without the X11 and i3 files or the `.dockerfunc` container wrappers.
It also writes `~/.gitconfig` as a file that includes the repository's
`.gitconfig`, refuses to commit without an identity, and turns commit signing
off.

Run `make dotfiles` only. Plain `make` also links the `bin/` scripts into
`/usr/local/bin` with sudo, and `make etc` replaces system files such as
`/etc/ssh/sshd_config`.

Leave `.extra` as the template it is in the repository: whatever goes in it
applies to everyone on the account.

To update the server after a change is merged on `main`:

```console
cd ~/dotfiles
git fetch origin
git merge --ff-only origin/main
```

## Connecting

```console
ssh ubuntu@<server>
```

To push or pull private repositories over SSH from the server, forward your
agent instead of copying a key to it:

```console
ssh -A ubuntu@<server>
```

While you are connected with `-A`, anyone else logged into the same account
can use your forwarded agent. Disconnect when you are done. Never copy a
private key to the server, and never run `make keygen` there: a key in the
shared home belongs to everyone who logs in.

## Your git identity

Once, store your name and email under a short name of your choice, one per
line:

```console
mkdir -p ~/.iam
printf '%s\n' "Your Name" you@example.com > ~/.iam/<short-name>
```

Then, after each login and before your first commit:

```console
iam <short-name>
```

`iam "Your Name" you@example.com` also works without the file. Run `iam`
alone to list the short names already stored. The identity lasts until you
log out and is visible to your session only. Without it, git stops with
"Author identity unknown".

Never run `git config --global user.name` or `user.email` on the server, nor
`git config user.*` inside a shared clone: both set the identity for everyone
who commits there afterwards.

Commits made on the server are unsigned.

## Sharing the account

- Bash history is shared. Never type a password or token on the command line.
- Work in a `screen` or `tmux` session of your own, and run `iam` before
  starting it: every window in it then has your identity, it survives a
  dropped connection, and reattaching saves typing `iam` again.

  With screen:

  ```console
  screen -S <your-name>
  screen -r <your-name>
  ```

  With tmux, always pass `-L <your-name>`. Without it, everyone on the
  account shares one tmux server, and a new session can inherit the git
  identity of whoever started that server:

  ```console
  tmux -L <your-name> new -s <your-name>
  tmux -L <your-name> attach
  ```

- Change the dotfiles through a pull request on the repository, not by editing
  `~/dotfiles` on the server. The update steps above then bring it in.
