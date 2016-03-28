#!/bin/bash
# This script for the usage of protoc code generation

# include
. ~/Dropbox/Code/script/include/path.sh

CODE_PATH=$(Check_working_PATH)
CPP_PATH=$CODE_PATH/mocap-cpp.git/MocapRPC
GO_PATH=$CODE_PATH/godir/src/htc.com/mocap-go/rpc/protos

PROTO_FILE=mocaprpc.proto

# Show help
function show_help() {
	echo "$0 -c -g"
	echo "-c: Generate CPP grpc code"
	echo "-g: Generate GO grpc code"
}

proto_gen_cpp() {
    # Generation grpc cpp related file
    protoc  --cpp_out=. mocaprpc.proto
    protoc --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` $PROTO_FILE

    # Copy generated proto file to corresponding cpp path
    cp *.grpc.pb.cc $CPP_PATH
    cp *.grpc.pb.h $CPP_PATH
    cp *.pb.cc $CPP_PATH
    cp *.pb.h $CPP_PATH
}

proto_gen_go() {
    # Generation grpc cpp related file
    protoc --go_out=plugins=grpc:. $PROTO_FILE

    # Copy generated proto file to corresponding go path
    cp *.pb.go $GO_PATH
}

function main() {

	while getopts :cg flag
	do
		case $flag in
		c)
			proto_gen_cpp
			;;
		g)
			proto_gen_go
			;;
		\?)
            show_help
            exit 0
            ;;
		esac
	done
}

# Start main process
main "$@"

