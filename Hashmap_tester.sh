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
GREY="128 128 128"
YELLOW="255 204 110"
GOLD="200 150 0"
GOLD2="173 156 123"
WHITE="200 200 200"

TITLE_COLOR=${RED// /,} # substitue , for spaces

# title_color=50,180,170 box_color=50,120,110

DESC="${WHITE}"
RESULT="${GREY}"

TITLE_BOX_DEFAULTS="title_color=255,50,50 \
                box_color=160,50,50 \
                box_width=40 \
                pad_horizontal=2 \
                title_justification=centered"


# -----------------------------------------------------------------------------
#   create hashmap 1
# -----------------------------------------------------------------------------
create_hashmap_one() {

  ## create a hashmap without setting any initial values
  tlog::title_box title=HASHMAP_ONE $TITLE_BOX_DEFAULTS

  ttui::color::set_color_to_rgb "${DESC}"
  echo "create_hashmap hmOne"
  ttui::color::reset
  create_hashmap hmOne
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "adding age and name to hmOne"
  ttui::color::set_color_to_rgb "${RESULT}"
  hmOne::add age=48
  hmOne::add name=djthadius
  ttui::color::reset
  echo

  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::get age -> assign to AGE"
  AGE=$(hmOne::get age)
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "AGE: $AGE"
  echo
  ttui::color::set_color_to_rgb "${DESC}"
  echo "hmOne::get name --> assign to NAME"
  NAME=$(hmOne::get name)
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "NAME: $NAME"
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
  echo "hmOne_AVAILABLE_INDEXES:"
  ttui::color::set_color_to_rgb "${RESULT}"
  echo "${hmOne_AVALIABLE_INDEXES[@]}"
  ttui::color::reset
  echo

}


# -----------------------------------------------------------------------------
#   create hashmap 2
# -----------------------------------------------------------------------------
create_hashmap_two() {

  tlog::title_box title=HASHMAP_TWO $TITLE_BOX_DEFAULTS

  ttui::color::set_color_to_rgb "${DESC}"
  echo "create_hashmap hmTwo name=Ted age=old"
  create_hashmap hmTwo name=Ted age=old
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

  tlog::title_box title=DECLARED_FUNCTIONS_AND_VARIABLES $TITLE_BOX_DEFAULTS

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


# -----------------------------------------------------------------------------
#   test title box
# -----------------------------------------------------------------------------
test_title_box() {

  tlog::title_box title=TITLE_BOX_TEST \
                  title_color=50,255,50 \
                  box_color=50,160,50 \
                  box_width=40 \
                  box_height=5 \
                  pad_horizontal=2 \
                  title_justification=centered
  echo
  tlog::title_box title=TITLE_BOX_TEST \
                  title_color=255,50,50 \
                  box_color=160,50,50 \
                  box_width=40 \
                  box_height=5 \
                  pad_horizontal=2 \
                  title_justification=left
  echo
  tlog::title_box title=TITLE_BOX_TEST \
                  title_color=25,50,255 \
                  box_color=25,50,160 \
                  box_width=40 \
                  box_height=5 \
                  pad_horizontal=2 \
                  title_justification=right

}



# -----------------------------------------------------------------------------
#   main
# -----------------------------------------------------------------------------
main() {

  create_hashmap_one

  create_hashmap_two

  # show_functions_and_variables

  # test_title_box

}

## invoke main
main $@


