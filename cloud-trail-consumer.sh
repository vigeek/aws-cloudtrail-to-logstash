# CloudTrail Consumer
# Russ Thompson 2016.
# Requires: s3cmd

# Check interval, how often to pause in between checks
CHECK_INTERVAL="30"

# Define temporary file, temporary results are stored here to avoid duplicates.
TEMP_FILE="/tmp/cloudtrail-tmp"

# Define output file where the ingestible json is sent to (ingest with logstash)
OUT_FILE="/var/log/cloudtrail.json"

# Define the bucket where cloudtrail logs are beint sent to.
S3_BUCKET_NAME="your-cloudtrail-bucket"
# Define the numerical number that resepresents your AWS account.
AWS_ACCOUNT_NUMBER=""

# Check growth of file, this is a small list of already processed files.
# Rather than rotate, just keep them relatively small.
function check_file_growth {
  if [ "$(wc -l $TEMP_FILE | awk '{print $1}')" -gt "200" ] ; then
    sed -i '1,100d' $TEMP_FILE
  fi
  if [ "$(wc -l $OUT_FILE | awk '{print $1}')" -gt "5000" ] ; then
    sed -i '1,1000d' $OUT_FILE
  fi
}

# Log function
function log_it {
  echo " $(date): $1" >> $LOG_FILE
}

# Reset the date on occasion 
function reset_date {
  CURRENT_DATE="$(date +%Y/%m/%d/)"
}

reset_date

# Loop through all the regions, consume files and output to json.
while true ; do
  for THE_PATH in `s3cmd ls s3://$S3_BUCKET_NAME/AWSLogs/$AWS_ACCOUNT_NUMBER/CloudTrail/ | awk '{print $2}'` ; do
    THE_FILE_LIST=`s3cmd ls $THE_PATH$CURRENT_DATE | tail -1 | awk '{print $4}'`
    if [ -n "$THE_FILE_LIST" ] ; then
      # If the file exists in our temp file, we already downloaded it.
      if ! grep $THE_FILE_LIST $TEMP_FILE ; then
        echo $THE_FILE_LIST >> $TEMP_FILE
        s3cmd get $THE_FILE_LIST
        FILE_NAME="${THE_FILE_LIST##*/}"
        zcat $FILE_NAME | jq -r -M .Records[] -c >> $OUT_FILE
        rm -f $FILE_NAME
      fi
    fi
    sleep 2
  done
  check_file_growth
  reset_date
  sleep $CHECK_INTERVAL
done
