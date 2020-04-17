#!/usr/bin/env bats
#
# From root folder run: ./cleanme.sh.

setup() {
    source cleanme.sh
    mkdir -p /tmp/cleanme_files/tests/__pycache__
    mkdir /tmp/cleanme_files/.pytest_cache
    mkdir /tmp/cleanme_files/htmlcov
    touch /tmp/cleanme_files/.coverage
    mkdir /tmp/cleanme_files/library
    ln -s /tmp/cleanme_files/library /tmp/cleanme_files/tests/library
}

teardown() {
    rm -r /tmp/cleanme_files
}

@test 'Show help with help function.' {
    [[ "$(help)" == *'Cleanup the enviroment'* ]]
}

@test 'Show help with cleanme script.' {
    run ./cleanme.sh -h
    [[ "$output" == *'Cleanup the enviroment'* ]]
}

@test 'Get parameters.' {
    get_parameters '-p /tmp/cleanme_files'
    [[ $PROJECT_PATH == '/tmp/cleanme_files' ]]
}

@test 'Cleanup python.' {
    cleanup_python /tmp/cleanme_files
    ! [[ -d /tmp/cleanme_files/htmlcov ]]
    ! [[ -f /tmp/cleanme_files/.pytest_cache ]]
}

@test 'Cleanup ansible.' {
    apt install -y ansible python3 python3-pip python3-setuptools
    mkdir -p ~/.ansible/roles/unify
    UNINSTALL=true
    run cleanup_ansible /tmp/cleanme_files
    [ $status -eq 0 ]
}