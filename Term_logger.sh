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
#   Imports
# -----------------------------------------------------------------------------
[[ "${TTUI_LOADED}" != "true" ]] && {
  source /opt/ttui/ttui_lib.sh
}


# -----------------------------------------------------------------------------
#   Global Vars
# -----------------------------------------------------------------------------





tlog::set_default_title_color() {
  local R=$1
  local G=$2
  local B=$3
  export TLOG_DEFAULT_TITLE_COLOR="${R} ${G} ${B}"
}

tlog::unset_default_title_color() {
  unset TLOG_DEFAULT_TITLE_COLOR
}

tlog::set_default_title_box_color() {
  local R=$1
  local G=$2
  local B=$3
  export TLOG_DEFAULT_TITLE_BOX_COLOR="${R} ${G} ${B}"
}

tlog::unset_default_title_box_color() {
  unset TLOG_DEFAULT_TITLE_BOX_COLOR
}

tlog::set_default_warning_color() {
  local R=$1
  local G=$2
  local B=$3
  export TLOG_DEFAULT_WARNING_COLOR="${R} ${G} ${B}"
}

tlog::unset_default_warning_color() {
  unset TLOG_DEFAULT_WARNING_COLOR
}

tlog::set_default_info_color() {
  local R=$1
  local G=$2
  local B=$3
  export TLOG_DEFAULT_INFO_COLOR="${R} ${G} ${B}"
}

tlog::unset_default_info_color() {
  unset TLOG_DEFAULT_INFO_COLOR
}


# _TLOG_set_temp_text_color() {
#   local R=$1
#   local G=$2
#   local B=$3
#   export _TLOG_TEMP_TEXT_COLOR="${R} ${G} ${B}"
# }

# _TLOG_unset_temp_text_color() {
#   unset _TLOG_TEMP_TEXT_COLOR
# }

# _TLOG_update_text_color() {
#   if [ -z ${TLOG_DEFAULT_TEXT_COLOR+x} ]; then 
#     # no default text color
#     # so unset 
#     _TLOG_unset_temp_text_color
#   else 
#     # default text color is set
#     echo "$FUNCNAME default text color exists"
#   fi
# }


tlog::print::info() {
  local TEXT="$*"
  [[ -n "${TLOG_DEFAULT_INFO_COLOR}" ]] && {
    ttui::color::set_color_to_rgb "${TLOG_DEFAULT_INFO_COLOR}"
    echo "${TEXT}"
    ttui::color::reset
    return 0
  }
  echo "${TEXT}"
} 

tlog::print::warning() {
  local TEXT="$*"
  [[ -n "${TLOG_DEFAULT_WARNING_COLOR}" ]] && {
    ttui::color::set_color_to_rgb "${TLOG_DEFAULT_WARNING_COLOR}"
    echo "${TEXT}"
    ttui::color::reset
    return 0
  }
  echo "${TEXT}"
}

tlog::print::error() {
  local TEXT="$*"
  [[ -n "${TLOG_DEFAULT_ERROR_COLOR}" ]] && {
    ttui::color::set_color_to_rgb "${TLOG_DEFAULT_ERROR_COLOR}"
    echo "${TEXT}"
    ttui::color::reset
    return 0
  }
  echo "${TEXT}"
}

tlog::print::attention() {
  local TEXT="$*"
  [[ -n "${TLOG_DEFAULT_ATTENTION_COLOR}" ]] && {
    ttui::color::set_color_to_rgb "${TLOG_DEFAULT_ATTENTION_COLOR}"
    echo "${TEXT}"
    ttui::color::reset
    return 0
  }
  echo "${TEXT}"
}

tlog::print() {
  local PROP=
  local VAL=
  for arg in "$@"; do
    if [[ "${arg}" == *"="* ]]; then
      PROP=${arg%=*}
      VAL=${arg#*=}
      echo "PROP: ${PROP} | VAL: ${VAL}"
    else
      # assume to be text string since no = found
      echo "PROP: text | VAL: ${arg}"
    fi
  done

}

# -----------------------------------------------------------------------------
#   Prints text surrounded by a box.
#   Box color and text color may be specified.
#   Text may be centered, left justified, right justified.
#   Box size may be specified.
#
#   Globals:
#     TBD
#
#   Arguments: (in any order)
#     title=title_string_using_underscores_in_place_of_spaces
#     title_color=r,g,b
#     title_justification=centered|left|right
#     box_color=r,g,b
#     box_width=width
#     box_height=height
#     pad_vertical=verticalPaddingValue
#     pas_horizontal=horizontalPaddingValue
# -----------------------------------------------------------------------------
##  Creates a box surrounding text
##  box color and text color may be specified
##  text can be centered, left justified, right justified
tlog::print::title_box() {
  args=("$@")
  # echo "args: ${args[@]}"
  # echo "num args: ${#args[@]}"

  local _TITLE=
  local _TITLE_LENGTH=
  local _TITLE_COLOR="none"
  local _TITLE_JUSTIFICATION="centered"
  local _TITLE_START_COL=
  local _BOX_COLOR="none"
  local _BOX_WIDTH="none"
  local _BOX_HEIGHT=3
  local _BOX_JUSTIFICATION="left"
  local _BOX_START_COL=1
  local _PAD_HORIZONTAL=1
  local _PAD_VERTICAL=0
  local _PROP=
  local _VAL=

  for arg in "$@"; do

    [[ "${arg}" != *"="* ]] && {
      # assume this must be TITLE text if no '=' is found
      _TITLE="${arg}"
      _TITLE_LENGTH="${#_TITLE}"
      continue
    }

    # echo "arg: ${arg}"
    _PROP=${arg%=*}
    _VAL=${arg#*=}
    # echo "_PROP: ${_PROP}"
    
    case ${_PROP} in
            title)
                # echo "title: ${_VAL}"
                # echo "title: ${_VAL_W_SPACES}"
                # local _VAL_WITH_SPACES=${_VAL//_/' '} # swap all underscores with spaces
                _TITLE="${_VAL}"
                _TITLE_LENGTH="${#_TITLE}"
                ;;
            title_color) 
                # echo "title_color: ${_VAL}"
                [[ "${_VAL}" == *","*","* ]] && {
                  _VAL=${_VAL//,/' '}
                }
                _TITLE_COLOR="${_VAL}"
                ;;
            title_justification) 
                # echo "title_color: ${_VAL}"
                local _JUST="${_VAL}"
                if [[ $_JUST == "centered" ]] || [[ $_JUST == "left" ]] || [[ $_JUST == "right" ]]; then
                    _TITLE_JUSTIFICATION="${_JUST}"
                else  
                    echo "${FUNCNAME[0]}: unknown title justification value: ${_JUST}"
                    continue
                fi
                ;;
            box_color)
                [[ "${_VAL}" == *","*","* ]] && {
                  _VAL=${_VAL//,/' '}
                }
                _BOX_COLOR="${_VAL}"
                ;;
            box_width) 
                # echo "box_width: ${_VAL}"
                _BOX_WIDTH="${_VAL}"
                ;;
            box_height) 
                # echo "box_height: ${_VAL}"
                _BOX_HEIGHT="${_VAL}"
                ;;
            box_justification) 
                # echo "title_color: ${_VAL}"
                local _JUST="${_VAL}"
                if [[ $_JUST == "centered" ]] || [[ $_JUST == "left" ]] || [[ $_JUST == "right" ]]; then
                    _BOX_JUSTIFICATION="${_JUST}"
                else  
                    echo "${FUNCNAME[0]}: unknown title justification value: ${_JUST}"
                    continue
                fi
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

  ## Determine horizontal placement for box. Assign left starting point
  ## to _BOX_START_COL.
  ##
  ## NOTE:  We do this here because box width, title length, and horizontal pad
  ## need to be populated in order for this calculation to be processed.
  ttui::get_term_size
  case ${_BOX_JUSTIFICATION} in
      "centered") 
          _BOX_START_COL=$(( (TTUI_TERM_COLUMNS - _BOX_WIDTH) / 2 ))
          ;;
      "left") 
          _BOX_START_COL=1
          ;;
      "right") 
          _BOX_START_COL=$(( TTUI_TERM_COLUMNS - _BOX_WIDTH + 1 ))
          ;;
      *) echo 
          "Error: unknown title_justification value: ${_TITLE_JUSTIFICATION}"
          ;;
  esac
  ## Determine horizontal placement for title text. Assign left starting point
  ## to _TITLE_START_COL.
  ##
  ## NOTE:  We do this here because box width, title length, and horizontal pad
  ## need to be populated in order for this calculation to be processed.
  case ${_TITLE_JUSTIFICATION} in
      "centered") 
          # _TITLE_START_COL=$(( ((_BOX_WIDTH - _TITLE_LENGTH) / 2) + _BOX_START_COL ))
          _TITLE_START_COL=$(( ((_BOX_WIDTH - _TITLE_LENGTH) / 2) + _BOX_START_COL - 1 ))
          ;;
      "left") 
          # _TITLE_START_COL=$(( _BOX_START_COL + _PAD_HORIZONTAL + 1 ))
          _TITLE_START_COL=$(( _BOX_START_COL + _PAD_HORIZONTAL ))
          ;;
      "right") 
          # _TITLE_START_COL=$(( _BOX_START_COL + _BOX_WIDTH - _PAD_HORIZONTAL - 1 - _TITLE_LENGTH ))
          _TITLE_START_COL=$(( _BOX_START_COL + _BOX_WIDTH - _PAD_HORIZONTAL - 2 - _TITLE_LENGTH ))
          ;;
      *) echo 
          "Error: unknown title_justification value: ${_TITLE_JUSTIFICATION}"
          ;;
  esac

  ## for some dirty debuggin':
  # echo "title:                ${_TITLE}"
  # echo "title length:         ${_TITLE_LENGTH}"
  # echo "title color:          ${_TITLE_COLOR}"
  # echo "title justification:  ${_TITLE_JUSTIFICATION}"
  # echo "left pad:             ${_LEFT_PAD}"
  # echo "box color:            ${_BOX_COLOR}"
  # echo "box width:            ${_BOX_WIDTH}"
  # echo "box_height:           ${_BOX_HEIGHT}"
  # echo "box justification:    ${_BOX_JUSTIFICATION}"
  # echo "box start column:     ${_BOX_START_COL}"
  # echo "pad horizontal:       ${_PAD_HORIZONTAL}"
  # echo "padvertical:         ${_PAD_VERTICAL}"
  # echo "box height / 2: $(( (_BOX_HEIGHT / 2) + 1))"

  ## print empty lines covering the vertical height of the box
  for ((i=0; i < _BOX_HEIGHT; i++)); do
    echo
  done

  ## move cursor to the middle in prep for printing title
  ttui::cursor::move_up $(( (_BOX_HEIGHT / 2) + 1 ))
  
  ## move cursor right by amount appropriate for specified justification
  ttui::cursor::move_right ${_TITLE_START_COL}
  
  ## print the title
  ttui::color::set_color_to_rgb ${_TITLE_COLOR}
  printf "%s" "${_TITLE}"
  
  ## move cursor into position to draw box
  ttui::cursor::move_to_bottom
  ttui::cursor::move_left 999
  ttui::cursor::move_up ${_BOX_HEIGHT}
  
  ## draw box
  ttui::color::set_color_to_rgb ${_BOX_COLOR}
  # ttui::logger::enable_logging
  ttui::draw_box ${_BOX_WIDTH} ${_BOX_HEIGHT} ${_BOX_START_COL}
  # ttui::logger::disable_logging
  
  ## reset color
  ttui::color::reset
}