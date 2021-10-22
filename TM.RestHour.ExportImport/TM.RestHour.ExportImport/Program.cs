using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Quartz;

namespace TM.RestHour.ExportImport
{
    static class Program
    {

        private static IScheduler scheduler;
        static void Main(string[] args)
        {
            ExportImportScheduler.Start();
            Console.ReadKey();
            scheduler.Shutdown();
        }
    }
}
