#!/usr/bin/env bash

KAFKA=/opt/kafka_2.11-1.0.1
ZOOKEEPER=172.16.2.26:4181/kafka
BOOTSTRAP=172.16.2.26:11092
printf "Configuration:\n"
printf "  Kafka directory: $KAFKA\n  zookeeper: $ZOOKEEPER\n  bootstrap_server: $BOOTSTRAP\n\n"
