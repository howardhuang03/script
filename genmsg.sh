#!/bin/bash
# This script is for the usage of fake play generation in realtime streaming developement

PROGNAME=$(basename $0)
# Modify PATH to the KAFKA parent path
PLAYFILE=/tmp/test.txt

# Message default value
LEN=10
LENMILLIS=$(( $LEN*1000 ))
START=`date +%s000`
MEDIAID=`echo $START |cut -b8-13`

# Kafka parameter
ADDR=172.16.2.26:10092
KAFKA=/opt/kafka_2.11-0.10.2.1

# Show help
function show_help() {
cat <<- EOF
$PROGNAME -s [startTime] -l [length] -k [watcher|ots|media]
  Usage:
    -s: Input play start time in epoch time second
    -l: Input play length in time second
    -k: Generate watcher/ots/media msg and send to broker by kafka producer
EOF
}

template_W() {
    echo "{\"accountID\":99,\"timezone\":\"Asia/Taipei\",\"estimatedDist\":320,\"attentionStartTime\":[$START],\"ageValue\":15,\"gender\":2,\"mood\":0,\"extraFeatures\":0,\"duration\":$LENMILLIS,\"ageBracket\":1,\"attentionTime\":[$LENMILLIS],\"startTime\":$START,\"watcherID\":635,\"numGlances\":1,\"boxID\":\"testID\",\"status\":3}"
}

template_O() {
    echo "{\"accountID\":99,\"timezone\":\"Asia/Taipei\",\"duration\":90000,\"viewers\":10,\"count\":25,\"startTime\":$START,\"boxID\":\"testID\",\"status\":0}"
}

template_M() {
    END=`expr $START + $LENMILLIS`
    echo "{\"accountID\":99,\"timezone\":\"Asia/Taipei\",\"length\":$LENMILLIS,\"mediaID\":\"media-$MEDIAID\",\"startTime\":$START,\"endTime\":$END,\"reserved\":0,\"boxID\":\"testID\",\"playlist\":\"test_playlist\"}"
}

function template() {
    flag=$1
    case $flag in
    watcher)
        template_W
        ;;
    ots)
        template_O
        ;;
    media)
        template_M
        ;;
    *)
        printf "Flag $flag not found, exit...."
        exit 1
        ;;
    esac
}

function topic() {
    flag=$1
    case $flag in
    watcher)
        echo "stream-watcher"
        ;;
    ots)
        echo "stream-ots"
        ;;
    media)
        echo "stream-media"
        ;;
    *)
        printf "Flag $flag not found, exit...."
        exit 1
        ;;
    esac
}

function run_kafka() {
    flag=$1 
    msg=`template $1`
    if [ $? -eq 0 ]; then
        echo "$flag:"
        echo $msg
    else
        echo $msg
        exit 1
    fi
    TOPIC=`topic $flag`

    touch $PLAYFILE
    echo $msg > $PLAYFILE
    $KAFKA/bin/kafka-console-producer.sh --broker-list $ADDR --topic $TOPIC < $PLAYFILE
}

function main() {
    while getopts :s:l:k: flag
    do
        case $flag in
        s)
            START=$OPTARG
            echo "startTime set to $START"
            ;;
        l)
            LEN=$OPTARG
            LENMILLIS=$(( $LEN*1000 ))
            echo "Length set to $LEN second"
            ;;
        k)
            run_kafka $OPTARG
            ;;
        \?)
            show_help
            exit 0
            ;;
        esac
    done
}

# Start main process
[ -z "$1" ] && main -h
main "$@"
