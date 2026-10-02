import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class Trending {

  public static class TMapper extends Mapper<LongWritable, Text, Text, Text> {
    private boolean isTarget;
    private final Text k = new Text(), v = new Text();

    @Override
    protected void setup(Context ctx) {
      String target = ctx.getConfiguration().get("trend.date");
      String path = ((FileSplit) ctx.getInputSplit()).getPath().toString();
      isTarget = path.contains("dt=" + target);
    }

    @Override
    protected void map(LongWritable key, Text value, Context ctx) throws IOException, InterruptedException {
      String[] f = value.toString().split("\t");
      if (f.length != 2) return;
      k.set(f[0]);
      v.set((isTarget ? "T:" : "H:") + f[1]);
      ctx.write(k, v);
    }
  }

  public static class TReducer extends Reducer<Text, Text, Text, Text> {
    private long minViews; private int historyDays; private String date;

    @Override
    protected void setup(Context ctx) {
      Configuration c = ctx.getConfiguration();
      minViews = c.getLong("trend.min.views", 5000);
      historyDays = c.getInt("trend.history.days", 7);
      date = c.get("trend.date");
    }

    @Override
    protected void reduce(Text key, Iterable<Text> vals, Context ctx) throws IOException, InterruptedException {
      long today = 0, hist = 0;
      for (Text t : vals) {
        String s = t.toString();
        long n = Long.parseLong(s.substring(2));
        if (s.startsWith("T:")) today += n; else hist += n;
      }
      if (today < minViews) return;
      double avg = (double) hist / historyDays;
      double ratio = today / (avg + 100.0);
      ctx.write(key, new Text(today + "\t" + String.format("%.1f", avg) + "\t"
          + String.format("%.2f", ratio) + "\t" + date));
    }
  }

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    conf.set("trend.date", args[0]);
    Job job = Job.getInstance(conf, "wiki-trending-" + args[0]);
    job.setJarByClass(Trending.class);
    job.setMapperClass(TMapper.class);
    job.setReducerClass(TReducer.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(Text.class);
    FileInputFormat.addInputPaths(job, args[1]);
    FileOutputFormat.setOutputPath(job, new Path(args[2]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}