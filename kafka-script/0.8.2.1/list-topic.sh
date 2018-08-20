#!/usr/bin/env bash

. config.sh

# List existing topics
$KAFKA/bin/kafka-topics.sh --list \
    --zookeeper $ZOOKEEPER
