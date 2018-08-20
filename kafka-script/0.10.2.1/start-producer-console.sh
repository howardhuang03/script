#!/usr/bin/env bash

. config.sh

TOPIC=test-topic

if [ ! -z "$1" ]; then
    echo "Use input topic: $1"
    TOPIC=$(echo $1)
fi

$KAFKA/bin/kafka-console-producer.sh \
    --broker-list $SERVER \
    --topic $TOPIC

