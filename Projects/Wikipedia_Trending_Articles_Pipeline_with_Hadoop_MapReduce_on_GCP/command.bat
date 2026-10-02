# Step 0: Create the project folder
cd /home/manjurdataengineer
mkdir wiki
cd wiki

# Step 1: Write DailyViews.java (Job 1)
vi DailyViews.java

# Step 2: Write Trending.java (Job 2)
vi Trending.java

# Step 3: Compile and create the JAR
javac -cp $(hadoop classpath) DailyViews.java Trending.java
ls -l DailyViews*.class Trending*.class

jar cf wiki.jar DailyViews*.class Trending*.class
ls -l wiki.jar

# Step 4: Test with a small sample file
mkdir -p ~/localFile
vi ~/localFile/sample_pageviews.txt

# Step 5: Then run Job 1 on it:
hadoop fs -mkdir -p /user/manjurdataengineer/wiki/sample
hadoop fs -put ~/localFile/sample_pageviews.txt /user/manjurdataengineer/wiki/sample/
hadoop fs -ls /user/manjurdataengineer/wiki/sample/

hadoop jar wiki.jar DailyViews /user/manjurdataengineer/wiki/sample /user/manjurdataengineer/wiki/output_sample 1
hadoop fs -cat /user/manjurdataengineer/wiki/output_sample/part-r-00000

# You should see exactly:

@REM  Frieza	150
@REM  Gohan	150
@REM  Goku	1700
@REM  Vegeta	1000

@REM  If your output matches, the code works. If it doesn't, fix it before going further.

# Step 6 : Write the download script
vi ingest_day.sh

chmod +x ingest_day.sh

# Step 7: Check internet access and HDFS space
curl -sI https://dumps.wikimedia.org/other/pageviews/ | head -1
hdfs dfsadmin -report | grep -E "DFS Remaining|Live datanodes"

# Step 9: Download the target day and look at the real data
./ingest_day.sh 2026-09-27

hadoop fs -ls /user/manjurdataengineer/wiki/raw/dt=2026-09-27/
hadoop fs -du -s -h /user/manjurdataengineer/wiki/raw/dt=2026-09-27/
hadoop fs -cat /user/manjurdataengineer/wiki/raw/dt=2026-09-27/pageviews-20260927-000000.gz | zcat | grep "^en " | head

# Step 10: Download the 7 history days (in the background)
nohup bash -c 'for d in 20 21 22 23 24 25 26; do ./ingest_day.sh 2026-09-$d; done' > ingest.log 2>&1 &
tail -f ingest.log

# Step 11: Run Job 1 on the target day
hadoop jar wiki.jar DailyViews /user/manjurdataengineer/wiki/raw/dt=2026-09-27 /user/manjurdataengineer/wiki/daily/dt=2026-09-27 8

hadoop fs -ls /user/manjurdataengineer/wiki/daily/dt=2026-09-27/
hadoop fs -cat /user/manjurdataengineer/wiki/daily/dt=2026-09-27/part-r-* | sort -t$'\t' -k2 -nr | head -20

#Step 12: Run Job 1 on the 7 history days
for d in 20 21 22 23 24 25 26; do
  hadoop jar wiki.jar DailyViews /user/manjurdataengineer/wiki/raw/dt=2026-09-$d /user/manjurdataengineer/wiki/daily/dt=2026-09-$d 8
done

hadoop fs -ls /user/manjurdataengineer/wiki/daily/

#Step 13: Run Job 2 and get the final output
hadoop jar wiki.jar Trending 2026-09-27 "/user/manjurdataengineer/wiki/daily/dt=2026-09-2[0-7]" /user/manjurdataengineer/wiki/trending/dt=2026-09-27

hadoop fs -cat /user/manjurdataengineer/wiki/trending/dt=2026-09-27/part-r-* | sort -t$'\t' -k4 -nr | head -25