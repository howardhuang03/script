#!/usr/bin/env bash

. config.sh

TOPIC=test-topic

if [ ! -z "$1" ]; then
    TOPIC=$(echo $1)
fi

echo "subscribe $TOPIC"
$KAFKA/bin/kafka-console-consumer.sh \
    --bootstrap-server $SERVER \
    --topic $TOPIC \
    --consumer-property group.id=mygroup
