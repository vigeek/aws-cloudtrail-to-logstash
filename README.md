# aws-cloudtrail-to-logstash
Pulls down cloudtrail logs and outputs to a json file to be ingested by LogStash.

# Requires
s3cmd -and- jq

# Configuration

1. Edit the script and update variable 'AWS_ACCOUNT_NUMBER' with your account number.
2. Edit the script and update variable 'S3_BUCKET_NAME' with your buckets name.
3. Ensure your AWS credentials are configured (e.g:  ~/.aws/credentials)
4. Execute the script (it will run in a constant loop)

# Ingesting ELB logs
See here:  https://github.com/vigeek/aws-elb-logs-to-logstash

# Example dashboard (included)
# Partial screen shot
![alt tag](https://github.com/vigeek/aws-cloudtrail-to-logstash/blob/master/kibana-dashboard/dashboard-partial-ss.png)
