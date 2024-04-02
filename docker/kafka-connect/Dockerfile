FROM confluentinc/cp-kafka-connect:7.6.0-2-ubi8

ENV CONNECT_PLUGIN_PATH: "/usr/share/java,/usr/share/confluent-hub-components"
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.7.6

RUN wget https://jdbc.postgresql.org/download/postgresql-42.7.3.jar -O /usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/lib/postgresql-42.7.3.jar
RUN wget https://github.com/ClickHouse/clickhouse-java/releases/download/v0.6.0-patch3/clickhouse-jdbc-0.6.0-patch3.jar -O /usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/lib/clickhouse-jdbc-0.6.0-patch3.jar
RUN wget https://github.com/ClickHouse/clickhouse-java/releases/download/v0.6.0-patch3/clickhouse-jdbc-0.6.0-patch3-http.jar -O /usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/lib/clickhouse-jdbc-0.6.0-patch3-http.jar
