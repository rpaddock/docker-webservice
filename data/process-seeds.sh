#!/bin/sh
if [ "$RUN_SEEDS" = "true" ]; then
    echo "RUN_SEEDS is set. Processing seed files."

    dir="$( cd "$( dirname "${BASH_SOURCE:-$_}" )" && pwd )"
    user="${MYSQL_USER:?MYSQL_USER env var must be set}"
    pass="${MYSQL_PASSWORD:?MYSQL_PASSWORD env var must be set}"
    db="${MYSQL_DATABASE:?MYSQL_DATABASE env var must be set}"

    echo "[client]\nuser=$user\npassword=$pass\ndatabase=$db\n" > /tmp/mysqlsecret.cnf

    seeds=$dir/seeds/*.sql

    for f in $seeds
    do
    mysql --defaults-file=/tmp/mysqlsecret.cnf $db < $f
    done
    
    rm /tmp/mysqlsecret.cnf
fi

