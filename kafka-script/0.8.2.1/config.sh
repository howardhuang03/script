#!/usr/bin/env bash

ZOOKEEPER=172.16.2.26:2181/kafka
KAFKA=kafka_2.11-0.8.2.1
printf "Configuration:\n"
printf "  Kafka directory: $KAFKA\n  zookeeper: $ZOOKEEPER\n\n"
cd /opt
