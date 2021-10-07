# dlamotte's modifications on top of agnoster theme
#
# --------------------------------------------------------------------------
#
# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
# inspired by https://github.com/mitsuhiko/dotfiles/blob/master/zsh/custom/themes/mitsuhiko.zsh-theme
_PROMPT_ASYNC=0
_PROMPT_ASYNC_PID=0
_PROMPT_ASYNC_RETVAL=
_PROMPT_ASYNC_PROMPT="${TMPDIR-/tmp}/.zsh_tmp_prompt_$$"
_PROMPT_ASYNC_RPS1="${TMPDIR-/tmp}/.zsh_tmp_rps1_$$"

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  LSEGMENT_SEPARATOR=$'\ue0b0'
  RSEGMENT_SEPARATOR=$'\ue0b2'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg

  if [[ $SEGMENT_SIDE = 'left' ]]; then
    [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
    [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    SEGMENT_SEPARATOR=$LSEGMENT_SEPARATOR
    if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
      echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
    else
      echo -n "%{$bg%}%{$fg%} "
    fi

  elif [[ $SEGMENT_SIDE = 'right' ]]; then
    [[ -n $1 ]] && bgc="$1" || bgc="default"
    [[ -n $2 ]] && fgc="$2" || fgc="default"
    SEGMENT_SEPARATOR=$RSEGMENT_SEPARATOR
    echo -n " %{%F{$bgc}%}$SEGMENT_SEPARATOR%{%F{$fgc}%K{$bgc}%} "
  fi

  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
  fi
}

prompt_aws_profile() {
    local region=${AWS_REGION-$AWS_DEFAULT_REGION}

    if [[ -n "$AWS_PROFILE" ]]; then
        bg=cyan
        fg=black
        if [[ -n ${AWS_PROFILE_BG[$AWS_PROFILE]} ]]; then
            bg=${AWS_PROFILE_BG[$AWS_PROFILE]}
            if [[ $bg == "red" ]]; then
                fg=white
            fi
        fi
        prompt_segment $bg $fg "☁ $AWS_PROFILE${region+ }${region}"
    fi
}

prompt_jira_issue() {
    if [[ -n "$JIRA_ISSUE" ]]; then
        prompt_segment blue white "$JIRA_ISSUE"
    fi
}

prompt_where_i_am() {
    prompt_segment black
    echo -n "%m "
}

prompt_vault() {
    whoami=$(vault token lookup -format json 2>/dev/null | jq .data.meta.role -r)
    if [[ $whoami == "admin" ]]; then
        prompt_segment red white "🔒 admin"
    fi
}

prompt_git_user() {
    if $(git rev-parse --is-inside-work-tree &>/dev/null); then
        repo_user="$(git config --local user.email | sed 's/[^@]*//')"
        if [[ -n $repo_user ]]; then
            prompt_segment cyan black $repo_user
        fi
    fi
}

# Git: branch/detached head, dirty status
prompt_git() {

  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

prompt_hg() {
  local rev status
  if $(hg id &>/dev/null </dev/null); then
    if $(hg prompt &>/dev/null </dev/null); then
      if [[ $(hg prompt "{status|unknown}" </dev/null) = "?" ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt "{status|modified}" </dev/null) ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green black
      fi
      echo -n $(hg prompt "☿ {rev}@{branch}" </dev/null) $st
    else
      st=""
      rev=$(hg id -n 2>/dev/null </dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null </dev/null)
      if `hg st </dev/null | grep -q "^\?"`; then
        prompt_segment red black
        st='±'
      elif `hg st </dev/null | grep -q "^[MA]"`; then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue black '%1~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "(`basename $virtualenv_path`)"
  fi
}

prompt_kube_namespace() {
  if [[ -n $KUBECTL_CONTEXT || -n $KUBECTL_NAMESPACE ]]; then
    prompt_segment cyan black "☸ $(echo $KUBECTL_CONTEXT | perl -npe 's/^(.{6}).*(.{4})$/$1+$2/')/$KUBECTL_NAMESPACE"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘ $RETVAL"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=${_PROMPT_ASYNC_RETVAL-$?}
  SEGMENT_SIDE=left
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_kube_namespace
  prompt_end
}

build_rps1() {
  SEGMENT_SIDE=right
  if [[ $_PROMPT_ASYNC = 1 ]]; then
    prompt_vault
    prompt_hg
    prompt_git
    prompt_git_user
  fi
  prompt_jira_issue
  prompt_aws_profile
  prompt_where_i_am
}

_prompt_precmd() {
  _PROMPT_ASYNC_RETVAL=$?
  PROMPT='%{%f%b%k%}$(build_prompt) '
  RPS1='%{%f%b%k%}$(build_rps1)'

  prompt_async() {
    _PROMPT_ASYNC=1
    build_prompt &>! $_PROMPT_ASYNC_PROMPT
    build_rps1 &>! $_PROMPT_ASYNC_RPS1
    kill -USR1 $$
  }

  if [[ $_PROMPT_ASYNC_PID != 0 ]]; then
    kill $_PROMPT_ASYNC_PID &>/dev/null
  fi

  prompt_async &!
  _PROMPT_ASYNC_PID=$!
}

_prompt_zshexit() {
  rm -f $_PROMPT_ASYNC_PROMPT
  rm -f $_PROMPT_ASYNC_RPS1
}

_prompt_async_trapusr1() {
  PROMPT="%{%f%b%k%}$(cat $_PROMPT_ASYNC_PROMPT 2>/dev/null) "
  RPS1="%{%f%b%k%}$(cat $_PROMPT_ASYNC_RPS1 2>/dev/null)"
  _PROMPT_ASYNC_PID=0
  zle && zle reset-prompt
}

precmd_functions+=(_prompt_precmd)
zshexit_functions+=(_prompt_zshexit)
trap '_prompt_async_trapusr1' USR1
