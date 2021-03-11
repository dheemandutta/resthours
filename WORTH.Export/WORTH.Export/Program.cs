using Quartz;
using Quartz.Impl;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace WORTH.Export
{
    class Program
    {
        private static IScheduler scheduler;

        static void Main(string[] args)
        {
            Start();
            Console.ReadKey();
            scheduler.Shutdown();
        }

        public static async void Start()
        {
            //IScheduler scheduler = StdSchedulerFactory.GetDefaultScheduler();

            StdSchedulerFactory factory = new StdSchedulerFactory();
            scheduler = await factory.GetScheduler();

            await scheduler.Start();


            IJobDetail job = JobBuilder.Create<EmailJob>().Build();

            ITrigger trigger = TriggerBuilder.Create()
                .WithDailyTimeIntervalSchedule
                  (s =>
                     //s.WithIntervalInHours(24)
                     s.WithIntervalInSeconds(60)
                    .OnEveryDay()
                    .StartingDailyAt(TimeOfDay.HourAndMinuteOfDay(0, 0))
                  )
                .Build();

            //scheduler.ScheduleJob(job, trigger);

            await scheduler.ScheduleJob(job, trigger);


        }
    }
}
