import java.io.IOException;
import java.util.Set;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class DailyViews {

  public static class PVMapper extends Mapper<LongWritable, Text, Text, LongWritable> {
    private static final Set<String> DOMAINS = Set.of("en", "en.m");
    private static final String[] SKIP = {"Special:", "File:", "Wikipedia:", "Talk:", "User:",
        "User_talk:", "Template:", "Category:", "Portal:", "Help:", "Draft:"};
    private final Text outKey = new Text();
    private final LongWritable outVal = new LongWritable();

    @Override
    protected void map(LongWritable key, Text value, Context ctx) throws IOException, InterruptedException {
      String[] f = value.toString().split(" ");
      if (f.length < 4) { ctx.getCounter("WIKI", "MALFORMED").increment(1); return; }
      if (!DOMAINS.contains(f[0])) return;

      String title = f[1];
      if (title.equals("Main_Page") || title.equals("-")) return;
      for (String p : SKIP) if (title.startsWith(p)) return;

      long views;
      try { views = Long.parseLong(f[f.length - 2]); }
      catch (NumberFormatException e) { ctx.getCounter("WIKI", "BAD_COUNT").increment(1); return; }

      outKey.set(title);
      outVal.set(views);
      ctx.write(outKey, outVal);
    }
  }

  public static class SumReducer extends Reducer<Text, LongWritable, Text, LongWritable> {
    private final LongWritable out = new LongWritable();
    @Override
    protected void reduce(Text k, Iterable<LongWritable> vals, Context ctx) throws IOException, InterruptedException {
      long sum = 0;
      for (LongWritable v : vals) sum += v.get();
      out.set(sum);
      ctx.write(k, out);
    }
  }

  public static void main(String[] args) throws Exception {
    Job job = Job.getInstance(new Configuration(), "wiki-daily-views");
    job.setJarByClass(DailyViews.class);
    job.setMapperClass(PVMapper.class);
    job.setCombinerClass(SumReducer.class);
    job.setReducerClass(SumReducer.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(LongWritable.class);
    job.setNumReduceTasks(args.length > 2 ? Integer.parseInt(args[2]) : 8);
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}