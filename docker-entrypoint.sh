#!/bin/sh
set -e

is_db_ready() {
    nc -z $DB_PORT_3306_TCP_ADDR 3306
}

wait_for_db() {
    if [ -z "$DB_PORT_3306_TCP_ADDR" ]; then
        echo "Skipping database wait checks"
        return 0;
    fi
    WAIT_LOOPS=${WAIT_LOOPS:-10}
    WAIT_SLEEP=${WAIT_SLEEP:-5}
    i=0
    while ! is_db_ready; do
        i=`expr $i + 1`
        if [ $i -ge $WAIT_LOOPS ]; then
            echo "Database still not ready, giving up"
            exit 1
        fi
        echo "Waiting for database to be ready"
        sleep $WAIT_SLEEP
    done
}

# Put application specific setup into this function
app_setup() {
}

if [ "$1" = 'php-fpm' ]; then
    # Uncomment the line below to enable db dependency waiting
    # wait_for_db

    app_setup 

    exec gosu root "$@"
fi

exec "$@"

