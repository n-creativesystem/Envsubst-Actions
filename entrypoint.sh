#!/bin/sh

envsubst < ${INPUT_INPUT} > ${INPUT_OUTPUT}
cat ${INPUT_OUTPUT}