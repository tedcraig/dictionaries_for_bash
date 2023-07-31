#! /usr/bin/env bash

# =============================================================================
#
#   name:   Hashmap_tester.sh
#   auth:   ted craig
#
#   desc:   tests functionality of Hashmap.sh and Term_logger.sh during 
#           development of those scripts.
#
#   dependancies:   ttui_lib.sh, Hashmap.sh, Term_logger.sh
#
# =============================================================================

# -----------------------------------------------------------------------------
#   imports
# -----------------------------------------------------------------------------
## import "hashmap" functionality
source ./Hashmap.sh
source ./Term_logger.sh

[[ "${TTUI_LOADED}" != "true" ]] && {
  source /opt/ttui/ttui_lib.sh
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
                  title_justification=centered \
                  box_justification=centered"


# -----------------------------------------------------------------------------
#   create hashmap 1
# -----------------------------------------------------------------------------
create_hashmap_one() {

  ## create a hashmap without setting any initial values
  tlog::print::title_box title="HASHMAP ONE" $TITLE_BOX_DEFAULTS

  ttui::color::set_color_to_rgb "${DESC}"
  echo "Hashmap::create hmOne"
  ttui::color::set_color_to_rgb "${DEBUG}"
  Hashmap::create hmOne
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::add age=48"
  ttui::color::set_color_to_rgb "${DEBUG}"
  hmOne::add age=48
  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::add name=djthadius"
  ttui::color::set_color_to_rgb "${DEBUG}"
  hmOne::add name=djthadius
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::get age -> assign to AGE"
  ttui::color::set_color_to_rgb "${DEBUG}"
  AGE=$(hmOne::get age)
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "AGE: $AGE"
  echo
  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::get name --> assign to NAME"
  ttui::color::set_color_to_rgb "${DEBUG}"
  NAME=$(hmOne::get name)
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
  echo "hmOne::add id=12345"
  ttui::color::set_color_to_rgb "${DEBUG}"
  hmOne::add id=12345
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "listing pairs..."
  ttui::color::set_color_to_rgb "${RESULT}"
  hmOne::list
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::delete name"
  ttui::color::set_color_to_rgb "${DEBUG}"
  hmOne::delete "name"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "listing pairs..."
  ttui::color::set_color_to_rgb "${RESULT}"
  hmOne::list
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne_AVAILABLE_INDEXES:"
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "${hmOne_AVAILABLE_INDEXES[@]}"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::add car=lotus"
  ttui::color::set_color_to_rgb "${DEBUG}"
  hmOne::add car=lotus
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "listing pairs..."
  ttui::color::set_color_to_rgb "${RESULT}"
  hmOne::list
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::list_resources"
  ttui::color::set_color_to_rgb "${RESULT}"
  hmOne::list_resources
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::delete car"
  ttui::color::set_color_to_rgb "${DEBUG}"
  hmOne::delete "car"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::list_resources"
  ttui::color::set_color_to_rgb "${RESULT}"
  hmOne::list_resources
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::add range=far"
  ttui::color::set_color_to_rgb "${DEBUG}"
  hmOne::add range=far
  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::add os=macos"
  ttui::color::set_color_to_rgb "${DEBUG}"
  hmOne::add os=macos
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::list_resources"
  ttui::color::set_color_to_rgb "${RESULT}"
  hmOne::list_resources
  ttui::color::reset
  echo
}


# -----------------------------------------------------------------------------
#   create hashmap 2
# -----------------------------------------------------------------------------
create_hashmap_two() {

  tlog::print::title_box title=HASHMAP_TWO $TITLE_BOX_DEFAULTS

  ttui::color::set_color_to_rgb "${DESC}"
  echo "Hashmap::create hmTwo name=Ted age=old"
  Hashmap::create hmTwo name=Ted age=old
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmTwo::get age"
  ttui::color::set_color_to_rgb "${RESULT}"
  hmTwo::get age
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmTwo::get name"
  ttui::color::set_color_to_rgb "${RESULT}"
  hmTwo::get name
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmTwo::get age -> assign to AGE2"
  AGE2=$(hmTwo::get age)
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "AGE2: $AGE2"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmTwo::get name --> assign to NAME2"
  NAME2=$(hmTwo::get name)
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "NAME2: $NAME2"
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "listing pairs..."
  ttui::color::set_color_to_rgb "${RESULT}"
  hmTwo::list
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
  echo "hmOne variable list:"
  ttui::color::set_color_to_rgb "${GREY}"
  compgen -A variable hmOne_
  echo

  ttui::color::reset
  echo "hmTwo variable list:"
  ttui::color::set_color_to_rgb "${GREY}"
  compgen -A variable hmTwo_

  ttui::color::reset

}


test_print_array() {

  echo "Print Array test:"
  test_array=(joe blow rogan)
  Hashmap::print_array test_array

}


# -----------------------------------------------------------------------------
#   main
# -----------------------------------------------------------------------------
main() {

  # test_print_array  

  create_hashmap_one

  # create_hashmap_two

  

  # show_functions_and_variables


}

## invoke main
main $@


