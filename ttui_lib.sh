#! /usr/bin/env bash

# =============================================================================
#
#   name:   ttui_lib.sh
#   auth:   ted craig
#
#   desc:   Terminal UI library for Bash.
#
#   acknowledgment: Special thanks to Dylan Araps who has generously shared
#                   with the world their extensive knowledge of 
#                   shell scripting, especially the esoteric world of console
#                   control escape sequences.
#                   https://github.com/dylanaraps
#
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
  # Get the cursor position
  # '\e[6n'
  # IFS='[;' read -p $'\e7\e[9999;9999H\e[6n\e8' -d R -rs _ TTUI_TERM_LINES TTUI_TERM_COLUMNS
  ttui::debug_logger "${FUNCNAME[0]}: printf:"
  # printf '\e[6n'
  # echo "${FUNCNAME[0]}: read:"
  # IFS='[;' read -p $'\e[6n' -d R -rs _ TTUI_CURRENT_LINE TTUI_CURRENT_COLUMN
  # returns ^[[line;columnR --> eg. ^[[57;1R 
  # IFS value will split the response at [ and ;
  # -p -sr will print the escape sequence as the prompt (which will have the control effect on the terminal)
  # -sr will silence the prompt and ...
  # -d R will stop the read when char 'R' is encountered
  # this results in three values: '[', 'line', 'column'
  # we assign these values to vars listed at tail of the command
  #   [ --> _ (i.e. gets ignored)
  #   line --> TTUI_CURRENT_LINE
  #   column --> TTUI_CURRENT_COLUMN
  local old_ifs="$IFS"
    IFS='[;' read -p $'\e[6n' -d R -rs _ TTUI_CURRENT_LINE TTUI_CURRENT_COLUMN
  #\_______/
  #    |
  # overrides default
  # delimeters for
  # output of the read.
  # Will capture values
  # between [ and/or ; chars
  
  IFS="${old_ifs}"

  ttui::debug_logger "current position: Line ${TTUI_CURRENT_LINE} | Col ${TTUI_CURRENT_COLUMN}"
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
# Load notice
# -----------------------------------------------------------------------------
ttui::debug_logger "ttui_lib loaded"
