#!/bin/bash
set -e

RAMSIN_INITIAL_PATH=${1}
RAMSIN_HISTORY_PATH=${RAMSIN_INITIAL_PATH}-history
HISTORY_DIR_PATH=$(grep "HFILOUT" ${RAMSIN_INITIAL_PATH} | cut -d"'" -f2)
HISTORY_HEAD_FILE=$(ls "${HISTORY_DIR_PATH}"-*.txt -tr  | tail -n 1)
HISTORY_HOUR=$(echo ${HISTORY_HEAD_FILE} | tail -c 16 | head -c 2)


cp ${RAMSIN_INITIAL_PATH} ${RAMSIN_HISTORY_PATH}

sed -i "/RUNTYPE/s/'[^>]*'/'HISTORY'/" ${RAMSIN_HISTORY_PATH}
sed -i "/TIMSTR/s|[0-9]\+|${HISTORY_HOUR}|" ${RAMSIN_HISTORY_PATH}
sed -i "/HFILIN/s|'[^>]*'|'${HISTORY_HEAD_FILE}'|" ${RAMSIN_HISTORY_PATH}
