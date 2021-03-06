#!/bin/bash
THIS="${BASH_SOURCE##*/}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Run tests
echo "[${tests_name}] syntax-check: tests-all.sh" && {

  bash -n role-skeleton/tests/tests-all.sh
  
} &&
echo "[${tests_name}] syntax-check: ansible plugins" && {

  ( cd role-skeleton/tests/tasks/plugins && {

    check_in=0
    check_ng=0
    for pyscript in *.py
    do
      check_in=1
      echo "[${tests_name}] py_compile(plugins) - '${pyscript}':" &&
      python -m py_compile "${pyscript}" ||
      check_ng=$?
    done &&
    [ ${check_in} -ne 0 ] &&
    [ ${check_ng} -eq 0 ]

  }; ) &&
  : "End of pycompile."

} &&
echo "[${tests_name}] DONE."

# End
exit $?
