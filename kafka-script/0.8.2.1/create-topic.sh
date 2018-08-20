#!/usr/bin/env bash

. config.sh

TOPIC=$1

if [ -z $TOPIC ]; then
    echo "Please enter the topic you want to create, following list is existed topic:"
    ## List created topics
    $KAFKA/bin/kafka-topics.sh --list \
        --zookeeper $ZOOKEEPER
    exit 0
fi

$KAFKA/bin/kafka-topics.sh --create \
    --replication-factor 3 \
    --partitions 15 \
    --topic $TOPIC \
    --zookeeper  $ZOOKEEPER


## List created topics
$KAFKA/bin/kafka-topics.sh --list \
    --zookeeper $ZOOKEEPER
