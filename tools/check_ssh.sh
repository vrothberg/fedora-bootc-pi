#!bash
set -e
if grep -q 'key = ""' config.toml; then
	echo "Please add your public SSH key to the config.toml!"
	exit 1
fi
