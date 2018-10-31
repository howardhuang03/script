#!/usr/bin/env bash

. config.sh

TOPIC=$1
GROUP=$2
OFFSET=$3
TMP_OFFSET_FILE=/tmp/topic-offset

list_topic() {
    $KAFKA/bin/kafka-topics.sh --list \
        --zookeeper $ZOOKEEPER
}

list_group() {
    $KAFKA/bin/kafka-consumer-groups.sh --list \
        --bootstrap-server $SERVER
}

list_offset() {
    $KAFKA/bin/kafka-consumer-groups.sh --describe \
        --bootstrap-server $SERVER \
        --group $GROUP
}

hack_offset() {
    PATITION=$1
    $KAFKA/bin/kafka-console-consumer.sh --bootstrap-server $SERVER \
    --topic $TOPIC \
    --partition $PATITION \
    --consumer-property group.id=$GROUP \
    --max-messages 1 \
    --offset $OFFSET 
}

if [ -z $GROUP ]; then
    echo "Please enter the consumer group you want to hack:"
    ## List consumer groups
    list_group
    exit 0
else
    ## Check the group is exist
    TMPFILE=/tmp/consumer_group
    list_group > $TMPFILE
    CHECK=`cat $TMPFILE| grep $GROUP`
    if [ -z $CHECK ]; then
        echo "Invalid group[$GROUP], please use following valid group:"
        list_group
        exit 0
    fi
    echo "Group $GROUP check completed"
fi

if [ -z $TOPIC ]; then
    echo "Please enter the topic you want to hack:"
    ## List created topics
    list_topic
    exit 0
else
    ## Check the topic is exist
    list_offset|grep $TOPIC > $TMP_OFFSET_FILE
    CHECK=`list_topic | grep $TOPIC`
    if [ -z $CHECK ]; then
        echo "Invalid topic[$TOPIC], please use following valid topic:"
        list_topic
        exit 0
    fi
    echo "Topic $TOPIC check completed"
fi

if [ -z $OFFSET ]; then
    echo "Please enter the offest you want to hack for the topic[$TOPIC] and consumer group[$GROUP]:"
    ## List consumer groups
    list_offset
    exit 0
else
    list_offset|grep $TOPIC > $TMP_OFFSET_FILE
    if [ ! -s $TMP_OFFSET_FILE ]; then
        echo "Can't find the topic[$TOPIC] in the group[$GROUP]"
        exit 0
    fi
    while read line; do
        PARTITION=`echo $line|awk -F ' ' '{print $2}'`
        END=`echo $line|awk -F ' ' '{print $4}'`
        # echo "OFFSET: $OFFSET, END: $END"
        if [ $OFFSET -gt $END ]; then
            echo "Warning: offset $OFFSET in partition $PARTITION is invalid, end is $END"
        fi
    done < $TMP_OFFSET_FILE
fi

echo "Hack offest for the topic[$TOPIC] and consumer group[$GROUP]"
while read line; do
    END=`echo $line|awk -F ' ' '{print $4}'`
    if [ $OFFSET -gt $END ]; then
        echo "Skip: Input offset $OFFSET in partition $PARTITION is invalid, end is $END"
    else
        PARTITION=`echo $line|awk -F ' ' '{print $2}'`
        hack_offset $PARTITION
    fi
done < $TMP_OFFSET_FILE

list_offset
