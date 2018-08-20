#!/usr/bin/env bash

. config.sh

GROUP=$1

if [ -z $GROUP ]; then
    echo "Please enter the Group you want to check, EX: ./old_consumer_group.sh logstash_group13"
    echo "Following are availabe old consumer groups:"
    $KAFKA/bin/kafka-consumer-groups.sh --list \
        --zookeeper $ZOOKEEPER
    exit 0
fi

echo "Kafka version: $KAFKA"
## List all topics
$KAFKA/bin/kafka-consumer-groups.sh --describe \
    --zookeeper $ZOOKEEPER \
    --group $GROUP

