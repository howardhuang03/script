#!/usr/bin/env bash

. config.sh

TOPIC=$1

if [ -z $TOPIC ]; then
    echo "Please enter the topic you want to see the description:"
    ## List created topics
    $KAFKA/bin/kafka-topics.sh --list \
        --zookeeper $ZOOKEEPER
    exit 0
fi

echo "Describe topic $1"
# List existing topics
$KAFKA/bin/kafka-topics.sh --describe \
    --topic $TOPIC \
    --zookeeper $ZOOKEEPER
