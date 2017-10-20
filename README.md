# aws-cloudtrail-to-logstash
Pulls down AWS cloudtrail logs from S3 and outputs to a json file to be ingested by LogStash.  The json logs are preformatted and easily parsable by Logstash.

# Requires
s3cmd -and- jq

# Configuration

1. Edit the script and update variable 'AWS_ACCOUNT_NUMBER' with your account number.
2. Edit the script and update variable 'S3_BUCKET_NAME' with your buckets name.
3. Ensure your AWS credentials are configured (e.g:  ~/.aws/credentials)
4. Execute the script (it will run in a constant loop)

# Configuration extended.
Included is a traditional init script and monit config (optional), to use the init script...

1. Ensure 'cloud-trail-consumer.sh' is located here:  /opt/cloudtrail-consumer
2. Alternatively, edit 'cloudtrail-consumer-init.sh' and change variable 'THE_PATH'
3. Place the init script[cloudtrail-consumer-init.sh] in /etc/init.d
4. Make init script executable:  chmod ug+x cloudtrail-consumer-init.sh
5. It can then be started as such:  /etc/init.d/cloudtrail-consumer-init.sh start (or stop)
6. The included monit script can be placed in your monits configuration directory and used to startup the cloudtrail consumer on start up.

# Ingesting ELB logs
See here:  https://github.com/vigeek/aws-elb-logs-to-logstash

# Example dashboard (included)
To install, please view readme in kibana-dashboard directory
![alt tag](https://github.com/vigeek/aws-cloudtrail-to-logstash/blob/master/kibana-dashboard/dashboard-partial-ss.png)

*Some minor details from the dashboard image are obfuscated.*
