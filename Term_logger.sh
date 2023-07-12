#! /usr/bin/env bash

# =============================================================================
#
#   name:   Term_logger.sh
#   auth:   ted craig
#
#   desc:   Provides basic formatting for strings printed to the terminal.
#           Created for use in simple testing/debug logging.
#
#   dependancies: ttui_lib.sh
#
#   note:   Developed and tested on MacOs Ventura using bash v3.2.57(1)-release
#
# =============================================================================

# -----------------------------------------------------------------------------
# Imports
# -----------------------------------------------------------------------------
[[ "${TTUI_LOADED}" != "true" ]] && {
  source /opt/ttui/ttui_lib.sh
}

# -----------------------------------------------------------------------------
# Prints text surrounded by a box.
# Box color and text color may be specified.
# Text may be centered, left justified, right justified.
# Box size may be specified.
# Globals:
#   TBD
# Arguments:
#   position 1: title string
#   position 2: bottom line number (positive int) inclusive
# -----------------------------------------------------------------------------
##  Creates a box surrounding text
##  box color and text color may be specified
##  text can be centered, left justified, right justified
tlog::title_box() {
  args=("$@")
  # echo "args: ${args[@]}"
  # echo "num args: ${#args[@]}"

  local _TITLE=
  local _TITLE_COLOR=none
  local _BOX_COLOR=none
  local _BOX_WIDTH=none
  local _BOX_HEIGHT=3
  local _PAD_HORIZONTAL=1
  local _PAD_VERTICAL=0

  local _PROP=
  local _VAL=

  for arg in ${args[@]}; do
    # echo "arg: ${arg}"
    _PROP=${arg%=*}
    _VAL=${arg#*=}
    # echo "_PROP: ${_PROP}"
    
    case ${_PROP} in
            title)
                # echo "title: ${_VAL}"
                # echo "title: ${_VAL_W_SPACES}"
                local _VAL_WITH_SPACES=${_VAL//_/' '} # swap all underscores with spaces
                _TITLE="${_VAL_WITH_SPACES}"
                ;;
            title_color) 
                # echo "title_color: ${_VAL}"
                local _RGB_COLOR=${_VAL//,/' '}
                _TITLE_COLOR="${_RGB_COLOR}"
                ;;
            box_color)
                local _RGB_COLOR=${_VAL//,/' '}
                _BOX_COLOR="${_RGB_COLOR}"
                ;;
            box_width) 
                # echo "box_width: ${_VAL}"
                _BOX_WIDTH="${_VAL}"
                ;;
            box_height) 
                # echo "box_height: ${_VAL}"
                _BOX_HEIGHT="${_VAL}"
                ;;
            pad_vertical) 
                # echo "box_height: ${_VAL}"
                _PAD_VERTICAL="${_VAL}"
                ;;
            pad_horizontal) 
                # echo "box_height: ${_VAL}"
                _PAD_HORIZONTAL="${_VAL}"
                ;;
            *) echo "Unknown parameter passed: ${_PROP}"
                # exit 1
                ;;
    esac
  done

  ## if box_width = none, then fit the box to the width of the title
  local title_length=${#_TITLE}
  # echo "title_length: $title_length"
  
  local box_pad_horizontal=$((_PAD_HORIZONTAL + _PAD_HORIZONTAL + 2))
  local box_pad_vertical=$((_PAD_VERTICAL + _PAD_VERTICAL + 2))

  if [[ ${_BOX_WIDTH} == "none" ]]; then
    _BOX_WIDTH=$(( title_length + box_pad_horizontal ))  
  elif [[ ${_BOX_WIDTH} -lt $((title_length + box_pad_horizontal)) ]]; then
    _BOX_WIDTH=$(( title_length + box_pad_horizontal ))
  fi

  if [[ ${_BOX_HEIGHT} == "none" ]]; then
    _BOX_HEIGHT=$(( 1 + box_pad_vertical ))  
  elif [[ ${_BOX_HEIGHT} -lt $((1 + box_pad_vertical)) ]]; then
    _BOX_HEIGHT=$(( 1 + box_pad_vertical ))
  fi

  ## if title_color = none, then skip setting a color

  ## if box_color = none, then skip setting a color

  # echo "title:          ${_TITLE}"
  # echo "title_color:    ${_TITLE_COLOR}"
  # echo "box_color:      ${_BOX_COLOR}"
  # echo "box_width:      ${_BOX_WIDTH}"
  # echo "box_height:     ${_BOX_HEIGHT}"
  # echo "pad_horizontal: ${_PAD_HORIZONTAL}"
  # echo "pad_vertical:   ${_PAD_VERTICAL}"

  ## print the vertical padding
  for ((i=0; i < _BOX_HEIGHT; i++)); do
    echo
  done
  
  ## move cursor to the middle in prep for printing title
  ttui::cursor::move_up $((_PAD_VERTICAL + 2))
  ## print left horizontal pad
  printf -vch  "%$((_PAD_HORIZONTAL + 1))s" ""
  printf "%s" "${ch// / }"
  ## print the title
  ttui::color::set_color_to_rgb ${_TITLE_COLOR}
  printf "%s" "${_TITLE}"
  ## print right horizontal pad
  printf -vch  "%$((_PAD_HORIZONTAL + 1))s" ""
  printf "%s" "${ch// / }"
  ttui::cursor::move_to_bottom
  ttui::cursor::move_left 999
  ttui::cursor::move_up ${_BOX_HEIGHT}
  ttui::color::set_color_to_rgb ${_BOX_COLOR}
  ttui::draw_box ${_BOX_WIDTH} ${_BOX_HEIGHT}
  # ttui::cursor::move_to_bottom
  ttui::color::reset
}