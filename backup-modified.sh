#!/bin/bash
# jenkins backup scripts

date=`date +"%d%m%y%H%M"`
readonly JENKINS_HOME="/var/lib/jenkins/"
readonly DEST_FILE="/root/zubair/"
readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
readonly TMP_DIR="${CUR_DIR}/tmp"
readonly ARC_NAME="jenkins-backup"
readonly ARC_DIR="${TMP_DIR}/${ARC_NAME}"
readonly TMP_TAR_NAME="${TMP_DIR}/$date.tar"

function cleanup() {
  rm -rf "${ARC_DIR}"
}

function main() {
  if [ -z "${JENKINS_HOME}" -o -z "${DEST_FILE}" ] ; then
    usage >&2
    exit 1
  fi

  rm -rf "${ARC_DIR}" "{$TMP_TAR_NAME}"
 for plugin in plugins jobs users secrets nodes; do
    mkdir -p "${ARC_DIR}/${plugin}"
 done

  if [ "$(ls -A ${JENKINS_HOME}/)" ]; then
    cp -R "${JENKINS_HOME}/"* "${ARC_DIR}"
  fi

  cd "${TMP_DIR}"
  tar -czvf "${TMP_TAR_NAME}" "${ARC_NAME}/"*
  cd -
  mv -f "${TMP_TAR_NAME}" "${DEST_FILE}"
  cleanup
  exit 0
}
main
