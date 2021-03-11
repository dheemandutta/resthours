using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Quartz;
using Quartz.Impl;

namespace TM.RestHour
{
    public class ExportScheduler
    {
        public static  void Start()
        {
            StdSchedulerFactory factory = new StdSchedulerFactory();
            
            IScheduler scheduler =  factory.GetScheduler();
             scheduler.Start();

            IJobDetail job = JobBuilder.Create<Export>().Build();

            ITrigger trigger = TriggerBuilder.Create()
                .WithDailyTimeIntervalSchedule
                  (s =>
                     //s.WithIntervalInHours(24)
                    //s.WithIntervalInSeconds(60)
                    s.WithIntervalInMinutes(2)
                    .OnEveryDay()
                    .StartingDailyAt(TimeOfDay.HourAndMinuteOfDay(0, 0))
                  )
                .Build();

             scheduler.ScheduleJob(job, trigger);
        }
    }
}