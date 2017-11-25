
FROM docker.io/openjdk:8-jre

MAINTAINER Hygieia@capitalone.com

COPY *.jar /hygieia/aws-cloud-collector.jar
COPY aws-properties-builder.sh /hygieia/

WORKDIR /hygieia

VOLUME ["/hygieia/logs"]

CMD ./aws-properties-builder.sh && \
  java -jar aws-cloud-collector.jar
