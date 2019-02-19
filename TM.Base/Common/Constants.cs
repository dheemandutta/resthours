using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

namespace TM.Base.Common
{
    public static class Constants
    {
        //ILO Working Hours
        public const double ILOWeekDayWorkingHours = 10;
        public const double ILOSaturdayWorkingHours = 10;
        public const double ILOSundayWorkingHours = 0;
    }

    public enum Months
    {
        January = 1,
        February = 2,
        March = 3,
        April = 4,
        May = 5,
        June=6,
        July = 7,
        August = 8,
        September = 9,
        October = 10,
        November = 11,
        December = 12
    }

	public enum ShortMonths
	{
		Jan = 1,
		Feb = 2,
		Mar = 3,
		Apr = 4,
		May = 5,
		Jun = 6,
		Jul = 7,
		Aug = 8,
		Sep = 9,
		Oct = 10,
		Nov = 11,
		Dec = 12
	}

	public static class Utilities
    {
        public static string GetLast(string source, int last)
        {
            return last >= source.Length ? source : source.Substring(source.Length - last);
        }

        public static DateTime ToDateTime(this string datetime,  char timeSpliter = ':', char millisecondSpliter = ',')
        {
            char dateSpliter = Convert.ToChar(datetime.Substring(2, 1));

            try
            {
                datetime = datetime.Trim();
                datetime = datetime.Replace("  ", " ");
                string[] body = datetime.Split(' ');
                string[] date = body[0].Split(dateSpliter);
                int year = int.Parse(date[0].ToString());
                int month = int.Parse(date[1].ToString());
                int day = int.Parse(date[2].ToString());
                int hour = 0, minute = 0, second = 0, millisecond = 0;
                if (body.Length == 2)
                {
                    string[] tpart = body[1].Split(millisecondSpliter);
                    string[] time = tpart[0].Split(timeSpliter);
                    hour = int.Parse(time[0].ToString());
                    minute = int.Parse(time[1].ToString());
                    if (time.Length == 3) second = int.Parse(time[2].ToString());
                    if (tpart.Length == 2) millisecond = int.Parse(tpart[1].ToString());
                }
                return new DateTime(year, month, day, hour, minute, second, millisecond);
            }
            catch
            {
                return new DateTime();
            }
        }

		public static DateTime FormatDate(this string inputDate, string inputDateFormat, string inputDateSeperator, string outputDateFormat, string outputSeperator)
		{
			DateTime outputDate = new DateTime();
			string datePart = string.Empty;
			string monthPart = string.Empty;
			string yearPart = string.Empty;
			string stroutputDate = string.Empty;
			int month;


			string[] datearray = inputDate.Split(inputDateSeperator.ToCharArray());

			if (inputDateFormat == "dd-MMM-yyyy" || inputDateFormat == "dd/MMM/yyyy" || inputDateFormat == "dd/MM/yyyy")
			{
				datePart = datearray[0];
				monthPart = datearray[1];
				yearPart = datearray[2];


			}



			if (outputDateFormat == "MM/dd/yyyy")
			{
				if (inputDateFormat == "dd-MMM-yyyy" || inputDateFormat == "dd/MMM/yyyy")
					month = (int)Enum.Parse(typeof(ShortMonths), monthPart);
				else
					month = int.Parse(monthPart);
				int date = Convert.ToInt32(datePart);

				stroutputDate = month.ToString("D2") + outputSeperator.ToString() + date.ToString("D2") + outputSeperator.ToString() + yearPart;
				outputDate = DateTime.ParseExact(stroutputDate, "MM/dd/yyyy", CultureInfo.InvariantCulture);

			}

			


			return outputDate;
		}
	}
}