#!/bin/bash
# Exit on error.
set -ex

echo $0 $1 $2 $3
EX_USAGE=64 # Usage error exit code from /usr/include/sysexits.h

OUTPUT_FORMAT=
ASCIIDOCTOR_ARGS=

while getopts "f:a:" arg; do
  case "${arg}" in
    f)
      OUTPUT_FORMAT=${OPTARG}
      ;;
    a)
      ASCIIDOCTOR_ARGS=${OPTARG}
      ;;
    :)
      printf "Expected -${OPTARG} to have a value\n" >&2
      exit $EX_USAGE
      ;;
    *)
      printf "Unexpected arg ${OPTARG}\n" >&2
      exit $EX_USAGE
      ;;
  esac
done
shift $((OPTIND-1))

read -r INPUT_FILES <<<$*

ASCIIDOCTOR=asciidoctor
if [[ "pdf" = $OUTPUT_FORMAT ]]; then
  ASCIIDOCTOR=asciidoctor-pdf
fi

printf "$*\n" >&2
if [[ -z $INPUT_FILES ]]; then
  printf "No input files specified\n" >&2
  exit $EX_USAGE
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
    printf "Ran unexpected commands:\n$commands\nvs\n$TEST\n" >&2
    exit 1
  fi

fi
