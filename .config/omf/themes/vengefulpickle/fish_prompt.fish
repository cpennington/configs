# name: vengefulpickle
#
# vengefulpickle is a Powerline-style, Git-aware fish theme optimized for awesome,
# derived from bobthefish.
#
# vengefulpickle adds a path segment for the current virtualenv
#
# You will probably need a Powerline-patched font for this to work:
#
#     https://powerline.readthedocs.org/en/latest/fontpatching.html
#
# I recommend picking one of these:
#
#     https://github.com/Lokaltog/powerline-fonts
#
# You can override some default options in your config.fish:
#
#     set -g theme_display_user yes
#     set -g default_user your_normal_user

set -g __vengefulpickle_current_bg NONE

# Powerline glyphs
set __vengefulpickle_branch_glyph            \uE0A0
set __vengefulpickle_ln_glyph                \uE0A1
set __vengefulpickle_padlock_glyph           \uE0A2
set __vengefulpickle_right_black_arrow_glyph \uE0B0
set __vengefulpickle_right_arrow_glyph       \uE0B1
set __vengefulpickle_left_black_arrow_glyph  \uE0B2
set __vengefulpickle_left_arrow_glyph        \uE0B3

# Additional glyphs
set __vengefulpickle_detached_glyph          \u27A6
set __vengefulpickle_nonzero_exit_glyph      '! '
set __vengefulpickle_superuser_glyph         '# '
set __vengefulpickle_user_glyph              '$ '
set __vengefulpickle_bg_job_glyph            '% '

# Colors
set __vengefulpickle_lt_green   addc10
set __vengefulpickle_med_green  189303
set __vengefulpickle_dk_green   0c4801

set __vengefulpickle_lt_red     C99
set __vengefulpickle_med_red    ce000f
set __vengefulpickle_dk_red     600

set __vengefulpickle_slate_blue 255e87

set __vengefulpickle_lt_orange  f6b117
set __vengefulpickle_dk_orange  3a2a03

set __vengefulpickle_dk_grey    333
set __vengefulpickle_med_grey   999
set __vengefulpickle_lt_grey    ccc

# ===========================
# Helper methods
# ===========================

function __vengefulpickle_in_git -d 'Check whether pwd is inside a git repo'
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1
end

function __vengefulpickle_git_branch -d 'Get the current git branch (or commitish)'
  set -l ref (command git symbolic-ref HEAD 2> /dev/null)
  if [ $status -gt 0 ]
    set -l branch (command git show-ref --head -s --abbrev |head -n1 2> /dev/null)
    set ref "$__vengefulpickle_detached_glyph $branch"
  end
  echo $ref | sed  "s-refs/heads/-$__vengefulpickle_branch_glyph -"
end

function __vengefulpickle_pretty_parent -d 'Print a parent directory, shortened to fit the prompt'
  echo -n (dirname $argv[1]) | sed -e 's|/private||' -e "s|^$HOME|~|" -e 's-/\(\.\{0,1\}[^/]\)\([^/]*\)-/\1-g' -e 's|/$||'
end

function __vengefulpickle_project_dir -d 'Print the current git project base directory'
  command git rev-parse --show-toplevel 2>/dev/null
end

function __vengefulpickle_project_pwd -d 'Print the working directory relative to project root'
  set -l base_dir (__vengefulpickle_project_dir)
  echo "$PWD" | sed -e "s*$base_dir**g" -e 's*^/**'
end


# ===========================
# Segment functions
# ===========================

function __vengefulpickle_start_segment -d 'Start a prompt segment'
  set_color -b $argv[1]
  set_color $argv[2]
  if [ "$__vengefulpickle_current_bg" = 'NONE' ]
    # If there's no background, just start one
    echo -n ' '
  else
    # If there's already a background...
    if [ "$argv[1]" = "$__vengefulpickle_current_bg" ]
      # and it's the same color, draw a separator
      echo -n "$__vengefulpickle_right_arrow_glyph "
    else
      # otherwise, draw the end of the previous segment and the start of the next
      set_color $__vengefulpickle_current_bg
      echo -n "$__vengefulpickle_right_black_arrow_glyph "
      set_color $argv[2]
    end
  end
  set __vengefulpickle_current_bg $argv[1]
end

function __vengefulpickle_path_segment -d 'Display a shortened form of a directory'
  if test -w "$argv[1]"
    __vengefulpickle_start_segment $__vengefulpickle_dk_grey $__vengefulpickle_med_grey
  else
    __vengefulpickle_start_segment $__vengefulpickle_dk_red $__vengefulpickle_lt_red
  end

  set -l directory
  set -l parent

  switch "$argv[1]"
    case /
      set directory '/'
    case "$HOME"
      set directory '~'
    case '*'
      set parent    (__vengefulpickle_pretty_parent "$argv[1]")
      set parent    "$parent/"
      set directory (basename "$argv[1]")
  end

  test "$parent"; and echo -n -s "$parent"
  set_color fff --bold
  echo -n "$directory "
  set_color normal
end

function __vengefulpickle_finish_segments -d 'Close open prompt segments'
  if [ -n $__vengefulpickle_current_bg -a $__vengefulpickle_current_bg != 'NONE' ]
    set_color -b normal
    set_color $__vengefulpickle_current_bg
    echo -n "$__vengefulpickle_right_black_arrow_glyph "
    set_color normal
  end
  set -g __vengefulpickle_current_bg NONE
end


# ===========================
# Theme components
# ===========================

function __vengefulpickle_prompt_status -d 'Display symbols for a non zero exit status, root and background jobs'
  set -l nonzero
  set -l superuser
  set -l bg_jobs

  # Last exit was nonzero
  if [ $RETVAL -ne 0 ]
    set nonzero $RETVAL
  end

  # if superuser (uid == 0)
  set -l uid (id -u $USER)
  if [ $uid -eq 0 ]
    set user $__vengefulpickle_superuser_glyph
  else
    set user $__vengefulpickle_user_glyph
  end

  # Jobs display
  if [ (jobs -l | wc -l) -gt 0 ]
    set bg_jobs $__vengefulpickle_bg_job_glyph
  end

  if test "$nonzero" -o "$bg_jobs"
    __vengefulpickle_start_segment fff 000
    if [ "$nonzero" ]
      set_color $__vengefulpickle_med_red --bold
      echo -n $__vengefulpickle_nonzero_exit_glyph
      echo -n $nonzero
    end

    if [ "$bg_jobs" ]
      set_color $__vengefulpickle_slate_blue --bold
      echo -n $bg_jobs
    end

    set_color normal
  end

  __vengefulpickle_start_segment $__vengefulpickle_dk_grey $__vengefulpickle_lt_orange
  echo -n $user
end

function __vengefulpickle_prompt_user -d 'Display actual user if different from $default_user'
  if [ "$theme_display_user" = 'yes' ]
    if [ "$USER" != "$default_user" -o -n "$SSH_CLIENT" ]
      __vengefulpickle_start_segment $__vengefulpickle_lt_grey $__vengefulpickle_slate_blue
      echo -n -s (whoami) '@' (hostname | cut -d . -f 1) ' '
    end
  end
end

# TODO: clean up the fugly $ahead business
function __vengefulpickle_prompt_git -d 'Display the actual git state'
  set -l dirty   (command git diff --no-ext-diff --quiet --exit-code; or echo -n '*')
  set -l staged  (command git diff --cached --no-ext-diff --quiet --exit-code; or echo -n '~')
  set -l stashed (command git rev-parse --verify refs/stash > /dev/null 2>&1; and echo -n '$')
  set -l ahead   (command git branch -v 2> /dev/null | grep -Eo '^\* [^ ]* *[^ ]* *\[[^]]*\]' | grep -Eo '\[[^]]*\]$' | awk 'ORS="";/ahead/ {print "+"} /behind/ {print "-"}' | sed -e 's/+-/±/')

  set -l new (command git ls-files --other --exclude-standard);
  test "$new"; and set new '…'

  set -l flags   "$dirty$staged$stashed$ahead$new"
  test "$flags"; and set flags " $flags"

  set -l flag_bg $__vengefulpickle_lt_green
  set -l flag_fg $__vengefulpickle_dk_green
  if test "$dirty" -o "$staged"
    set flag_bg $__vengefulpickle_dk_red
    set flag_fg fff
  else
    if test "$stashed"
      set flag_bg $__vengefulpickle_lt_orange
      set flag_fg $__vengefulpickle_dk_orange
    end
  end

  __vengefulpickle_path_segment (__vengefulpickle_project_dir)

  __vengefulpickle_start_segment $flag_bg $flag_fg
  set_color $flag_fg --bold
  echo -n -s (__vengefulpickle_git_branch) $flags ' '
  set_color normal

  set -l project_pwd  (__vengefulpickle_project_pwd)
  if test "$project_pwd"
    if test -w "$PWD"
      __vengefulpickle_start_segment $__vengefulpickle_dk_grey $__vengefulpickle_med_grey
    else
      __vengefulpickle_start_segment $__vengefulpickle_med_red $__vengefulpickle_lt_red
    end

    echo -n -s $project_pwd ' '
  end
end

function __vengefulpickle_prompt_dir -d 'Display a shortened form of the current directory'
  __vengefulpickle_path_segment "$PWD"
end

function __vengefulpickle_prompt_virtualenv -d 'Display a segment for the active virtualenv'
  if set -q VIRTUAL_ENV
    __vengefulpickle_start_segment $__vengefulpickle_slate_blue $__vengefulpickle_lt_grey
    echo -n -s (basename $VIRTUAL_ENV)
  end
end


# ===========================
# Apply theme
# ===========================

function fish_prompt -d 'vengefulpickle, a fish theme optimized for awesome'
  # First Line
  set -g RETVAL $status
  __vengefulpickle_prompt_user
  if __vengefulpickle_in_git
    __vengefulpickle_prompt_git
  else
    __vengefulpickle_prompt_dir
  end
  __vengefulpickle_prompt_virtualenv
  __vengefulpickle_finish_segments

  # Second Line
  echo
  __vengefulpickle_prompt_status
  __vengefulpickle_finish_segments
end
