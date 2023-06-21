#! /usr/bin/env bash

# =============================================================================
#
#   name:   ttui_lib.sh
#   auth:   ted craig
#
#   desc:   Terminal UI library for Bash.
#
#   dependancies:   awk (developed using version 20200816)
#
#   acknowledgment: Special thanks to Dylan Araps who has generously shared
#                   with the world their extensive knowledge of 
#                   shell scripting, especially the esoteric world of console
#                   control escape sequences.
#                   https://github.com/dylanaraps
#
#   NOTE:   There are some potentially dangerous things in here.  In order to
#           allow for the flexibility of having functions write values to 
#           user specified variables, the eval command is used which could
#           result in chaos, or worse, if strings of a certain nature are passed
#           into it.
# =============================================================================


# -----------------------------------------------------------------------------
# Global Vars
# -----------------------------------------------------------------------------
TTUI_DEBUG_LOGS_ENABLED=false
TTUI_OPERATING_SYSTEM=
TTUI_TERM_LINES=
TTUI_TERM_COLUMNS=
TTUI_CURRENT_LINE=
TTUI_CURRENT_COLUMN=
TTUI_CURSOR_VISIBLE=true
TTUI_LINE_WRAPPING_ENABLED=true
TTUI_COLOR_RGB=()

## escape codes that can be strung together in a printf statement 
## for speed and brevity as an alternative to function calls
TTUI_SAVE_TERMINAL_SCREEN='\e[?1049h'
TTUI_RESTORE_TERMINAL_SCREEN='\e[?1049l'
TTUI_RESET_TERMINAL_TO_DEFAULTS='\ec'
TTUI_CLEAR_SCREEN_ENTIRELY='\e[2J'
TTUI_DISABLE_LINE_WRAPPING='\e[?7l'
TTUI_ENABLE_LINE_WRAPPING='\e[?7h'
TTUI_RESTORE_SCROLL_AREA='\e[;r'
TTUI_SCROLL_UP='\eM'
TTUI_SCROLL_DOWN='\eD'
TTUI_HIDE_CURSOR='\e[?25l'
TTUI_SHOW_CURSOR='\e[?25h'
TTUI_SAVE_CURSOR_POSITION='\e7'
TTUI_RESTORE_CURSOR_POSITION='\e8'
TTUI_MOVE_CURSOR_UP_ONE_LINE='\e[1A'
TTUI_MOVE_CURSOR_DOWN_ONE_LINE='\e[1B'
TTUI_MOVE_CURSOR_LEFT_ONE_COL='\e[1D'
TTUI_MOVE_CURSOR_RIGHT_ONE_COL='\e[1C'
TTUI_MOVE_CURSOR_TO_HOME_POSITION='\e[2J'
TTUI_MOVE_CURSOR_TO_BOTTOM_LINE='\e[9999H'


# -----------------------------------------------------------------------------
# Signal Captures
# -----------------------------------------------------------------------------

# React to window size changes via SIGWINCH
trap 'ttui::get_term_size' WINCH


# -----------------------------------------------------------------------------
# Enables debug logs.
# Globals:
#   ttui_debug_logs_enabled
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::enable_debug_mode() {
  TTUI_DEBUG_LOGS_ENABLED=true
  ttui::debug_logger "debug mode enabled"
}


# -----------------------------------------------------------------------------
# Disables debug logs.
# Globals:
#   ttui_debug_logs_enabled
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::disable_debug_mode() {
  TTUI_DEBUG_LOGS_ENABLED=false
}


# -----------------------------------------------------------------------------
# Print debug messages if debug mode is enabled.
# Globals:
#   ttui_debug_logs_enabled
# Arguments:
#   message
# -----------------------------------------------------------------------------
ttui::debug_logger() {
  [[ "${TTUI_DEBUG_LOGS_ENABLED}" == false ]] && return
  local caller="${FUNCNAME[1]}"
  local self="${FUNCNAME[0]}"
  local message="$1"
  [[ "$#" == 0 ]] && message="no message argument provided to ${self}"
  echo "[ ${caller} ]--> ${message}"
}


# -----------------------------------------------------------------------------
# Get the current operating system type
# Globals:
#   TTUI_OS
# Arguments:
#   None
# -----------------------------------------------------------------------------
# ┏━━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━┓
# ┃          OS	        │       $OSTYPE       ┃
# ┣━━━━━━━━━━━━━━━━━━━━━┿━━━━━━━━━━━━━━━━━━━━━┫  
# ┃ Linux with glibc	  │ linux-gnu           ┃
# ┃ Linux with musl	    │ linux-musl          ┃
# ┃ Cygwin	            │ cygwin              ┃
# ┃ Bash on Windows 10  │	linux-gnu           ┃
# ┃ Msys	              │ msys                ┃
# ┃ Mingw64	            │ msys                ┃ 
# ┃ Mingw32	            │ msys                ┃
# ┃ OpenBSD	            │ openbsd*            ┃
# ┃ FreeBSD	            │ freebsd*            ┃
# ┃ NetBSD	            │ netbsd              ┃
# ┃ macOS	              │ darwin*             ┃
# ┃ iOS	                │ darwin9             ┃
# ┃ Solaris	            │ solaris*            ┃
# ┃ Android (Termux)    │ linux-android       ┃
# ┃ Android	            │ linux-gnu           ┃
# ┃ Haiku	              │ haiku               ┃
# ┗━━━━━━━━━━━━━━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━┛
ttui::get_operating_system() {
  # '$OSTYPE' typically stores the name of the OS kernel.
  case "$OSTYPE" in
    linux*)
      TTUI_OPERATING_SYSTEM="linux"
      # ...
    ;;

    # Mac OS X / macOS.
    darwin*)
      TTUI_OPERATING_SYSTEM="macos"
      # ...
    ;;

    openbsd*)
      TTUI_OPERATING_SYSTEM="openbsd"
      # ...
    ;;

    # Everything else.
    *)
      TTUI_OPERATING_SYSTEM="other"
      #...
    ;;
  esac
}


# -----------------------------------------------------------------------------
# Saves the current state of the terminal which can later be restored via
# ttui::restore_terminal_screen()
# Globals:
#   TBD
# Arguments:
#   None
# -----------------------------------------------------------------------------
ttui::save_terminal_screen() {
  # Saving and Restoring the user's terminal screen.
  # This non-VT100 sequence allows you to save and restore the user's terminal 
  # screen when running your program. When the user exits the program, their 
  # command-line will be restored as it was before running the program.
  # While this sequence is XTerm specific, it is covered by almost all modern 
  # terminal emulators and simply ignored in older ones. 
  # Save the user's terminal screen.
  printf '\e[?1049h'
}


# -----------------------------------------------------------------------------
# Restores terminal to the state saved via ttui::save_terminal_screen()
# Globals:
#   TBD
# Arguments:
#   None
# -----------------------------------------------------------------------------
ttui::restore_terminal_screen() {
  printf '\e[?1049l'
}


# -----------------------------------------------------------------------------
# Clears the screen.
# Globals:
#   TBD
# Arguments:
#   None
# -----------------------------------------------------------------------------
ttui::reset_terminal_to_defaults() {
  printf '\ec'
}


# -----------------------------------------------------------------------------
# Clears the screen.
# Globals:
#   TBD
# Arguments:
#   None
# -----------------------------------------------------------------------------
ttui::clear_screen() {
  # See: https://vt100.net/docs/vt510-rm/ED.html
  # Ps represents the amount of the display to erase.
  # Ps	Area Erased:
  # 0 (default)	From the cursor through the end of the display
  # 1	From the beginning of the display through the cursor
  # 2	The complete display
  printf '\e[2J'
}


# -----------------------------------------------------------------------------
# Get the current size of the terminal
# Globals:
#   lines
#   ORACLE_SID
# Arguments:
#   None
# -----------------------------------------------------------------------------
ttui::get_term_size() {
  # '\e7':           Save the current cursor position.
  # '\e[9999;9999H': Move the cursor to the bottom right corner.
  # '\e[6n':         Get the cursor position (window size).
  # '\e8':           Restore the cursor to its previous position.
  IFS='[;' read -p $'\e7\e[9999;9999H\e[6n\e8' -d R -rs _ TTUI_TERM_LINES TTUI_TERM_COLUMNS
}


# -----------------------------------------------------------------------------
# Disables line wrapping
# Globals:
#   line_wrapping_enabled
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::disable_line_wrapping() {
  printf '\e[?7l'
  TTUI_LINE_WRAPPING_ENABLED=false
}


# -----------------------------------------------------------------------------
#  line wrapping
# Globals:
#   line_wrapping_enabled
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::enable_line_wrapping() {
  printf '\e[?7h'
  TTUI_LINE_WRAPPING_ENABLED=true
}


# -----------------------------------------------------------------------------
# Limits vertical scrolling area to be between the two specified points
# and then moves cursor to top-left of the new boundary.
# Globals:
#   TTUI_SCROLL_AREA_TOP
#   TTUI_SCROLL_AREA_BOTTOM
# Arguments:
#   position 1: top line number (positive int) inclusive
#   position 2: bottom line number (positive int) inclusive
# -----------------------------------------------------------------------------
ttui::set_scroll_area() {
  ttui::debug_logger "${FUNCNAME[0]}: num args: $#"
  # See: https://vt100.net/docs/vt510-rm/DECSTBM.html
  # Limit scrolling from line 0 to line 10.
  # printf '\e[0;10r'
  # Limit scrolling from line top to line bottom.
  # printf '\e[%s;%sr' "${top_line_of_scroll}" "${bottom_line_of_scroll}"
}


# -----------------------------------------------------------------------------
# Restores scolling margins back to default.
# Globals:
#   TTUI_SCROLL_AREA_TOP
#   TTUI_SCROLL_AREA_BOTTOM
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::restore_scroll_area() {
  # See: https://vt100.net/docs/vt510-rm/DECSTBM.html
  printf '\e[;r'
}


# -----------------------------------------------------------------------------
# Scroll display up one line.
# Globals:
#   TBD
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::scroll_up() {
  printf '\eM'
}


# -----------------------------------------------------------------------------
# Scroll display down one line.
# Globals:
#   TBD
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::scroll_down() {
  printf '\eD'
}


# -----------------------------------------------------------------------------
# Hides the cursor
# Globals:
#   cursor_visible
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::hide_cursor() {
  printf '\e[?25l'
  TTUI_CURSOR_VISIBLE=false
}


# -----------------------------------------------------------------------------
# Shows the cursor
# Globals:
#   cursor_visible
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::show_cursor() {
  printf '\e[?25h'
  TTUI_CURSOR_VISIBLE=true
}


# -----------------------------------------------------------------------------
# Saves the current cursor position.  Cursor can later be restored to this
# position using ttui::restore_cursor_position()
# Globals:
#   TBD
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::save_cursor_position() {
  # This is more widely supported than '\e[s'.
  printf '\e7'
}


# -----------------------------------------------------------------------------
# Restores the cursor to the position saved via ttui::save_cursor_position().
# Globals:
#   TBD
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::restore_cursor_position() {
  # This is more widely supported than '\e[u'.
  printf '\e8'
}


# -----------------------------------------------------------------------------
# Restores the cursor to the position saved via ttui::save_cursor_position().
# Globals:
#   TTUI_CURRENT_LINE
#   TTUI_CURRENT_COLUMN
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::get_cursor_position() {
  ttui::debug_logger "invoked ..."
  ttui::debug_logger "received $# args"
  local expanded_args=$(echo "$@")
  ttui::debug_logger "args received: $expanded_args"
  
  # save the current/default IFS delimeter(s) in order to restore later
  local old_ifs="$IFS"
  
  # assign line and column nums -------------------------------------------------
  #   if more than one arg exists, then try to assign values to variables
  #   of the same name.
  #   else assign values to default global variable.
  if [[ $# -gt 1 ]]; then
    ttui::debug_logger "1st arg found: $1"
    ttui::debug_logger "2nd arg found: $2"
    # check if the string value of myVar is the name of a declared variable
    local lineVarName="$1"
    local bLineVarExists=false
    local test='if ${'"${lineVarName}"'+"false"}; then ttui::debug_logger "${lineVarName} not defined"; else bLineVarExists=true; ttui::debug_logger "${lineVarName} is defined"; fi'
    ttui::debug_logger "test: $test"
    eval $test
    ttui::debug_logger  "bLineVarExists: ${bLineVarExists}"

    local columnVarName="$2"
    local bColumnVarExists=false
    local test='if ${'"${columnVarName}"'+"false"}; then ttui::debug_logger "${columnVarName} not defined"; else bColumnVarExists=true; ttui::debug_logger "${columnVarName} is defined"; fi'
    ttui::debug_logger "test: $test"
    eval $test
    ttui::debug_logger  "bColumnVarExists: ${bColumnVarExists}"

    if [[ $bLineVarExists == true ]] && [[ $bColumnVarExists == true ]]; then
      local assignment="IFS='[;' read -p $'\e[6n' -d R -rs _ ${lineVarName} ${columnVarName}"
      #                 \______/ \__/ \_________/ \__/ \_/ \___________________________/
      #                    |      |       |        |    |                |
      #                    |      |       |        |    |  Variables to receive output of read,
      #                    |      |       |        |    |  as parsed by the IFS delimeters.
      #                    |      |       |        |    |  ^[ThrowAway[Lines;ColumnsR
      #                    |      |       |        |    |  var:  -
      #                    |      |       |        |    |     receives superfluous value
      #                    |      |       |        |    |     parsed between [ and [
      #                    |      |       |        |    |  var:  LINE_NUM_VAR
      #                    |      |       |        |    |     receives line number value
      #                    |      |       |        |    |     parsed between [ and ;
      #                    |      |       |        |    |  var:  COLUMN_NUM_VAR
      #                    |      |       |        |    |     receives column number value
      #                    |      |       |        |    |     parsed between ; and R
      #                    |      |       |        |     \
      #                    |      |       |        |  Do not treat a Backslash as an escape character.
      #                    |      |       |        |  Silent mode: any characters input from the terminal
      #                    |      |       |        |  are not echoed.
      #                    |      |       |        |
      #                    |      |       |  Terminates the input line at R rather than at newline 
      #                    |      |       |
      #                    |      |  Prints '\e[6n' as prompt to console.
      #                    |      |  This term command escape code is immediately interpted, generating
      #                    |      |  response code containing the line and column position
      #                    |      |  in format: ^[[1;2R  (where num at position 1 is the line number
      #                    |      |  and num at position 2 is the column number). This response string
      #                    |      |  becomes the input of the read command.
      #                    |      |
      #                    |  Read input from console
      #                    |
      #                  Overrides default delimeters for output of the read.
      #                  Will capture values between [ and/or ; chars
      ttui::debug_logger  "assignment: ${assignment}"
      eval $assignment
    else
      echo "${FUNCNAME[0]} --> warning: cannot assign cursor position values to provided var names: ${lineVarName} and/or ${columnVarName}: undelcared or invalid variable"
    fi
  else
    ttui::debug_logger "no var name provided. Assigning cursor position values to global vars TTUI_CURRENT_LINE TTUI_CURRENT_COLUMN"
    IFS='[;' read -p $'\e[6n' -d R -rs _ TTUI_CURRENT_LINE TTUI_CURRENT_COLUMN
  fi
  
  # reset delimeters to original/default value
  IFS="${old_ifs}"

  ttui::debug_logger "current position: Line ${TTUI_CURRENT_LINE} | Col ${TTUI_CURRENT_COLUMN}"
  ttui::debug_logger "** execution complete **"
}


# -----------------------------------------------------------------------------
# Moves cursor to the specified line and column.
# Globals:
#   TBD
# Arguments:
#   position 1: line number (positive int) or '-' (any non-digit char)
#   position 2: column number (positive int) or '-' (any non-digit char)
# -----------------------------------------------------------------------------
ttui::move_cursor_to() {
  ttui::debug_logger "${FUNCNAME[0]}: $# arguments received"
  ttui::debug_logger "arg \$1: $1 | \$2: $2"
  # See: https://vt100.net/docs/vt510-rm/CUP.html
  # Move the cursor to 0,0.
  #   printf '\e[H'
  # Move the cursor to line 3, column 10.
  #   printf '\e[3;10H'
  #   printf '\e[%s;%sH]' "${line_number}" "${column_number}"
  # Move the cursor to line 5.
  #   printf '\e[5H'
  #   printf '\e[%sH]' "${line_number}"

}


# -----------------------------------------------------------------------------
# Moves cursor up 1 or more lines relative to current position.
# Globals:
#   TBD
# Arguments:
#   [position 1]: number of lines to move (positive int)
# -----------------------------------------------------------------------------
ttui::move_cursor_up() {
  ttui::debug_logger "${FUNCNAME[0]}: $# arguments received"
  # See: https://vt100.net/docs/vt510-rm/CUU.html
  # if no value passed, move up 1 line
  local num_lines_to_move=1
  # else move up the specified number of lines
  # printf '\e[%sA' "${num_lines_to_move}"
  # Todo: validate arg is actually a valid number
  [[ $# -gt 0 ]] && num_lines_to_move=$1

  printf '\e[%sA' "${num_lines_to_move}"
}


# -----------------------------------------------------------------------------
# Moves cursor down 1 or more lines relative to current position.
# Globals:
#   TBD
# Arguments:
#   [position 1]: number of lines to move (positive int)
# -----------------------------------------------------------------------------
ttui::move_cursor_down() {
  ttui::debug_logger "${FUNCNAME[0]}: $# arguments received"
  # See: https://vt100.net/docs/vt510-rm/CUD.html
  # if no value passed, move up 1 line
  # printf '\e[B'
  local num_lines_to_move=1
  # else move up the specified number of lines
  # printf '\e[%sB' "${num_lines_to_move}"
  # Todo: validate arg is actually a valid number
  [[ $# -gt 0 ]] && num_lines_to_move=$1
  
  printf '\e[%sB' "${num_lines_to_move}"
}


# -----------------------------------------------------------------------------
# Moves cursor left 1 or more lines relative to current position.
# Globals:
#   TBD
# Arguments:
#   [position 1]: number of lines to move (positive int)
# -----------------------------------------------------------------------------
ttui::move_cursor_left() {
  ttui::debug_logger "${FUNCNAME[0]}: $# arguments received"
  # See: https://vt100.net/docs/vt510-rm/CUB.html
  # if no value passed, move up 1 line
  # printf '\e[D'
  local num_columns_to_move=1
  # else move left the specified number of columns
  # printf '\e[%sD' "${num_columns_to_move}"
  # Todo: validate arg is actually a valid number
  [[ $# -gt 0 ]] && num_columns_to_move=$1
  
  printf '\e[%sD' "${num_columns_to_move}"
}


# -----------------------------------------------------------------------------
# Moves cursor right 1 or more lines relative to current position.
# Globals:
#   TBD
# Arguments:
#   [position 1]: number of lines to move (positive int)
# -----------------------------------------------------------------------------
ttui::move_cursor_right() {
  ttui::debug_logger "${FUNCNAME[0]}: $# arguments received"
  # See: https://vt100.net/docs/vt510-rm/CUF.html
  # if no value passed, move up 1 line
  # printf '\e[C'
  local num_columns_to_move=1
  # else move up the specified number of columns
  # printf '\e[%sC' "${num_columns_to_move}"
  # Todo: validate arg is actually a valid number
  [[ $# -gt 0 ]] && num_columns_to_move=$1
  
  printf '\e[%sC' "${num_columns_to_move}"
}


# -----------------------------------------------------------------------------
# Moves cursor to the last line.
# Globals:
#   TBD
# Arguments:
#   position 1: line number (positive int) or '-' (any non-digit char)
#   position 2: column number (positive int) or '-' (any non-digit char)
# -----------------------------------------------------------------------------
ttui::move_cursor_to_bottom() {
  # Using terminal size, move cursor to bottom.
  # printf '\e[%sH' "$LINES"
  #  -- or --
  # Move to a huge number, will stop at bottom line available in the window
  printf '\e[9999H'
}


# -----------------------------------------------------------------------------
# Moves cursor to the home position: 0,0.
# Globals:
#   none
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::move_cursor_to_home() {
  printf '\e[2J'
}


# -----------------------------------------------------------------------------
# Converts LCH color values to RGB values. 
# If optional variable name argument is provided, resulting RGB values will be 
# assigned as an array (R,G,B) to variable matching the provided name.  If 
# optional variable name argument is not used then resulting RGB value will be
# assigned as an array (R,G,B) to global variable TTUI_COLOR_RGB_FROM_LCH.
# Globals:
#   TTUI_COLOR_RGB_FROM_LCH
# Arguments:
#   position 1:  LCH lightness value (0-100)
#   position 2:  LCH chroma    value (0-132)
#   position 3:  LCH hue       value (0-360)
#  [position 4:] name of existing variable to which result should be assigned
# -----------------------------------------------------------------------------
ttui::get_color_rgb_from_lch() {
  # color conversion equations from:
  # avisek/colorConversions.js
  # https://gist.github.com/avisek/eadfbe7a7a169b1001a2d3affc21052e
  #
  # checked sanity of results using:
  # https://www.easyrgb.com/en/convert.php#inputFORM
  #
  # LCH color picker:
  # https://css.land/lch/

  ##########  TODO:
  ##########  check that args in position 1, 2, 3 are numbers 
  ##########  and that they are within the legal range for their
  ##########  respective LCH value:
  ##########    position 1:  LCH lightness value (0-100)
  ##########    position 2:  LCH chroma    value (0-132)
  ##########    position 3:  LCH hue       value (0-360)
  
  ##########  TODO:
  ##########  refactor to reduce awk invocations.
  ##########  maybe introduce function calls within awk to reduce code repetition
  ##########  (unless that is less performant)

  ttui::debug_logger "received $# args"
  local expanded_args=$(echo "$@")
  ttui::debug_logger "args received: $expanded_args"
  
  # assign positional args 1,2,3 as prospective LCH values
  local LCH_L=$1
  local LCH_C=$2
  local LCH_H=$3

  local LAB_L=
  local LAB_A=
  local LAB_B=

  local XYZ_X=
  local XYZ_Y=
  local XYZ_Z=

  local RGB_R=
  local RGB_G=
  local RGB_B=

  # TODO: validate that 3 numbers have been provided and that they are within legal range

  # isNumber=`eval '[[ '$"${varName}"' =~ ^[+-]?[0-9]+$ ]]'`
  # if $isNumber; then echo "it's a number!"; else echo "it's not a number"; fi

  # if [[ eval $myVar =~ ^[+-]?[0-9]+$ ]]; then
  #   echo "Number!" 
  # elif [[ eval $myVar =~ ^[+-]?[0-9]*\.[0-9]+$ ]]; then
  #   echo "Float!"
  # elif [[ eval $myVar =~ [0-9] ]]; then
  #   echo "Mixed, some numbers"
  # else
  #   echo "No numbers!"
  # fi  

  ttui::debug_logger "lch --> L: $LCH_L | C: $LCH_C | H: $LCH_H"

  # lchToLab ------------------------------------------------------------------
  ttui::debug_logger "converting LCH to LAB..."
  #   l = l
  #   a = cos(h * 0.01745329251) * c
  #   b = sin(h * 0.01745329251) * c
  LAB_L=$LCH_L
  LAB_A=`awk -v H=$LCH_H -v C=$LCH_C 'BEGIN{ A=cos(H * 0.01745329251) * C; print A }'`
  LAB_B=`awk -v H=$LCH_H -v C=$LCH_C 'BEGIN{ B=sin(H * 0.01745329251) * C; print B }'`
  ttui::debug_logger "lab --> L: $LAB_L | A: $LAB_A | B: $LAB_B"

  # labToXyz --------------------------------------------------------------------
  ttui::debug_logger "converting LAB to XYZ..."
  #   y = (l + 16) / 116
  #   x = a / 500 + y
  #   z = y - b / 200
  XYZ_Y=`awk -v L=$LAB_L 'BEGIN{ Y=( L + 16 ) / 116; print Y }'`
  XYZ_X=`awk -v A=$LAB_A -v Y=$XYZ_Y 'BEGIN{ X= A / 500 + Y; print X }'`
  XYZ_Z=`awk -v Y=$XYZ_Y -v B=$LAB_B 'BEGIN{ Z=Y - B / 200; print Z }'`
  ttui::debug_logger "intermediate X: ${XYZ_X} | Y: ${XYZ_Y} | Z: ${XYZ_Z}"
  #   if (Math.pow(y, 3) > 0.008856) {
  #     y = Math.pow(y, 3)
  #   } else {
  #     y = (y - 0.137931034) / 7.787
  #   }
  XYZ_Y=`awk -v Y=$XYZ_Y 'BEGIN{ Y=(Y ^ 3) > 0.008856 ? Y ^ 3 : (Y - 0.137931034) / 7.787; print Y}'`
  #   if (Math.pow(x, 3) > 0.008856) {
  #     x = Math.pow(x, 3)
  #   } else {
  #     x = (x - 0.137931034) / 7.787
  #   }
  XYZ_X=`awk -v X=$XYZ_X 'BEGIN{ X=(X ^ 3) > 0.008856 ? X ^ 3 : (X - 0.137931034) / 7.787; print X}'`
  #   if (Math.pow(z, 3) > 0.008856) {
  #     z = Math.pow(z, 3)
  #   } else {
  #     z = (z - 0.137931034) / 7.787
  #   }
  XYZ_Z=`awk -v Z=$XYZ_Z 'BEGIN{ Z=(Z ^ 3) > 0.008856 ? Z ^ 3 : (Z - 0.137931034) / 7.787; print Z}'`
  ttui::debug_logger "intermediate2 X: ${XYZ_X} | Y: ${XYZ_Y} | Z: ${XYZ_Z}"
  #   // Observer = 2°, Illuminant = D65
  #   x = 95.047 * x
  #   y = 100.000 * y
  #   z = 108.883 * z
  XYZ_X=`awk -v X=$XYZ_X 'BEGIN{ X=95.047 * X; print X}'`
  XYZ_Y=`awk -v Y=$XYZ_Y 'BEGIN{ Y=100.000 * Y; print Y}'`
  XYZ_Z=`awk -v Z=$XYZ_Z 'BEGIN{ Z=108.883 * Z; print Z}'`
  ttui::debug_logger "xyz --> X: $XYZ_X | Y: $XYZ_Y | Z: $XYZ_Z"

  # xyzToRgb --------------------------------------------------------------------
  ttui::debug_logger "converting XYZ to RGB..."
  #   // Observer = 2°, Illuminant = D65
  #   x = xyz.x / 100 // X from 0 to 95.047
  #   y = xyz.y / 100 // Y from 0 to 100.000
  #   z = xyz.z / 100 // Z from 0 to 108.883
  XYZ_X=`awk -v X=$XYZ_X 'BEGIN{ X=X / 100; print X}'`
  XYZ_Y=`awk -v Y=$XYZ_Y 'BEGIN{ Y=Y / 100; print Y}'`
  XYZ_Z=`awk -v Z=$XYZ_Z 'BEGIN{ Z=Z / 100; print Z}'`
  ttui::debug_logger "intermediate3 X: ${XYZ_X} | Y: ${XYZ_Y} | Z: ${XYZ_Z}"
  #   r = x * 3.2406 + y * -1.5372 + z * -0.4986
  #   g = x * -0.9689 + y * 1.8758 + z * 0.0415
  #   b = x * 0.0557 + y * -0.2040 + z * 1.0570
  RGB_R=`awk -v X=$XYZ_X -v Y=$XYZ_Y -v Z=$XYZ=Z 'BEGIN{ R=X * 3.2406 + Y * -1.5372 + Z * -0.4986; print R}'`
  RGB_G=`awk -v X=$XYZ_X -v Y=$XYZ_Y -v Z=$XYZ=Z 'BEGIN{ G=X * -0.9689 + Y * 1.8758 + Z * 0.0415; print G}'`
  RGB_B=`awk -v X=$XYZ_X -v Y=$XYZ_Y -v Z=$XYZ=Z 'BEGIN{ B=X * 0.0557 + Y * -0.2040 + Z * 1.0570; print B}'`
  ttui::debug_logger "intermediate4 R: ${RGB_R} | G: ${RGB_G} | B: ${RGB_B}"
  #   if (r > 0.0031308) {
  #     r = 1.055 * (Math.pow(r, 0.41666667)) - 0.055
  #   } else {
  #     r = 12.92 * r
  #   }
  RGB_R=`awk -v R=$RGB_R 'BEGIN{ R=R > 0.0031308 ? 1.055 * (R ^ 0.41666667) - 0.055 : 12.92 * R; print R}'`
  #   if (g > 0.0031308) {
  #     g = 1.055 * (Math.pow(g, 0.41666667)) - 0.055
  #   } else {
  #     g = 12.92 * g
  #   }
  RGB_G=`awk -v G=$RGB_G 'BEGIN{ G=G > 0.0031308 ? 1.055 * (G ^ 0.41666667) - 0.055 : 12.92 * G; print G}'`
  #   if (b > 0.0031308) {
  #     b = 1.055 * (Math.pow(b, 0.41666667)) - 0.055
  #   } else {
  #     b = 12.92 * b
  #   }
  RGB_B=`awk -v B=$RGB_B 'BEGIN{ B=B > 0.0031308 ? 1.055 * (B ^ 0.41666667) - 0.055 : 12.92 * B; print B}'`
  ttui::debug_logger "intermediate4 R: ${RGB_R} | G: ${RGB_G} | B: ${RGB_B}"
  #   r *= 255
  #   g *= 255
  #   b *= 255
  RGB_R=`awk -v R=$RGB_R 'BEGIN{ R=255 * R; print R}'`
  RGB_G=`awk -v G=$RGB_G 'BEGIN{ G=255 * G; print G}'`
  RGB_B=`awk -v B=$RGB_B 'BEGIN{ B=255 * B; print B}'`
  ttui::debug_logger "intermediate5 R: ${RGB_R} | G: ${RGB_G} | B: ${RGB_B}"
  #   round float values to int vals and clamp to range 0-255
  RGB_R=`awk -v R=$RGB_R 'BEGIN{
    intVal = int(R) 
    if (R < 0) {
      R = 0
    } else if (R > 255) {
      R = 255
    } else if (R == intVal ){
      R = R
    } else if (R - intVal >= 0.5) {
      R = intVal + 1
    } else {
      R = intVal
    }; 
    print R}'`
  RGB_G=`awk -v G=$RGB_G 'BEGIN{
    intVal = int(G) 
    if (G < 0) {
      G = 0
    } else if (G > 255) {
      G = 255
    } else if (G == intVal ){
      G = G
    } else if (G - intVal >= 0.5) {
      G = intVal + 1
    } else {
      G = intVal
    }; 
    print G}'`
  RGB_B=`awk -v B=$RGB_B 'BEGIN{
    intVal = int(B) 
    if (B < 0) {
      B = 0
    } else if (B > 255) {
      B = 255
    } else if (B == intVal ){
      B = B
    } else if (B - intVal >= 0.5) {
      B = intVal + 1
    } else {
      B = intVal
    }; 
    print B}'`
  ttui::debug_logger "rgb --> R: $RGB_R | G: $RGB_G | B: $RGB_B"

  # test
  # printf "\033[38;2;%d;%d;%dm$LEVEL_BARS_TOP\n" $RGB_R $RGB_G $RGB_B;
  # printf "\033[38;2;%d;%d;%dm$LEVEL_BARS_MID\n" $RGB_R $RGB_G $RGB_B;
  # printf "\033[38;2;%d;%d;%dm$LEVEL_BARS_BOT\n" $RGB_R $RGB_G $RGB_B;
  # reset color
  # printf "\033[0m"

  # assign RGB values -----------------------------------------------------------
  #   if option fourth arg exists, then try to assign values to variable of the same name
  #   else assign values to default global variable
  if [[ $# -gt 3 ]]; then
    ttui::debug_logger "4th arg found: $4"
    # check if the string value of myVar is the name of a declared variable
    local varName="$4"
    # myVar='$'"$4"
    local bVarExists=false
    local test='if ${'"${varName}"'+"false"}; then ttui::debug_logger "${varName} not defined"; else bVarExists=true; ttui::debug_logger "${varName} is defined"; fi'
    ttui::debug_logger "test: $test"
    eval $test
    ttui::debug_logger  "bVarExists: ${bVarExists}"

    if [[ $bVarExists == true ]]; then
      local assignment="${varName}"'=($RGB_R $RGB_G $RGB_B)'
      ttui::debug_logger  "assignment: ${assignment}"
      eval $assignment
      local toEcho='echo "${varName}: ${'"${varName}"'[@]}"'
      ttui::debug_logger  "toEcho: $toEcho"
      # eval $toEcho
      local toLog=`eval $toEcho`
      ttui::debug_logger $toLog
    else
      echo "${FUNCNAME[0]} --> warning: cannot assign RGB values to ${varName}: undelcared variable"
    fi
  else
    ttui::debug_logger "no var name provided. Assigning to TTUI_COLOR_RGB_FROM_LCH"
    TTUI_COLOR_RGB_FROM_LCH=($RGB_R $RGB_G $RGB_B)
  fi

  ttui::debug_logger "** execution complete **"
}


# -----------------------------------------------------------------------------
# Generates RGB color escape code string using the argument values supplied. 
# If optional variable name argument is provided, resulting escape code will be 
# assigned to variable matching the provided name.  
# If optional variable name argument is not used then resulting escape code will
# be assigned global variable TTUI_COLOR_RGB.
# Globals:
#   TTUI_COLOR_RGB
# Arguments:
#   position 1:  Red    value (0-255)
#   position 2:  Blue   value (0-255)
#   position 3:  Green  value (0-255)
#  [position 4:] name of existing variable to which result should be assigned
# -----------------------------------------------------------------------------
ttui::get_color_escape_code_rgb() {
  
  ttui::debug_logger "received $# args"
  local expanded_args=$(echo "$@")
  ttui::debug_logger "args received: $expanded_args"

  ##########  TODO:
  ##########  check that args in position 1, 2, 3 are numbers 
  ##########  and that they are within the legal range for RGB
  ##########  values: 0-255
  
  local RED=$1
  local GREEN=$2
  local BLUE=$3
  
  # assign escape code string ---------------------------------------------------
  #   if option fourth arg exists, then try to assign values to variable of the same name
  #   else assign values to default global variable
  if [[ $# -gt 3 ]]; then
    ttui::debug_logger "4th arg found: $4"
    # check if the string value of myVar is the name of a declared variable
    local varName="$4"
    # myVar='$'"$4"
    local bVarExists=false
    local test='if ${'"${varName}"'+"false"}; then ttui::debug_logger "${varName} not defined"; else bVarExists=true; ttui::debug_logger "${varName} is defined"; fi'
    ttui::debug_logger "test: $test"
    eval $test
    ttui::debug_logger  "bVarExists: ${bVarExists}"

    if [[ $bVarExists == true ]]; then
      local assignment="${varName}"'="\033[38;2;${RED};${GREEN};${BLUE}m"'
      ttui::debug_logger  "assignment: ${assignment}"
      eval $assignment
    else
      echo "${FUNCNAME[0]} --> warning: cannot assign RGB color escape code to ${varName}: undelcared variable"
    fi
  else
    ttui::debug_logger "no var name provided. Assigning RGB color escape code to TTUI_COLOR_RGB_FROM_LCH"
    TTUI_COLOR_RGB='\033[38;2;'"${RED};${GREEN};${BLUE}"'m'
  fi
}


# -----------------------------------------------------------------------------
# Sets color to specified RGB value.
# This color will remain active until the it is intentionally reset.
# Globals:
#   none
# Arguments:
#   position 1:  Red    value (0-255)
#   position 2:  Blue   value (0-255)
#   position 3:  Green  value (0-255)
# -----------------------------------------------------------------------------
ttui::set_color_rgb() {
  ttui::debug_logger "received $# args"
  local expanded_args=$(echo "$@")
  ttui::debug_logger "args received: $expanded_args"

  ##########  TODO:
  ##########  check that args in position 1, 2, 3 are numbers 
  ##########  and that they are within the legal range for RGB
  ##########  values: 0-255
  
  local RED=$1
  local GREEN=$2
  local BLUE=$3

  printf "\033[38;2;%d;%d;%dm" ${RED} ${GREEN} ${BLUE};

  ttui::debug_logger "** execution complete **"
}


# -----------------------------------------------------------------------------
# Sets color to terminal default.
# Globals:
#   none
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::reset_color() {
  printf "\033[0m"
}


# -----------------------------------------------------------------------------
# Confirms that this script has been loaded and functions are available
# Globals:
#   none
# Arguments:
#   none
# -----------------------------------------------------------------------------
ttui::lib_is_loaded() {
  echo "ttui_lib is loaded"
}
