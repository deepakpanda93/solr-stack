#!/bin/bash

ZK_DIRECTORY=$1
CONFIG_DIR=$2
SOLR_USER=$3
ZK_CLI_SHELL=$4
ZK_NODE1=$5
CLIENT_PORT=$6
COLLECTION_NAME=$7
TEST_SOLR_BOOTSTRAP=/tmp/test_solr_bootstrap.log

function check_bootstrap() {
    
    if [ ! -e $ZK_CLI_SHELL ]; then
        WARN_MSG="$ZK_CLI_SHELL does not exist, skipping validation"
        echo $WARN_MSG
        exit 0
    fi
        
    OUTPUT=$(/var/lib/ambari-agent/ambari-sudo.sh su $SOLR_USER -s /bin/bash - -c "source $CONFIG_DIR/zookeeper-env.sh ; echo 'get $ZK_DIRECTORY/configs/$COLLECTION_NAME' | ${ZK_CLI_SHELL} -server $ZK_NODE1:$CLIENT_PORT" 2>&1> $TEST_SOLR_BOOTSTRAP)
    echo $OUTPUT | grep "Node does not exist: $ZK_DIRECTORY/configs/$COLLECTION_NAME"
    
    if [ "$?" -eq 0 ]; then
        echo $OUTPUT
        ERROR_MSG="Unsuccessful bootstrap, the collection $COLLECTION_NAME does not exist"
        echo $ERROR_MSG
        exit 1
    fi
}

check_bootstrap