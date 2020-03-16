#!/usr/bin/bash
USERNAME=root
PASSWORD=1234
DBNAME=solar

cat /proc/cpuinfo
mysql --version

QUERY=$(cat <<'END_HEREDOC'
    ALTER TABLE data_minute
    ADD CONSTRAINT fk1_data_minute_site_id
    FOREIGN KEY (site_id) REFERENCES site(id);
END_HEREDOC
)

mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY"

QUERY=$(cat <<'END_HEREDOC'
    CREATE INDEX fk1_data_minute_site_id ON data_minute (site_id);
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
echo "Result From Foriegn Key and INDEX"
echo "---------------------------------"

echo " SELECT FIRST Table"

QUERY=$(cat <<'END_HEREDOC'
    SELECT * FROM site WHERE id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" | tail -n3 | head -n1
done

echo " SELECT SECOND Table"

QUERY=$(cat <<'END_HEREDOC'
    SELECT * FROM data_minute WHERE site_id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" | tail -n3 | head -n1
done

echo " SELECT FIRST JOIN SECOND Table"

QUERY=$(cat <<'END_HEREDOC'
    SELECT * FROM data_minute 
    JOIN site WHERE site_id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" | tail -n3 | head -n1
done

# ------------------ Now We Drop foriegn Key --------------

QUERY=$(cat <<'END_HEREDOC'
    ALTER TABLE data_minute
    DROP FOREIGN KEY fk1_data_minute_site_id;
END_HEREDOC
)

mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY"

QUERY=$(cat <<'END_HEREDOC'
    DROP INDEX fk1_data_minute_site_id ON data_minute;
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
echo "Result From Don't Have Foriegn Key and INDEX"
echo "---------------------------------"

echo " SELECT FIRST Table"

QUERY=$(cat <<'END_HEREDOC'
    SELECT * FROM site WHERE id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" | tail -n3 | head -n1
done

echo " SELECT SECOND Table"

QUERY=$(cat <<'END_HEREDOC'
    SELECT * FROM data_minute WHERE site_id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" | tail -n3 | head -n1
done

echo " SELECT FIRST JOIN SECOND Table"

QUERY=$(cat <<'END_HEREDOC'
    SELECT * FROM data_minute 
    JOIN site WHERE site_id = 1;
END_HEREDOC
)

for ((i=1;i<=10;i++)); 
do 
   mysql -vvv -u $USERNAME -p$PASSWORD $DBNAME -e "$QUERY" | tail -n3 | head -n1
done