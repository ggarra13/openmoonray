# No hashbang - should be sourced

function ResolvePath() {
    (cd "$1" > /dev/null; pwd -P)
}


this_dir="$(ResolvePath "$(dirname "${BASH_SOURCE[0]}")")"

source $this_dir/../openmoonray/scripts/setup.sh

export USD_PYTHON_DEPS_DIR="$(ResolvePath "${this_dir}/../pip-packages")"
export USD_PYTHON_DIR="$(ResolvePath "${this_dir}/../python")"
export PATH="$USD_PYTHON_DIR/bin:$USD_PYTHON_DEPS_DIR/bin${PATH:+:${PATH}}"

echo "PATH=$PATH"
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
echo "PYTHONPATH=$PYTHONPATH"
echo "USD_PYTHON_DEPS_DIR=$USD_PYTHON_DEPS_DIR"
echo "USD_PYTHON_DIR=$USD_PYTHON_DIR"
