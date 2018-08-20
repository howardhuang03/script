#!/usr/bin/env bash

. config.sh

TOPIC=$1
PARTITION=$2

if [ -z $TOPIC ]; then
    echo "Please enter the topic you want to create, following list is existed topic:"
    ## List created topics
    $KAFKA/bin/kafka-topics.sh --list \
        --zookeeper $ZOOKEEPER
    exit 0
fi

if [ -z $PARTITION ]; then
    echo "Please enter the partition you want to use, ex: ./create_topic.sh test_topic 15"
    exit 0
fi


$KAFKA/bin/kafka-topics.sh --create \
    --replication-factor 3 \
    --partitions $PARTITION \
    --topic $TOPIC \
    --zookeeper  $ZOOKEEPER


## List created topics
$KAFKA/bin/kafka-topics.sh --list \
    --zookeeper $ZOOKEEPER
