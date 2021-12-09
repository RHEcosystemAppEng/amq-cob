# Two AMQ Instance with High Availability using Replication

## Prerequisites
* Be sure to complete two AMQ instance cluster

## Designate first broker as master instance

* Edit the first AMQ broker instance's broker.xml file 
```shell
cd cd /var/opt/amq-broker/mybroker/etc
vi broker.xml
```

* Add the ha-policy element below cluster-connections element
```xml
<ha-policy>
    <replication>
       <master/>
    </replication>
</ha-policy>
```

## Designate second broker as master instance
* Edit the first AMQ broker instance's broker.xml file 
```shell
cd cd /var/opt/amq-broker2/mybroker2/etc
vi broker.xml
```

* Add the ha-policy element below cluster-connections element
```xml
<ha-policy>
    <replication>
       <slave/>
    </replication>
</ha-policy>
```

## Start both AMQ instances
* From command line start broker instances from two separate terminal windows
```shell
/var/opt/amq-broker/mybroker/bin/artemis run
/var/opt/amq-broker2/mybroker2/bin/artemis run
```