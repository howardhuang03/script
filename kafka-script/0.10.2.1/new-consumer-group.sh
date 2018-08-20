#!/usr/bin/env bash

. config.sh

GROUP=$1

if [ -z $GROUP ]; then
    echo "Please enter the Group you want to check, EX: ./new_consumer_group.sh logstash_group13"
    echo "Following are avalible new consumer groups:"
    $KAFKA/bin/kafka-consumer-groups.sh --list \
        --bootstrap-server $SERVER
    exit 0
fi

$KAFKA/bin/kafka-consumer-groups.sh --describe \
    --bootstrap-server $SERVER \
    --group $GROUP
