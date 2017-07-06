for fn in ~/.zshenv.d/*; do
    source $fn
done

if [[ -e ~/.zshenv.secrets ]]; then
    source ~/.zshenv.secrets
fi
