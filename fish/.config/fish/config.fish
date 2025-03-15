set -a PATH ~/.local/bin/

if status is-interactive
	starship init fish | source
end
