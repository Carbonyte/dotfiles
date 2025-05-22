set -a PATH ~/.local/bin/

if status is-interactive
	set -gx STARSHIP_CACHE /tmp/.starship_cache
	starship init fish | source
end

alias eza="eza --group-directories-first --icons --time-style=long-iso --git -h"
alias ls="eza"
