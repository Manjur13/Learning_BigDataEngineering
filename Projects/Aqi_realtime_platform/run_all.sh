#!/bin/bash
set -e

cd "$(dirname "$0")"

docker compose up -d
source venv/bin/activate

export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@17}"
export PATH="$JAVA_HOME/bin:$PATH"

echo "Waiting for Kafka to be ready..."
sleep 8

docker exec aqi_realtime_platform-kafka-1 kafka-topics \
  --create --if-not-exists \
  --topic aqi-readings --bootstrap-server localhost:9092 \
  --partitions 3 --replication-factor 1

python producer/produce_aqi.py &
PRODUCER_PID=$!

python consumer/stream_consumer.py &
CONSUMER_PID=$!

trap "kill $PRODUCER_PID $CONSUMER_PID 2>/dev/null" EXIT

streamlit run dashboard/app.py
