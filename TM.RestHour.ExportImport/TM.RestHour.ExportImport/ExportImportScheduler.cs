using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

using Quartz;
using Quartz.Impl;

namespace TM.RestHour.ExportImport
{
    public class ExportImportScheduler
    {
        public static async void Start()
        {
            StdSchedulerFactory factory = new StdSchedulerFactory();
            IScheduler scheduler = await factory.GetScheduler();
            await scheduler.Start();
            #region Import Schedule
            //-----------------------schedule Import------------------------------------------
            int intervalTimeInSecond = int.Parse(ConfigurationManager.AppSettings["SchedulerIntervalTime"].ToString());

            IJobDetail job = JobBuilder.Create<Import>().Build();

            ITrigger trigger = TriggerBuilder.Create()
                .WithDailyTimeIntervalSchedule
                  (s =>
                    // s.WithIntervalInHours(24)
                    //s.WithIntervalInSeconds(120)
                    s.WithIntervalInSeconds(intervalTimeInSecond)
                    .OnEveryDay()
                    .StartingDailyAt(TimeOfDay.HourAndMinuteOfDay(0, 0))
                  )
                .Build();

            await scheduler.ScheduleJob(job, trigger);
            ////------End-----schedule Import--------------------------------------------------
            #endregion

            #region Export Schedule
            //-----------------------schedule Export------------------------------------------
            int intervalTimeInSecondForExport = int.Parse(ConfigurationManager.AppSettings["ExportSchedulerIntervalTime"].ToString());

            IJobDetail jobExport = JobBuilder.Create<Export>().Build();

            ITrigger triggerExport = TriggerBuilder.Create()
                .WithDailyTimeIntervalSchedule
                  (s =>
                    // s.WithIntervalInHours(24)
                    //s.WithIntervalInSeconds(120)
                    s.WithIntervalInSeconds(intervalTimeInSecondForExport)
                    .OnEveryDay()
                    .StartingDailyAt(TimeOfDay.HourAndMinuteOfDay(0, 0))
                  )
                .Build();

            await scheduler.ScheduleJob(jobExport, triggerExport);

            //------End-----schedule Export--------------------------------------------------
            #endregion
        }
    }
}

