#!/bin/sh

envsubst < ${INPUT_INPUT} > ${INPUT_OUTPUT}

if [ "${INPUT_DEBUG}" = "true" ]; then
    cat ${INPUT_OUTPUT}
fi
