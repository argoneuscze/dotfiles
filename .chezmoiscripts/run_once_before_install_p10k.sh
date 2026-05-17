#!/usr/bin/env bash

P10K_DIR="$HOME/.local/share/powerlevel10k"

if [ ! -d "$P10K_DIR" ]; then
    echo "Installing Powerlevel10k"
    mkdir -p "$(dirname "P10K_DIR")"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

