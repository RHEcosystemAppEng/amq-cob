### Running Jmeter test using Ansible.

There are two Ansible playbooks to preform Jmeter test books. 

`setup_n_run_jmeter_perf_client_playbook.yml` - This playbook will run the jmeter test without any throttle on producer and consumer side. Use this playbook to perform actual Jmeter performance test against AMQ Artemis.
No throttling on the producer and consumer side.

```shell
cd $MAIN_CONFIG_DIR/ansible
ansible-playbook setup_n_run_jmeter_perf_client_playbook.yml --extra-vars "@variable_override.yml"
```

`setup_n_run_jmeter_n_messages_client_playbook.yml` - This playbook will run the jmeter test and producing only specific number of messages configured as part of the property `numberOfMessagesPerMin`. No throttling on the consumer side. 
Throttling on the producers - Sends only specified number of messages. 
No throttling on the consumers. 

```shell
cd $MAIN_CONFIG_DIR/ansible
ansible-playbook setup_n_run_jmeter_n_messages_client_playbook.yml --extra-vars "@variable_override.yml"
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
    # Parameters that effects the benchmark test, JMX Parameters.
    producer_duration: 30
    consumer_duration: 60
    producer_samples: 2500
    consumer_samples: 2500
    producer_threads: 1
    consumer_threads: 5
    jms_timeout_ms: 3000
    numberOfMessagesPerMin: 200
    # Delete the jmeter home directory before setting up the client. 
    clean_jmeter_home_directory: true
```