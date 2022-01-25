#!/bin/sh

### ******************************************************
### RUN THIS SCRIPT AS "amq_runner"
### ******************************************************

LOCAL_MOUNT_DIR="/mnt/nfs_mount/amq"

AMQ_BINARY_BASENAME="amq-broker-7.9.0-bin.zip"
AMQ_BINARY="${LOCAL_MOUNT_DIR}/files/${AMQ_BINARY_BASENAME}"
echo "Checking for existence of ${AMQ_BINARY}"
if [ -f $AMQ_BINARY ]; then
    echo "Creating amq-broker directory and installing AMQ in it..."
    sudo mkdir /opt/rh-amq-broker
    sudo chown -R amq_runner:amq_runner /opt/rh-amq-broker/

    # Directory where AMQ broker will be installed
    cd /opt/rh-amq-broker/

    cp $AMQ_BINARY /opt/rh-amq-broker/
    unzip $AMQ_BINARY_BASENAME > /dev/null
    echo "AMQ installed in `pwd`"

    echo ""
    echo "Creating a broker in /var/opt/amq-broker..."
    sudo mkdir /var/opt/amq-broker
    sudo chown amq_runner:amq_runner /var/opt/amq-broker/
    cd /var/opt/amq-broker/

    # create broker instance
    /opt/rh-amq-broker/amq-broker-7.9.0/bin/artemis create \
      --user amq_user \
      --password amq_password \
      --cluster-user amq_cluster_user \
      --cluster-password amq_cluster_password \
      --clustered \
      --no-hornetq-acceptor \
      --no-mqtt-acceptor \
      --no-stomp-acceptor \
      --allow-anonymous \
      --host $HOSTNAME \
      --data $LOCAL_MOUNT_DIR/advanced_topology/six \
      --relax-jolokia \
      broker-11
else
    echo "..."
    echo "AMQ zip is not in it's location ($AMQ_BINARY)"
    echo "Please fix the above error and re-run"
    echo "..."
fi

