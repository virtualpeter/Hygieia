#!/bin/bash

if [ "$SKIP_PROPERTIES_BUILDER" = true ]; then
  echo "Skipping properties builder"
  exit 0
fi

# if we are linked, use that info
if [ "$MONGO_STARTED" != "" ]; then
  # links now use hostnames
  # todo: retrieve linked information such as hostname and port exposition
  export SPRING_DATA_MONGODB_HOST=mongodb
  export SPRING_DATA_MONGODB_PORT=27017
fi

echo "SPRING_DATA_MONGODB_HOST: $SPRING_DATA_MONGODB_HOST"
echo "SPRING_DATA_MONGODB_PORT: $SPRING_DATA_MONGODB_PORT"


cat > aws-cloud-collector.properties <<EOF
#Database Name - default is test
dbname=${SPRING_DATA_MONGODB_DATABASE:-dashboard}

#Database HostName - default is localhost
dbhost=${SPRING_DATA_MONGODB_HOST:-10.0.1.1}

#Database Port - default is 27017
dbport=${SPRING_DATA_MONGODB_PORT:-9999}

#Database Username - default is blank
dbusername=${SPRING_DATA_MONGODB_USERNAME:-db}

#Database Password - default is blank
dbpassword=${SPRING_DATA_MONGODB_PASSWORD:-dbpass}

# Logging File location
logging.file=${LOG_FILE:-./logs/cloud.log}

# Collector schedule (required)
aws.cron=${CRON_SCHEDULE:-0 0/5 * * * *}

# AWS ValidTag Key - To look for tags that you expect on your resource
aws.validTagKey[0]=${VALID_TAG_KEY}
#aws.validTagKey[1]=XYZ

# AWS Proxy Host
aws.proxyHost=${AWS_PROXY_HOST}

# AWS Proxy Port
aws.proxyPort=${AWS_PROXY_PORT}

# AWS Non Proxy
aws.nonProxy=${AWS_PROXY_NONPROXY}

# AWS Profile to be used if any
aws.profile=${AWS_PROFILE}

EOF
