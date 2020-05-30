#!/bin/bash
# -l = login shell
read -r OUTPUT_FORMAT ASCIIDOCTOR_ARGS INPUT_FILES <<<$*

ASCIIDOCTOR=asciidoctor
if [[ "pdf" = $OUTPUT_FORMAT ]]; then
  ASCIIDOCTOR=asciidoctor-pdf
fi

if [[ -z $INPUT_FILES ]]; then
  echo "No input files specified" 1&>2
  exit 64 # EX_USAGE from /usr/include/sysexits.h
fi

# TEST env variable indicates we should be in testing mode (below).
if [[ -z $TEST ]]; then
  for file in $(ls $INPUT_FILES); do
    set +x
    $ASCIIDOCTOR -r asciidoctor-diagram $ASCIIDOCTOR_ARGS $INPUT_FILES
  done
else
  echo "" > test
  for file in $(ls $INPUT_FILES); do
    set +x
    echo "$ASCIIDOCTOR -r asciidoctor-diagram $ASCIIDOCTOR_ARGS $file" >> test
  done

  commands=$(cat test)
  if [[ $commands = $TEST ]]; then 
    echo "Commands equal test expectations."
    exit 0
  else                                                                             
    printf "Ran unexpected commands:\n$commands\nvs\n$TEST"                            
    exit 1
  fi

fi
