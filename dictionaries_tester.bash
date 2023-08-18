#! /usr/bin/env bash

# =============================================================================
#
#   name:   dictionaries_tester.bash
#   auth:   ted craig
#
#   desc:   tests functionality of dictionaries_for_bash library during development.
#
#   dependancies:   ttui_lib.sh, dictionaries_for_bash, Term_logger.sh
#
# =============================================================================

# -----------------------------------------------------------------------------
#   imports
# -----------------------------------------------------------------------------
## import "dictionary" functionality
source ./dictionaries_for_bash
source ../term_logger/Term_logger.sh

[[ "${TTUI_LOADED}" != "true" ]] && {
  source ~/scripts/ttui/ttui_lib.sh
}


# -----------------------------------------------------------------------------
#   globals / defaults
# -----------------------------------------------------------------------------
## setup colors
RED="255 50 50"
GREEN="50 196 50"
BLUE="50 50 196"
GREY="114 114 114"
YELLOW="255 204 110"
GOLD="200 150 0"
GOLD2="173 156 123"
WHITE="212 212 212"

TITLE_COLOR=${RED// /,} # substitue , for spaces

# title_color=50,180,170 box_color=50,120,110

DESC="${WHITE}"
RESULT="${GOLD2}"
DEBUG="${GREY}"

# TITLE_BOX_DEFAULTS="title_color=255,50,50 \
#                 box_color=160,50,50 \
#                 box_width=40 \
#                 pad_horizontal=2 \
#                 title_justification=centered"

TITLE_BOX_DEFAULTS="title_color=255,50,50 \
                  box_color=160,50,50 \
                  box_width=$(ttui::get_term_width force) \
                  box_height=3 \
                  pad_horizontal=2 \
                  title_justification=center \
                  box_justification=centered"


# -----------------------------------------------------------------------------
#   create dictionary 1
# -----------------------------------------------------------------------------
create_dictionary_one() {

  ## create a dictionary without setting any initial values
  tlog::print::title_box title="DICTIONARY ONE" $TITLE_BOX_DEFAULTS

  ttui::color::set_color_to_rgb "${DESC}"
  echo "Dictionary::create dictOne"
  ttui::color::set_color_to_rgb "${DEBUG}"
  Dictionary::create dictOne
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::add age=48"
  ttui::color::set_color_to_rgb "${DEBUG}"
  dictOne::add age=48
  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::add name=djthadius"
  ttui::color::set_color_to_rgb "${DEBUG}"
  dictOne::add name=djthadius
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::get age -> assign to AGE"
  ttui::color::set_color_to_rgb "${DEBUG}"
  AGE=$(dictOne::get age)
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "AGE: $AGE"
  echo
  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::get name --> assign to NAME"
  ttui::color::set_color_to_rgb "${DEBUG}"
  NAME=$(dictOne::get name)
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "NAME: $NAME"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "Test assignment of array values via echo"
  arr=($(other_func))
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "  array length: ${#arr[@]}"
  echo "array contents: ${arr[@]}"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::add id=12345"
  ttui::color::set_color_to_rgb "${DEBUG}"
  dictOne::add id=12345
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "listing pairs..."
  ttui::color::set_color_to_rgb "${RESULT}"
  dictOne::list
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::delete name"
  ttui::color::set_color_to_rgb "${DEBUG}"
  dictOne::delete "name"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "listing pairs..."
  ttui::color::set_color_to_rgb "${RESULT}"
  dictOne::list
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne_AVAILABLE_INDEXES:"
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "${dictOne_AVAILABLE_INDEXES[@]}"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::add car=lotus"
  ttui::color::set_color_to_rgb "${DEBUG}"
  dictOne::add car=lotus
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "listing pairs..."
  ttui::color::set_color_to_rgb "${RESULT}"
  dictOne::list
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::list_resources"
  ttui::color::set_color_to_rgb "${RESULT}"
  dictOne::list_resources
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::delete car"
  ttui::color::set_color_to_rgb "${DEBUG}"
  dictOne::delete "car"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::list_resources"
  ttui::color::set_color_to_rgb "${RESULT}"
  dictOne::list_resources
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::add range=far"
  ttui::color::set_color_to_rgb "${DEBUG}"
  dictOne::add range=far
  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::add os=macos"
  ttui::color::set_color_to_rgb "${DEBUG}"
  dictOne::add os=macos
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictOne::list_resources"
  ttui::color::set_color_to_rgb "${RESULT}"
  dictOne::list_resources
  ttui::color::reset
  echo
}


# -----------------------------------------------------------------------------
#   create dictionary 2
# -----------------------------------------------------------------------------
create_dictionary_two() {

  tlog::print::title_box title=DICTIONARY_TWO $TITLE_BOX_DEFAULTS

  ttui::color::set_color_to_rgb "${DESC}"
  echo "Dictionary::create dictTwo name=Ted age=old"
  Dictionary::create dictTwo name=Ted age=old
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictTwo::get age"
  ttui::color::set_color_to_rgb "${RESULT}"
  dictTwo::get age
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictTwo::get name"
  ttui::color::set_color_to_rgb "${RESULT}"
  dictTwo::get name
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictTwo::get age -> assign to AGE2"
  AGE2=$(dictTwo::get age)
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "AGE2: $AGE2"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "dictTwo::get name --> assign to NAME2"
  NAME2=$(dictTwo::get name)
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "NAME2: $NAME2"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "listing pairs..."
  ttui::color::set_color_to_rgb "${RESULT}"
  dictTwo::list
  ttui::color::reset
  echo

}


# -----------------------------------------------------------------------------
#   show functions and variables
# -----------------------------------------------------------------------------
show_functions_and_variables() {

  tlog::print::title_box title=DECLARED_FUNCTIONS_AND_VARIABLES $TITLE_BOX_DEFAULTS

  echo "function list:"
  ttui::color::set_color_to_rgb "${GREY}"
  compgen -A function
  echo

  ttui::color::reset
  echo "dictOne variable list:"
  ttui::color::set_color_to_rgb "${GREY}"
  compgen -A variable dictOne_
  echo

  ttui::color::reset
  echo "dictTwo variable list:"
  ttui::color::set_color_to_rgb "${GREY}"
  compgen -A variable dictTwo_

  ttui::color::reset

}


test_print_array() {

  echo "Print Array test:"
  test_array=(joe blow rogan)
  Dictionary::print_array test_array

}


# -----------------------------------------------------------------------------
#   main
# -----------------------------------------------------------------------------
main() {

  # test_print_array  

  create_dictionary_one

  # create_dictionary_two

  

  # show_functions_and_variables


}

## invoke main
main $@


