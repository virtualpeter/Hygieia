#!/bin/sh

if [ "$SKIP_PROPERTIES_BUILDER" = true ]; then
  echo "Skipping properties builder"
  exit 0
fi

# mongo container provides the HOST/PORT
# api container provided DB Name, ID & PWD

: ${PROP_FILE:=application.yml}

if [ "$MONGO_PORT" != "" ]; then
	# Sample: MONGO_PORT=tcp://172.17.0.20:27017
	MONGODB_HOST=`echo $MONGO_PORT|sed 's;.*://\([^:]*\):\(.*\);\1;'`
	MONGODB_PORT=`echo $MONGO_PORT|sed 's;.*://\([^:]*\):\(.*\);\2;'`
else
	env
	echo "ERROR: MONGO_PORT not defined"
	exit 1
fi

cat > $PROP_FILE <<EOF
#Database Name
dbname: ${HYGIEIA_API_ENV_SPRING_DATA_MONGODB_DATABASE:-dashboard}

#Database HostName
dbhost: ${MONGODB_HOST:-mongo}

#Database Port - default is 27017
dbport: ${MONGODB_PORT:-27017}

#Database Username - default is blank
dbusername: ${HYGIEIA_API_ENV_SPRING_DATA_MONGODB_USERNAME:-db}

#Database Password - default is blank
dbpassword: ${HYGIEIA_API_ENV_SPRING_DATA_MONGODB_PASSWORD:-dbpass}

aws:
  #Collector schedule (required)
  cron=${AWS_CRON:-0 0/30 * * * *}

  #proxy so aws client can connect to aws api
  proxyHost: $AWS_PROXY_HOST
  proxyPort: $AWS_PROXY_PORT
  nonProxy:  ${AWS_NO_PROXY:-169.254.169.254}
  profile:   
  historyDays: ${AWS_HISTORY_DAYS:-28}
EOF

if [ -n "$VALID_TAG_KEYS" ]
then
    echo     "  validTagKey:" >> $PROP_FILE
	for KEY in $VALID_TAG_KEYS
	do 
		echo "    - $KEY" >> $PROP_FILE
	done 
fi


echo "

===========================================
Properties file created `date`:  $PROP_FILE
Note: passwords hidden
===========================================
`cat $PROP_FILE |egrep -vi password`
 "

exit 0
