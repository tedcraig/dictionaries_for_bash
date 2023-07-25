#! /usr/bin/env bash

# =============================================================================
#
#   name:   tlog_tester.sh
#   auth:   ted craig
#
#   desc:   tests functionality of Term_logger.sh during development.
#
#   dependancies:   Term_logger.sh (ttui_lib.sh)
#
# =============================================================================

# -----------------------------------------------------------------------------
#   imports
# -----------------------------------------------------------------------------
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

# -----------------------------------------------------------------------------
#   test title box
# -----------------------------------------------------------------------------
test_title_box() {

  tlog::print::title_box  title=TITLE_BOX_TEST \
                          title_color=50,255,50 \
                          box_color=50,160,50 \
                          box_width=40 \
                          box_height=5 \
                          pad_horizontal=2 \
                          title_justification=centered
  echo
  tlog::print::title_box  title=TITLE_BOX_TEST \
                          title_color=255,50,50 \
                          box_color=160,50,50 \
                          box_width=40 \
                          box_height=5 \
                          pad_horizontal=2 \
                          title_justification=left
  echo
  tlog::print::title_box  title=TITLE_BOX_TEST \
                          title_color=25,50,255 \
                          box_color=25,50,160 \
                          box_width=40 \
                          box_height=5 \
                          pad_horizontal=2 \
                          title_justification=right

}

test_print_info() {
  tlog::set_default_info_color 200 0 0
  tlog::print::info Test of print::info
  tlog::unset_default_info_color
  tlog::print::info Test of print::info when defult info color is unset
}

main() {

  tlog::print prop1=val1 text="myText" "text=all in quotes" text="only value in quotes" "no equal sign"

  test_print_info

  # test_title_box

}

## invoke main
main $@
