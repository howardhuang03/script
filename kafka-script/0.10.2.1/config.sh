#!/usr/bin/env bash

ZOOKEEPER=172.16.2.26:3181/kafka
SERVER=172.16.2.26:10092
KAFKA=kafka_2.11-0.10.2.1
printf "Configuration:\n"
printf "  Kafka directory: $KAFKA\n  zookeeper: $ZOOKEEPER\n  bootstrap_server: $SERVER\n\n"
cd /opt
