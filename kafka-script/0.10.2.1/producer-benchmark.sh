#!/usr/bin/env bash

. config.sh

TOPIC=$1

if [ -z $TOPIC ]; then
    echo "Please enter the topic you want to benchmark a producer:"
    ## List created topics
    $KAFKA/bin/kafka-topics.sh --list \
        --zookeeper $ZOOKEEPER
    exit 0
fi

echo "Benchmark producer start"
$KAFKA/bin/kafka-producer-perf-test.sh --topic $TOPIC \
--num-records 30 \
--record-size 4194304 \
--throughput 100000 \
--producer-props \
bootstrap.servers=$SERVER \
max.request.size=8388608 \
compression.type=none 
#batch.size=8388608

#acks=1 \
#bootstrap.servers=172.16.2.26:11092,172.16.2.27:11092,172.16.2.28:11092 \
#buffer.memory=67108864 \
#compression.type=none \
#batch.size=16384
