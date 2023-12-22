# No hashbang - should be sourced

this_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)"

if [ -f "${this_dir}/set_usd_python_env.sh" ]; then
    source "${this_dir}/set_usd_python_env.sh"
fi

export USD_INSTALL_DIR="$(dirname "${this_dir}")"

export PATH="$USD_INSTALL_DIR/bin${PATH:+:${PATH}}"

export PXR_MTLX_STDLIB_SEARCH_PATHS="$USD_INSTALL_DIR/libraries"

echo "Activated USD python/tools from" $USD_INSTALL_DIR
