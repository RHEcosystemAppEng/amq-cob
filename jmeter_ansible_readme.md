## Running Jmeter test using Ansible.

There are multiple Ansible playbooks to preform Jmeter test on Apache AMQ using Ansible.

All the ansible playbooks should be run from following folder.

```shell
cd $MAIN_CONFIG_DIR/ansible
```


### Ansible Playbooks to send/consumer messages for the specific duration.
Use these playbooks to perform actual Jmeter performance test against AMQ Artemis.


* `setup_n_run_jmeter_perf_client_playbook.yml` - This playbook will run the jmeter test without any throttle on producer and consumer side. 
No throttling on the producer and consumer side.

  ```shell
  ansible-playbook playbooks/setup_n_run_jmeter_perf_client_playbook.yml --extra-vars "@variable_override.yml"
  ```

* `setup_n_run_jmeter_perf_client_playbook-standalone_broker.yml` :
   ```shell
    ansible-playbook -i hosts/hosts-r1_vpc1-standalone_broker.yml \
      playbooks/setup_n_run_jmeter_perf_client_playbook-standalone_broker.yml \
      --extra-vars "@variable_override.yml"
   ```

  * _Same as `setup_n_run_jmeter_perf_client_playbook` but installs JMeter on broker-01_
  * To send messages to the standalone broker directly, instead of hub router, override following 
    property in `variable_override.yml` and set it to the private IP of broker-01:
    * `jmeter_hub_router_ip`

* `setup_n_run_jmeter_perf_producer_playbook.yml` - This playbook will run the jmeter test without any throttle on producer. 
No Consumers available

    ```shell
    ansible-playbook playbooks/setup_n_run_jmeter_perf_producer_playbook.yml --extra-vars "@variable_override.yml"
    ```

* `setup_n_run_jmeter_perf_consumer_playbook.yml` - This playbook will run the jmeter test without any throttle on the consumer side. Use this playbook to perform actual Jmeter performance test against AMQ Artemis.
No Producers available.

    ```shell
    ansible-playbook playbooks/setup_n_run_jmeter_perf_consumer_playbook.yml --extra-vars "@variable_override.yml"
    ```

### Ansible Playbooks to send/consumer specific number of messages.

`setup_n_run_jmeter_n_messages_client_playbook.yml` - This playbook will run the jmeter test and producing only specific number of messages configured as part of the property `numberOfMessagesPerMin`. No throttling on the consumer side. 
Throttling on the producers - Sends only specified number of messages. 
No throttling on the consumers. 

```shell
ansible-playbook playbooks/setup_n_run_jmeter_n_messages_client_playbook.yml --extra-vars "@variable_override.yml"
```

`setup_n_run_jmeter_n_messages_producer_playbook.yml` - This playbook will setup and run the jmeter test. Producing only specific number of messages configured as part of the property `numberOfMessagesPerMin`. 
Throttling on the producers - Sends only specified number of messages.
No consumers available as part of this test.

```shell
ansible-playbook playbooks/setup_n_run_jmeter_n_messages_producer_playbook.yml --extra-vars "@variable_override.yml"
```

`setup_n_run_jmeter_n_messages_consumer_playbook.yml` - This playbook will setup and run the jmeter test. Consuming only specific number of messages configured as part of the property `numberOfMessagesPerMin`.
No Producers available as part of this test.

```shell
ansible-playbook playbooks/setup_n_run_jmeter_n_messages_consumer_playbook.yml --extra-vars "@variable_override.yml"
```

### Ansible Playbooks to perform missing messages analysis.
This playbook is designed to perform the AMQ test and analyze if there are any messages are not delivered or received multiple times. This `AMQ_Jmeter_Test_Plan_N_Missing_Messages_Analysis.jmx` file is designed to perform the test and record request and response in the xml format so that we can perform the analysis later. 

```shell
ansible-playbook playbooks/setup_n_run_jmeter_missing_messages_analysis_playbook.yml --extra-vars "@variable_override.yml"
```

### Ansible Playbooks to perform test in parallel

```shell
ansible-playbook playbooks/setup_n_run_jmeter_n_messages_in_parallel_client_playbook.yml --extra-vars "@variable_override.yml"
```

Please consider overriding following properties in [variable_override.yml](variable_override.yml) if you want to change the default behaviour.
```yaml
    # IP address of the hub router or broker to perform the test.
    jmeter_hub_router_ip: "{{ r1_vpc1_private_ip_prefix }}.128.100"
    jmeter_hub_router_port: 5672
    # URLs to download the jmeter binary zip
    jmeter_binary_download_uri: https://dlcdn.apache.org/jmeter/binaries
    jmeter_binary_version: apache-jmeter-5.4.3
    jmeter_binary_archive: "{{ jmeter_binary_version }}.zip"
    jmeter_remote_bin_dir: jmeter    
    #Parameters that effects the benchmark test, JMX Parameters.
    #Duration is in seconds
    producer_duration: 30
    #Duration is in seconds
    consumer_duration: 60
    producer_samples: 2500
    consumer_samples: 2500
    producer_threads: 1
    consumer_threads: 5
    jms_timeout_ms: 3000
    numberOfMessagesPerMin: 200
    #Delete the jmeter home directory before setting up the client. 
    clean_jmeter_home_directory: true
    #Set to true for durable is false, otherwise set to false for durable is true. 
    non_persistent: true
```