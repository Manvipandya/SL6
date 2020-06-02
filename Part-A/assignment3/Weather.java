Batch-L10
Roll number-33235
package weather;
import java.io.IOException;


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

public class Weather {
	public static class weather_map extends  Mapper<LongWritable,Text, Text  ,Text>
	{
		public void map(LongWritable key, Text value, Context con) throws IOException, InterruptedException
		{
			String line = value.toString();
			String words[] = line.split(",");
				Text outputkey = new Text(words[0].trim());
				float sum=0;
				int i=1;
				while(i<words.length)
				{
					sum+=Float.parseFloat(words[i]);
					i++;
				}
				i--;
					Text outputvalue = new Text(i+","+sum);
					con.write(outputkey,   outputvalue);
		}
		
	}
	public static class ReduceWeather extends Reducer<Text,Text, Text, Text>

	{
		float max=0;
		float min = 9999;
		Text maxWord = new Text();
		Text minWord = new Text();
		float avg=0;
		public void reduce(Text word,Iterable<Text>values, Context con) throws IOException, InterruptedException

		{
			for(Text value : values)
			{
			String line=value.toString();
			String[] words=line.split(",");
			float count=Float.parseFloat(words[0]);
			float sum=Float.parseFloat(words[1]);
			avg=sum/count;
			if(max<=avg)
			{
				max=avg;
				maxWord.set(word);
			}
			if(min>=avg)
			{
				min=avg;
				minWord.set(word);
			}	
			}
		}
		
			
		protected void cleanup(Reducer<Text, Text, Text, Text>.Context context) throws IOException, InterruptedException 
		{
		   context.write(maxWord, new Text("Maximum:"+max));
		   context.write(minWord, new Text("Minimum:"+min));
		
		   super.cleanup(context);
		
}	
} 
	public static void main(String args[]) throws Exception
	{
		Configuration c=new Configuration();

		String[] files=new GenericOptionsParser(c,args).getRemainingArgs();

		Path input=new Path(files[0]);

		Path output=new Path(files[1]);

		Job j=new Job(c,"Weather Report");

		j.setJarByClass(Weather.class);

		j.setMapperClass(weather_map.class);

		j.setReducerClass(ReduceWeather.class);

		j.setOutputKeyClass(Text.class);

		j.setOutputValueClass(Text.class);

		FileInputFormat.addInputPath(j, input);

		FileOutputFormat.setOutputPath(j, output);

		System.exit(j.waitForCompletion(true)?0:1);
	
	}
}
