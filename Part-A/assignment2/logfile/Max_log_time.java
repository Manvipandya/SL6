Batch-L10
Roll number-33235
package Logs;

import java.io.IOException;

import java.text.DateFormat;
import java.text.ParseException;
import java.util.Date;
import java.text.SimpleDateFormat;
import org.apache.hadoop.conf.Configuration;

import org.apache.hadoop.fs.Path;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;

import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;



public class Max_log_time {
	
	public static class map_for_logs extends  Mapper<LongWritable,Text, Text  ,Text>
	{
		public void map(LongWritable key, Text value, Context con) throws IOException, InterruptedException
		{
			String line = value.toString();
			String words[] = line.split(" ");
				Text outputkey = new Text(words[0].trim());
				DateFormat dateFormat = new SimpleDateFormat("hh:mm:ss");
			      Date d;
			      Date d2;
				try {
					d = dateFormat.parse(words[1]);
				
			    
					d2 = dateFormat.parse(words[2]);
					int diff =(int) (d2.getTime() - d.getTime());
					int diffSeconds = diff / 1000 % 60;
					int diffMinutes = diff / (60 * 1000) % 60;
					int diffHours = diff / (60 * 60 * 1000) % 24;
					Text outputvalue = new Text(Math.abs(diffHours)+":"+Math.abs(diffMinutes)+":"+Math.abs(diffSeconds));
						
					con.write(outputkey,   outputvalue);
				
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			      
			
		}
		
	}
	public static class ReduceTime extends Reducer<Text,Text, Text, Text>

	{
		int max=0;
		int min = 9999;
		Text maxWord = new Text();
		Text minWord = new Text();
		
		public void reduce(Text word, Iterable<Text> values, Context con) throws IOException, InterruptedException

		{
			
		//write values to output file
			int hours = 0;
			int mins=0;
			int secs = 0;
			
			for(Text value : values)
			   {
				String line= value.toString();
				String[] words = line.split(":");
				hours+=Integer.parseInt(words[0]);
				mins+=Integer.parseInt(words[1]);
				secs+=Integer.parseInt(words[2]);
				 if(mins > 60)
				 {
					 hours+=1;
					 mins=0;
				 }
				 if(secs>60)
				 {
					 mins+=1;
					 secs=0;
				 }
				 if(max<=hours)
					{
						max=hours;
						maxWord.set(word);
					}
					if(min>=hours)
					{
						min=hours;
						minWord.set(word);
					}
				}
			
		//	if(hours>10)
			//    con.write(word, new Text(hours+":"+mins+":"+secs));
			
 
		}
		
		protected void cleanup(Reducer<Text, Text, Text, Text>.Context context) throws IOException, InterruptedException 
		{
		   context.write(maxWord, new Text(" "+max));
		   context.write(minWord, new Text(" "+min));
		
		   super.cleanup(context);
		
}	
} 
	

	public static void main(String args[]) throws Exception
	{
		Configuration c=new Configuration();

		String[] files=new GenericOptionsParser(c,args).getRemainingArgs();

		Path input=new Path(files[0]);

		Path output=new Path(files[1]);

		Job j=new Job(c,"Log_records");

		j.setJarByClass(Max_log_time.class);

		j.setMapperClass(map_for_logs.class);

		j.setReducerClass(ReduceTime.class);

		j.setOutputKeyClass(Text.class);

		j.setOutputValueClass(Text.class);

		FileInputFormat.addInputPath(j, input);

		FileOutputFormat.setOutputPath(j, output);

		System.exit(j.waitForCompletion(true)?0:1);
	
	}
}

