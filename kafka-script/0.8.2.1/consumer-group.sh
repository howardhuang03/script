#!/usr/bin/env bash

. config.sh

GROUP=$1
TOPIC=$2

if [ -z $GROUP ]; then
    echo "Please enter the Group you want to check, EX: ./consumer_group.sh logstash_group13 combine-201801"
    exit 0
fi

if [ -z $TOPIC ]; then
    ## List all topics
    $KAFKA/bin/kafka-consumer-offset-checker.sh \
        --zookeeper $ZOOKEEPER \
        --group $GROUP
    exit 0
fi

$KAFKA/bin/kafka-consumer-offset-checker.sh \
    --zookeeper $ZOOKEEPER \
    --group $GROUP \
    --topic $TOPIC
