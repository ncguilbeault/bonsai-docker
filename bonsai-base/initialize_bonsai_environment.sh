#!/bin/bash

: ${WORKDIR:=/bonsai}
echo "Working directory is set to '$WORKDIR'"

if [ ! -d "$WORKDIR" ]; then
   mkdir -p $WORKDIR
fi

if [ ! -d "$WORKDIR/.bonsai" ]; then
   mkdir -p $WORKDIR/.bonsai
fi

if [ -z "$(ls -A $WORKDIR/.bonsai)" ]; then
   cp -a /.bonsai $WORKDIR
   echo "Bonsai environment initialized in $WORKDIR/.bonsai"
else
   echo "Bonsai environment detected in $WORKDIR/.bonsai"
fi

rm -rf /.bonsai

cd $WORKDIR
source ".bonsai/activate"

if [ "$#" -eq 0 ]; then
   source ".bonsai/run"
else
   source ".bonsai/run" "$@"
fi