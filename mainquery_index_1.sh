#!/usr/bin/bash
USERNAME=root
PASSWORD=1234
DBNAME=solar

cat /proc/cpuinfo
mysql --version

QUERY=$(cat <<'END_HEREDOC'
    CREATE INDEX site_id ON data_minute (site_id);
END_HEREDOC
)

mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" || echo "Index Aready Exist!"

# ----------- EXPLAIN ---------------
QUERY=$(cat <<'END_HEREDOC'
    EXPLAIN data_minute;
END_HEREDOC
)

mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY"
# ----------- END EXPLAIN ---------------

echo ""
echo "Result From Have INDEX"
echo "---------------------------------"

QUERY=$(cat <<'END_HEREDOC'
    SELECT * FROM data_minute WHERE site_id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" | tail -n3 | head -n1
done

QUERY=$(cat <<'END_HEREDOC'
    DROP INDEX site_id ON data_minute;
END_HEREDOC
)

mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY"

# ----------- EXPLAIN ---------------
QUERY=$(cat <<'END_HEREDOC'
    EXPLAIN data_minute;
END_HEREDOC
)

mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY"
# ----------- END EXPLAIN ---------------

echo ""
echo "Result From Don't Have INDEX"
echo "---------------------------------"

QUERY=$(cat <<'END_HEREDOC'
    SELECT * FROM data_minute WHERE site_id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" | tail -n3 | head -n1
done