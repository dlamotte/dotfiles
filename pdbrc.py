from pdb import DefaultConfig

class Config(DefaultConfig):
    # TODO apparently I need to convince something somewhere that it can write
    # utf8 to the terminal... get an exception when using \ue0b0 as a unicode
    # string or the raw byte in a regular string
    prompt = '\001\033[30;42m\002 pdb \001\033[32;44m\002\001\033[30;44m\002 >>> \001\033[34;49m\002 \001\033[0m\002'
    sticky_by_default = True
    editor = 'vim'
