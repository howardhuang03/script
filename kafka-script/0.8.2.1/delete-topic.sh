#!/usr/bin/env bash

. config.sh

TOPIC=$1

if [ -z $TOPIC ]; then
    echo "Please enter the topic you want to delete:"
    ## List created topics
    $KAFKA/bin/kafka-topics.sh --list \
        --zookeeper $ZOOKEEPER
    exit 0
fi


# Delete existing topics
echo "To be deleted topic: $TOPIC"
$KAFKA/bin/kafka-topics.sh --delete --topic $1 \
    --zookeeper $ZOOKEEPER

## List created topics
$KAFKA/bin/kafka-topics.sh --list \
    --zookeeper $ZOOKEEPER
