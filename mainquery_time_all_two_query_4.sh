#!/usr/bin/bash
USERNAME=root
PASSWORD=1234
DBNAME=solar

cat /proc/cpuinfo
mysql --version

# ----------- EXPLAIN ---------------
QUERY=$(cat <<'END_HEREDOC'
    EXPLAIN data_minute;
END_HEREDOC
)

mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY"
# ----------- END EXPLAIN ---------------

echo ""
echo "Result"
echo "---------------------------------"

ts=$(date +%s%N)
echo " SELECT FIRST Table"

QUERY=$(cat <<'END_HEREDOC'
    SELECT id FROM site WHERE id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" > /dev/null
   echo "Done Row: $i"
done

echo " SELECT SECOND Table"

QUERY=$(cat <<'END_HEREDOC'
    SELECT dat_id, site_id, dat_date FROM data_minute WHERE site_id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" > /dev/null
   echo "Done Row: $i"
done

tt=$((($(date +%s%N) - $ts)/1000000))
echo "Time taken: $tt milliseconds"

ts=$(date +%s%N)
echo " SELECT FIRST JOIN SECOND Table"

QUERY=$(cat <<'END_HEREDOC'
    SELECT data_minute.dat_id, site.id, data_minute.dat_date FROM data_minute 
    LEFT JOIN site ON data_minute.site_id = site.id WHERE site_id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" > /dev/null
   echo "Done Row: $i"
done

tt=$((($(date +%s%N) - $ts)/1000000))
echo "Time taken: $tt milliseconds"
