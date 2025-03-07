export JAVA_HOME=/usr/lib/jvm/java-17-openjdk/
export ANDROID_HOME=/home/usama/android-sdk/
if status is-interactive
    # Commands to run in interactive sessions can go here
end
fish_vi_key_bindings


if not set -q DISPLAY; and test "$XDG_VTNR" = 1
    exec startx 
end


set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
alias c clear
alias m make
alias p pwd
alias sudo sudo
