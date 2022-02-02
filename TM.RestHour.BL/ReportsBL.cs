using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.Base.Common;
using System.Globalization;
using System.Xml.Linq;
using System.Collections;

using System.Configuration;

namespace TM.RestHour.BL
{
    public class ReportsBL
    {

        private double GetNormalWorkingHours(string bookdate)
        {
            DateTime currentDate = bookdate.ToDateTime();  //DateTime.ParseExact(bookdate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
            DayOfWeek dayOfWeek = currentDate.DayOfWeek;

            if (dayOfWeek == DayOfWeek.Sunday)
                return Constants.ILOSundayWorkingHours;
            else if (dayOfWeek == DayOfWeek.Saturday)
                return Constants.ILOSaturdayWorkingHours;
            else
                return Constants.ILOWeekDayWorkingHours;

        }

        private string GetMaxNRRestPeriodStatus(string complianceInfo)
        {
            if(!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                return myEle.Element("maxnrrestperiodstatus").Value;
            }
            return String.Empty;
        }


        private string GetMaxRestPeriodStatus(string complianceInfo)
        {
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                return myEle.Element("maxrestperiodstatus").Value;
            }
            return String.Empty;
        }

        private string GetSevenDayStatus(string complianceInfo)
        {
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                return myEle.Element("sevendaysstatus").Value;
            }
            return String.Empty;
        }

        private string GetTwentFourHourRestHourStatus(string complianceInfo)
        {
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                return myEle.Element("twentyfourhourresthoursstatus").Value;
            }
            return String.Empty;
        }

        private string GetMinSevenDayRest(string complianceInfo)
        {
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                return myEle.Element("minsevendaysrest").Value;
            }
            return String.Empty;
        }

        private string GetMinTwentyFourHourrest(string complianceInfo)
        {
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                return myEle.Element("mintwentyfourhoursrest").Value;
            }
            return "0";
        }

        private string GetMaxRestPeriodInTwentyFourHours(string complianceInfo)
        {
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                return myEle.Element("mintwentyfourhoursrest").Value;//maxrestperiodintewntyfourhours
            }
            return String.Empty;
        }



        private string GetMaxNrOfrestPeriod(string complianceInfo)
        {
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                return myEle.Element("maxnrofrestperiod").Value;
            }
            return String.Empty;
        }

        private string GetCompliance(string complianceInfo)
        {
            StringBuilder arr = new StringBuilder();
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                arr.Append( myEle.Element("maxnrrestperiodstatus").Value);
                arr.Append("<br/>");
                arr.Append(myEle.Element("maxrestperiodstatus").Value);
                arr.Append("<br/>");
                arr.Append(myEle.Element("sevendaysstatus").Value);
                arr.Append("<br/>");
                arr.Append(myEle.Element("twentyfourhourresthoursstatus").Value);
                arr.Append("<br/>");

                return arr.ToString();
            }
            return String.Empty;
        }


        private string GetComplianceforPdf(string complianceInfo)
        {
            StringBuilder arr = new StringBuilder();
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                arr.Append(myEle.Element("maxnrrestperiodstatus").Value);
                arr.Append("\n");
                arr.Append(myEle.Element("maxrestperiodstatus").Value);
                arr.Append("\n");
                arr.Append(myEle.Element("sevendaysstatus").Value);
                arr.Append("\n");
                arr.Append(myEle.Element("twentyfourhourresthoursstatus").Value);
                arr.Append("\n");

                return arr.ToString();
            }
            return String.Empty;
        }

        private string GetTotalWorkedHours(string complianceInfo)
        {
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                return myEle.Element("totalworkedhours").Value;
            }
            return "0";
        }

		private string GetTotalWorkedHoursForWeb(string complianceInfo, bool isWithonServiceTerm)
		{
			if (!string.IsNullOrEmpty(complianceInfo) && isWithonServiceTerm == false)
			{
				XElement myEle = XElement.Parse(complianceInfo);
				return myEle.Element("totalworkedhours").Value;
			}
			return "0";
		}

		private string GetOvertimeHours(string complianceInfo)
        {
            if (!string.IsNullOrEmpty(complianceInfo))
            {
                XElement myEle = XElement.Parse(complianceInfo);
                return myEle.Element("overtimeHours").Value;
            }
            return "0";
        }

        public List<ReportsPOCO> GetCrewIDFromWorkSessionsForWeb(ReportsPOCO reportsPOCO,int VesselID)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
            double totalNormal = 0;
            double totalOvertime = 0;
			double totalhrs = 0;
			double totalRest = 0;


            reportsList = reportsDAL.GetCrewIDFromWorkSessions(reportsPOCO, VesselID);
			bool hasOverTime = GetCrewOverTimeStatus(reportsPOCO.CrewID);

            foreach (ReportsPOCO item in reportsList)
            {
                //double normalWorkingHours = Convert.ToDouble(GetNormalWorkingHoursForReport(item.WorkDate));
                

                item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                //item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);                                  //////////////////////
                                      /////////////////////
                item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);

				if (item.MaxRestPeriodInTwentyFourHours == "25") item.MaxRestPeriodInTwentyFourHours = "-";

                item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                item.TotalWorkedHours = GetTotalWorkedHoursForWeb(item.ComplianceInfo,item.IsWithinServiceTerm);
				item.MinTwentyFourHourrest = Convert.ToString((decimal)(24 - Convert.ToDecimal(item.TotalWorkedHours))); //GetMinTwentyFourHourrest(item.ComplianceInfo);
				if (hasOverTime)
					item.OvertimeHours = CalculateOvertimeHours(Convert.ToDecimal(item.TotalWorkedHours), item.WorkDate); //GetOvertimeHours(item.ComplianceInfo);
				else
					item.OvertimeHours = "0";      // deep
                item.NormalWorkingHours = Convert.ToDouble(CalculateNormalWorkingHours(item.WorkDate));//Convert.ToDouble(item.TotalWorkedHours) - Convert.ToDouble(item.OvertimeHours);
				totalNormal += item.NormalWorkingHours;
                totalOvertime += double.Parse(item.OvertimeHours);
                totalhrs += double.Parse(item.TotalWorkedHours);
                totalRest += double.Parse(item.MinTwentyFourHourrest);                                           //////////////////////


                var bookedhrs = item.Hours;
                hrsfullday = string.Empty;

                //check for adjustemnet factor and chnage time to display accordingly

                if(item.AdjustmentFactor == "-1")
                {
                    //check the occurance of the first 1 
                    int firstpos = bookedhrs.IndexOf('1');

                    if(firstpos >= 2)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();
                        chhrs[firstpos - 2] = '1';
                        chhrs[firstpos - 1] = '1';

                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasOneFirst = false;
                    }
                    else if (firstpos == 1)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();
                        chhrs[firstpos - 1] = '1';
                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasOneFirst = false;
                    }
                    else if(firstpos ==0)
                    {
                        item.HasOneFirst = true;
                    }

                }

                if (item.AdjustmentFactor == "-30")
                {
                    //check the occurance of the first 1 
                    int firstpos = bookedhrs.IndexOf('1');

                    if (firstpos >= 1)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();
                        
                        chhrs[firstpos - 1] = '1';

                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasThirtyFirst= false;
                    }
                    else if (firstpos == 0)
                    {
                        //char[] chhrs = bookedhrs.ToCharArray();
                        //chhrs[firstpos - 1] = '1';
                        //bookedhrs = string.Empty;
                        //bookedhrs = new string(chhrs);

                        item.HasThirtyFirst = true;
                    }
                    //else if (firstpos == 0)
                    //{
                    //    item.HasThirtyFirst = true;
                    //}

                }

                // now slice into 2, as two make an hour
                for (int i = 0; i < 48; i += 2)
                {

                    string hr = bookedhrs.Substring(i, 2);

                    if (hr == "00")
                    {
                        hrsfullday = hrsfullday + "0";
                    }
                    else if (hr == "01")
                    {
                        hrsfullday = hrsfullday + "3";
                    }
                    else if (hr == "10")
                    {
                        hrsfullday = hrsfullday + "4";
                    }
                    else if (hr == "11")
                    {
                        hrsfullday = hrsfullday + "1";
                    }

                    hr = string.Empty;
                }

                item.Hours = hrsfullday;


            }

			if (reportsList.Count > 0)
			{
				reportsList[0].TotalNormalHours = totalNormal.ToString();
				reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
				reportsList[0].TotalHours = totalhrs.ToString();
				reportsList[0].TotalRestHours = totalRest.ToString();
			}

            return reportsList;
        }

		private bool GetCrewOverTimeStatus(int crewId)
		{
			ReportsDAL reportsDAL = new ReportsDAL();
			return reportsDAL.GetCrewOverTimeStatus(crewId);
		}

        private string CalculateNormalWorkingHours(string workDate)
        {
            DateTime dt = workDate.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), "/", ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
            int day = ((int)dt.DayOfWeek == 0) ? 7 : (int)dt.DayOfWeek;
            int normalworkingHours = GetWorkingHours(day, 0);
            if (normalworkingHours == 1) 
            {
                normalworkingHours = 8;
            }
            else if (normalworkingHours == 2)
            {
                normalworkingHours = 4;
            }
            else if (normalworkingHours == 0)
            {
                normalworkingHours = 0;
            }

            return normalworkingHours.ToString();
        }

		private string CalculateOvertimeHours(decimal workedHours, string workDate)
		{
            bool isWeekly = true;
            OvertimeCalculationBL overtimeCalculationBL = new OvertimeCalculationBL();
            isWeekly = overtimeCalculationBL.GetIsWeeklyFromOvertimeCalculation();
            decimal overtimeHours=0;
            decimal fixedOvertime = 0;

            //if (isWeekly)
            //{
                DateTime dt = workDate.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), "/", ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
                int day = ((int)dt.DayOfWeek == 0) ? 7 : (int)dt.DayOfWeek;
                int normalworkingHours = GetWorkingHours(day, 0);
            if (normalworkingHours == 1)
                normalworkingHours = 8;
            else if (normalworkingHours == 2)
                normalworkingHours = 4;
            else if (normalworkingHours == 0)
                normalworkingHours = 0;

            overtimeHours = workedHours - normalworkingHours;
            //}
            //else
            //{
            //    decimal weeklyworkedhrs = 0;
            //    fixedOvertime = overtimeCalculationBL.GetFixedOvertimeFromOvertimeCalculation();
            //    overtimeHours = workedHours - fixedOvertime;
            //    //weeklyworkedhr


            //}
            
            

			if (overtimeHours > 0)
				return overtimeHours.ToString();
			else
				return "0";

			
		}

		private string GetNormalWorkingHoursForReport(string workDate)
		{
			DateTime dt = workDate.FormatDate(ConfigurationManager.AppSettings["InputDateFormat"].ToString(), "/", ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());
			int day = ((int)dt.DayOfWeek == 0) ? 7 : (int)dt.DayOfWeek;

			int normalworkingHours = GetWorkingHours(day, 0);

			return normalworkingHours.ToString();
		}

		public int GetWorkingHours(int DayNumber, int RegimeID)
		{
			ReportsDAL reportsDAL = new ReportsDAL();
			return reportsDAL.GetWorkingHours(DayNumber, RegimeID);
		}

		public List<ReportsPOCO> GetCrewIDFromWorkSessions(ReportsPOCO reportsPOCO,int VesselID)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
            double totalNormal = 0;
            double totalOvertime = 0;
            double totalhrs = 0;
            double totalRest = 0;


            reportsList =  reportsDAL.GetCrewIDFromWorkSessions(reportsPOCO, VesselID);

            foreach (ReportsPOCO item in reportsList)
            {
                double normalWorkingHours = GetNormalWorkingHours(item.WorkDate);
                item.NormalWorkingHours = normalWorkingHours;

                item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
                item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
                item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
				//if (item.MaxRestPeriodInTwentyFourHours == "25") item.MaxRestPeriodInTwentyFourHours = "-";


				item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
                item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);

                totalNormal += item.NormalWorkingHours;
                totalOvertime += double.Parse(item.OvertimeHours);
                totalhrs += double.Parse(item.TotalWorkedHours);
                totalRest += double.Parse(item.MinTwentyFourHourrest);


                var bookedhrs = item.Hours;
                hrsfullday = string.Empty;


               
                // now slice into 2, as two make an hour
                //for (int i = 0; i < 48; i+=2)
                //{
                   
                //    string hr = bookedhrs.Substring(i, 2); 

                //    if(hr == "00")
                //    {
                //        hrsfullday = hrsfullday + "0";
                //    }
                //    else if(hr =="01")
                //    {
                //        hrsfullday = hrsfullday + "3";
                //    }
                //    else if (hr == "10")
                //    {
                //        hrsfullday = hrsfullday + "4";
                //    }
                //    else if (hr == "11")
                //    {
                //        hrsfullday = hrsfullday + "1";
                //    }

                //    hr = string.Empty;
                //}

                //item.Hours = hrsfullday;
                

            }

            reportsList[0].TotalNormalHours = totalNormal.ToString();
            reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
            reportsList[0].TotalHours = totalhrs.ToString();
            reportsList[0].TotalRestHours = totalRest.ToString();

            return reportsList;
        }



        public List<ReportsPOCO> GetVarianceFromWorkSessions(ReportsPOCO reportsPOCO, int pageIndex, ref int recordCount, int length, int VesselID)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
            double totalNormal = 0;
            double totalOvertime = 0;
            double totalhrs = 0;
            double totalRest = 0;
            bool hasOverTime = false;
            reportsList = reportsDAL.GetDataForVarianceReport(reportsPOCO,pageIndex,ref recordCount,length, VesselID);
            hasOverTime = GetCrewOverTimeStatus(reportsPOCO.CrewID);
            if (reportsList.Count > 0)
            {
                foreach (ReportsPOCO item in reportsList)
                {
                    //OLDCode
                    //double normalWorkingHours = GetNormalWorkingHours(item.WorkDate);
                    //item.NormalWorkingHours = normalWorkingHours;

                    //item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                    //item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                    //item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                    //item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                    //item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
                    //item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
                    //item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
                    //item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                    //item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
                    //item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);
                    //item.FomattedComplianceInfo = GetCompliance(item.ComplianceInfo);

                    //totalNormal += item.NormalWorkingHours;
                    //totalOvertime += double.Parse(item.OvertimeHours);
                    //totalhrs += double.Parse(item.TotalWorkedHours);
                    //totalRest += double.Parse(item.MinTwentyFourHourrest);

                  

                    item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                    item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                    item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                    item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                    //item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);                                  //////////////////////
                    /////////////////////
                    item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);

                    if (item.MaxRestPeriodInTwentyFourHours == "25") item.MaxRestPeriodInTwentyFourHours = "-";

                    item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                    item.TotalWorkedHours = GetTotalWorkedHoursForWeb(item.ComplianceInfo, item.IsWithinServiceTerm);
                    item.MinTwentyFourHourrest = Convert.ToString((decimal)(24 - Convert.ToDecimal(item.TotalWorkedHours))); //GetMinTwentyFourHourrest(item.ComplianceInfo);
                    if (hasOverTime)
                        item.OvertimeHours = CalculateOvertimeHours(Convert.ToDecimal(item.TotalWorkedHours), item.WorkDate); //GetOvertimeHours(item.ComplianceInfo);
                    else
                        item.OvertimeHours = "0";
                    item.NormalWorkingHours = Convert.ToDouble(item.TotalWorkedHours) - Convert.ToDouble(item.OvertimeHours);
                    totalNormal += item.NormalWorkingHours;
                    totalOvertime += double.Parse(item.OvertimeHours);
                    totalhrs += double.Parse(item.TotalWorkedHours);
                    totalRest += double.Parse(item.MinTwentyFourHourrest);
                    item.FomattedComplianceInfo = GetCompliance(item.ComplianceInfo);
                    var bookedhrs = item.Hours;
                    hrsfullday = string.Empty;
                }
                reportsList[0].TotalNormalHours = totalNormal.ToString();
                reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
                reportsList[0].TotalHours = totalhrs.ToString();
                reportsList[0].TotalRestHours = totalRest.ToString();
                //compliance
            }

			recordCount = reportsList.Count;
			return reportsList;
        }


        public List<ReportsPOCO> GetVarianceFromWorkSessionsForPdf(ReportsPOCO reportsPOCO, int pageIndex, ref int recordCount, int length, int VesselID)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
            double totalNormal = 0;
			double totalOvertime = 0;
			double totalhrs = 0;
			double totalRest = 0;
            reportsList = reportsDAL.GetDataForVarianceReport(reportsPOCO, pageIndex, ref recordCount, length, VesselID);
            if (reportsList.Count > 0)
            {
                foreach (ReportsPOCO item in reportsList)
                {
                    

                    double normalWorkingHours = GetNormalWorkingHours(item.WorkDate);
                    item.NormalWorkingHours = normalWorkingHours;

                    item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                    item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                    item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                    item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                    item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
                    item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
                    item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
                    item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                    item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
                    item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);
                    item.FomattedComplianceInfo = GetComplianceforPdf(item.ComplianceInfo);

                    totalNormal += item.NormalWorkingHours;
                    totalOvertime += double.Parse(item.OvertimeHours);
                    totalhrs += double.Parse(item.TotalWorkedHours);
                    totalRest += double.Parse(item.MinTwentyFourHourrest);

                    var bookedhrs = item.Hours;
                    hrsfullday = string.Empty;
                }
                reportsList[0].TotalNormalHours = totalNormal.ToString();
                reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
                reportsList[0].TotalHours = totalhrs.ToString();
                reportsList[0].TotalRestHours = totalRest.ToString();
                //compliance
            }
            return reportsList;
        }


        public List<ReportsPOCO> GetDayWiseCrewBookingData(ReportsPOCO reportsPOCO,int VesselID)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
            double totalNormal = 0;
			double totalOvertime = 0;
			double totalhrs = 0;
			double totalRest = 0;
            bool hasOverTime = false;

            
            reportsList = reportsDAL.GetDayWiseCrewBookingData(reportsPOCO, VesselID);

            foreach (ReportsPOCO item in reportsList)
            {
                //OLD WORKING CODE
                //double normalWorkingHours = GetNormalWorkingHours(item.BookDate);
                //            item.NormalWorkingHours = normalWorkingHours;

                //            item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                //            item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                //            item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                //            item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                //            item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
                //            item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
                //            item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
                //            item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                //            item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
                //            item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);


                hasOverTime = GetCrewOverTimeStatus(item.CrewID);

                item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                //item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);                                  //////////////////////
                /////////////////////
                item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);

                if (item.MaxRestPeriodInTwentyFourHours == "25") item.MaxRestPeriodInTwentyFourHours = "-";

                item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                item.TotalWorkedHours = GetTotalWorkedHoursForWeb(item.ComplianceInfo, item.IsWithinServiceTerm);
                item.MinTwentyFourHourrest = Convert.ToString((decimal)(24 - Convert.ToDecimal(item.TotalWorkedHours))); //GetMinTwentyFourHourrest(item.ComplianceInfo);
                if (hasOverTime)
                    item.OvertimeHours = CalculateOvertimeHours(Convert.ToDecimal(item.TotalWorkedHours), item.WorkDate); //GetOvertimeHours(item.ComplianceInfo);
                else
                    item.OvertimeHours = "0";
                item.NormalWorkingHours = Convert.ToDouble(item.TotalWorkedHours) - Convert.ToDouble(item.OvertimeHours);
                totalNormal += item.NormalWorkingHours;
                totalOvertime += double.Parse(item.OvertimeHours);
                totalhrs += double.Parse(item.TotalWorkedHours);
                totalRest += double.Parse(item.MinTwentyFourHourrest);

                //item.Month = DateTime.ParseExact(reportsPOCO.BookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Month ;//(int)((Months)Enum.Parse(typeof(Months), month.Trim()));
                DateTime dt = reportsPOCO.BookDate.FormatDate
                            (ConfigurationManager.AppSettings["InputDateFormat"].ToString(), ConfigurationManager.AppSettings["InputDateSeperator"].ToString(),
                             ConfigurationManager.AppSettings["OutputDateFormat"].ToString(), ConfigurationManager.AppSettings["OutputDateSeperator"].ToString());

                item.Month = dt.Month;


                item.MonthName = ((Months)item.Month).ToString() ;
                item.Year = int.Parse(Utilities.GetLast(reportsPOCO.BookDate , 4));
                item.Name = ((Months)item.Month).ToString();

                totalNormal += item.NormalWorkingHours;
                totalOvertime += double.Parse(item.OvertimeHours);
                totalhrs += double.Parse(item.TotalWorkedHours);
                totalRest += double.Parse(item.MinTwentyFourHourrest);


                var bookedhrs = item.Hours;
                hrsfullday = string.Empty;

                if (item.AdjustmentFactor == "-1")
                {
                    //check the occurance of the first 1 
                    int firstpos = bookedhrs.IndexOf('1');

                    if (firstpos >= 2)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();
                        chhrs[firstpos - 2] = '1';
                        chhrs[firstpos - 1] = '1';

                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasOneFirst = false;
                    }
                    else if (firstpos == 1)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();
                        chhrs[firstpos - 1] = '1';
                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasOneFirst = false;
                    }
                    else if (firstpos == 0)
                    {
                        item.HasOneFirst = true;
                    }

                }

                if (item.AdjustmentFactor == "-30")
                {
                    //check the occurance of the first 1 
                    int firstpos = bookedhrs.IndexOf('1');

                    if (firstpos >= 1)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();

                        chhrs[firstpos - 1] = '1';

                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasThirtyFirst = false;
                    }
                    else if (firstpos == 0)
                    {
                        //char[] chhrs = bookedhrs.ToCharArray();
                        //chhrs[firstpos - 1] = '1';
                        //bookedhrs = string.Empty;
                        //bookedhrs = new string(chhrs);

                        item.HasThirtyFirst = true;
                    }
                    //else if (firstpos == 0)
                    //{
                    //    item.HasThirtyFirst = true;
                    //}

                }

                // now slice into 2, as two make an hour
                for (int i = 0; i < 48; i += 2)
                {

                    string hr = bookedhrs.Substring(i, 2);

                    if (hr == "00")
                    {
                        hrsfullday = hrsfullday + "0";
                    }
                    else if (hr == "01")
                    {
                        hrsfullday = hrsfullday + "3";
                    }
                    else if (hr == "10")
                    {
                        hrsfullday = hrsfullday + "4";
                    }
                    else if (hr == "11")
                    {
                        hrsfullday = hrsfullday + "1";
                    }

                    hr = string.Empty;
                }

                item.Hours = hrsfullday;

            }//end for


            if (reportsList.Count > 0)
            {
                reportsList[0].TotalNormalHours = totalNormal.ToString();
                reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
                reportsList[0].TotalHours = totalhrs.ToString();
                reportsList[0].TotalRestHours = totalRest.ToString();
            }

            return reportsList;
        }












        public List<ReportsPOCO> GetCrewIDFromWorkSessions9(ReportsPOCO reportsPOCO,int VesselID)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
            double totalNormal = 0;
            double totalOvertime = 0;
            double totalhrs = 0;
            double totalRest = 0;


            reportsList = reportsDAL.GetCrewIDFromWorkSessions9(reportsPOCO, VesselID);

            foreach (ReportsPOCO item in reportsList)
            {
                double normalWorkingHours = GetNormalWorkingHours(item.WorkDate);
                item.NormalWorkingHours = normalWorkingHours;

                item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
                item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
                item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
                item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
                item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);

                totalNormal += item.NormalWorkingHours;
                totalOvertime += double.Parse(item.OvertimeHours);
                totalhrs += double.Parse(item.TotalWorkedHours);
                totalRest += double.Parse(item.MinTwentyFourHourrest);


                var bookedhrs = item.Hours;
                hrsfullday = string.Empty;



                // now slice into 2, as two make an hour
                //for (int i = 0; i < 48; i+=2)
                //{

                //    string hr = bookedhrs.Substring(i, 2); 

                //    if(hr == "00")
                //    {
                //        hrsfullday = hrsfullday + "0";
                //    }
                //    else if(hr =="01")
                //    {
                //        hrsfullday = hrsfullday + "3";
                //    }
                //    else if (hr == "10")
                //    {
                //        hrsfullday = hrsfullday + "4";
                //    }
                //    else if (hr == "11")
                //    {
                //        hrsfullday = hrsfullday + "1";
                //    }

                //    hr = string.Empty;
                //}

                //item.Hours = hrsfullday;


            }

            reportsList[0].TotalNormalHours = totalNormal.ToString();
            reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
            reportsList[0].TotalHours = totalhrs.ToString();
            reportsList[0].TotalRestHours = totalRest.ToString();

            return reportsList;
        }

        public List<ReportsPOCO> GetCrewIDFromWorkSessionsForWeb9(ReportsPOCO reportsPOCO,int VesselID)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
            double totalNormal = 0;
			double totalOvertime = 0;
			double totalhrs = 0;
			double totalRest = 0;


            reportsList = reportsDAL.GetCrewIDFromWorkSessions9(reportsPOCO, VesselID);

            foreach (ReportsPOCO item in reportsList)
            {
				double normalWorkingHours = GetNormalWorkingHours(item.WorkDate);
                item.NormalWorkingHours = normalWorkingHours;

                item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
                item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
                item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
                item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
                item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);

                totalNormal += item.NormalWorkingHours;
                totalOvertime += double.Parse(item.OvertimeHours);
                totalhrs += double.Parse(item.TotalWorkedHours);
                totalRest += double.Parse(item.MinTwentyFourHourrest);


                var bookedhrs = item.Hours;
                hrsfullday = string.Empty;

                //check for adjustemnet factor and chnage time to display accordingly

                if (item.AdjustmentFactor == "-1")
                {
                    //check the occurance of the first 1 
                    int firstpos = bookedhrs.IndexOf('1');

                    if (firstpos >= 2)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();
                        chhrs[firstpos - 2] = '1';
                        chhrs[firstpos - 1] = '1';

                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasOneFirst = false;
                    }
                    else if (firstpos == 1)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();
                        chhrs[firstpos - 1] = '1';
                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasOneFirst = false;
                    }
                    else if (firstpos == 0)
                    {
                        item.HasOneFirst = true;
                    }

                }

                if (item.AdjustmentFactor == "-30")
                {
                    //check the occurance of the first 1 
                    int firstpos = bookedhrs.IndexOf('1');

                    if (firstpos >= 1)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();

                        chhrs[firstpos - 1] = '1';

                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasThirtyFirst = false;
                    }
                    else if (firstpos == 0)
                    {
                        //char[] chhrs = bookedhrs.ToCharArray();
                        //chhrs[firstpos - 1] = '1';
                        //bookedhrs = string.Empty;
                        //bookedhrs = new string(chhrs);

                        item.HasThirtyFirst = true;
                    }
                    //else if (firstpos == 0)
                    //{
                    //    item.HasThirtyFirst = true;
                    //}

                }

                // now slice into 2, as two make an hour
                for (int i = 0; i < 48; i += 2)
                {

                    string hr = bookedhrs.Substring(i, 2);

                    if (hr == "00")
                    {
                        hrsfullday = hrsfullday + "0";
                    }
                    else if (hr == "01")
                    {
                        hrsfullday = hrsfullday + "3";
                    }
                    else if (hr == "10")
                    {
                        hrsfullday = hrsfullday + "4";
                    }
                    else if (hr == "11")
                    {
                        hrsfullday = hrsfullday + "1";
                    }

                    hr = string.Empty;
                }

                item.Hours = hrsfullday;


            }

            reportsList[0].TotalNormalHours = totalNormal.ToString();
            reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
            reportsList[0].TotalHours = totalhrs.ToString();
            reportsList[0].TotalRestHours = totalRest.ToString();

            return reportsList;
        }

        //public List<ReportsPOCO> GetDayWiseCrewBookingData9(ReportsPOCO reportsPOCO)
        //{
        //    ReportsDAL reportsDAL = new ReportsDAL();
        //    List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
        //    string hrsfullday = string.Empty;
        //    int totalNormal = 0;
        //    int totalOvertime = 0;
        //    int totalhrs = 0;
        //    int totalRest = 0;


        //    reportsList = reportsDAL.GetDayWiseCrewBookingData9(reportsPOCO);

        //    foreach (ReportsPOCO item in reportsList)
        //    {
        //        int normalWorkingHours = GetNormalWorkingHours(item.BookDate);
        //        item.NormalWorkingHours = normalWorkingHours;

        //        item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
        //        item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
        //        item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
        //        item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
        //        item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
        //        item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
        //        item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
        //        item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
        //        item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
        //        item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);
        //        item.Month = DateTime.ParseExact(reportsPOCO.BookDate, "MM/dd/yyyy", CultureInfo.InvariantCulture).Month;//(int)((Months)Enum.Parse(typeof(Months), month.Trim()));
        //        item.MonthName = ((Months)item.Month).ToString();
        //        item.Year = int.Parse(Utilities.GetLast(reportsPOCO.BookDate, 4));
        //        item.Name = ((Months)item.Month).ToString();

        //        totalNormal += item.NormalWorkingHours;
        //        totalOvertime += int.Parse(item.OvertimeHours);
        //        totalhrs += int.Parse(item.TotalWorkedHours);
        //        totalRest += int.Parse(item.MinTwentyFourHourrest);


        //        var bookedhrs = item.Hours;
        //        hrsfullday = string.Empty;

        //        if (item.AdjustmentFactor == "-1")
        //        {
        //            //check the occurance of the first 1 
        //            int firstpos = bookedhrs.IndexOf('1');

        //            if (firstpos >= 2)
        //            {
        //                char[] chhrs = bookedhrs.ToCharArray();
        //                chhrs[firstpos - 2] = '1';
        //                chhrs[firstpos - 1] = '1';

        //                bookedhrs = string.Empty;
        //                bookedhrs = new string(chhrs);

        //                item.HasOneFirst = false;
        //            }
        //            else if (firstpos == 1)
        //            {
        //                char[] chhrs = bookedhrs.ToCharArray();
        //                chhrs[firstpos - 1] = '1';
        //                bookedhrs = string.Empty;
        //                bookedhrs = new string(chhrs);

        //                item.HasOneFirst = false;
        //            }
        //            else if (firstpos == 0)
        //            {
        //                item.HasOneFirst = true;
        //            }

        //        }

        //        if (item.AdjustmentFactor == "-30")
        //        {
        //            //check the occurance of the first 1 
        //            int firstpos = bookedhrs.IndexOf('1');

        //            if (firstpos >= 1)
        //            {
        //                char[] chhrs = bookedhrs.ToCharArray();

        //                chhrs[firstpos - 1] = '1';

        //                bookedhrs = string.Empty;
        //                bookedhrs = new string(chhrs);

        //                item.HasThirtyFirst = false;
        //            }
        //            else if (firstpos == 0)
        //            {
        //                //char[] chhrs = bookedhrs.ToCharArray();
        //                //chhrs[firstpos - 1] = '1';
        //                //bookedhrs = string.Empty;
        //                //bookedhrs = new string(chhrs);

        //                item.HasThirtyFirst = true;
        //            }
        //            //else if (firstpos == 0)
        //            //{
        //            //    item.HasThirtyFirst = true;
        //            //}

        //        }

        //        // now slice into 2, as two make an hour
        //        for (int i = 0; i < 48; i += 2)
        //        {

        //            string hr = bookedhrs.Substring(i, 2);

        //            if (hr == "00")
        //            {
        //                hrsfullday = hrsfullday + "0";
        //            }
        //            else if (hr == "01")
        //            {
        //                hrsfullday = hrsfullday + "3";
        //            }
        //            else if (hr == "10")
        //            {
        //                hrsfullday = hrsfullday + "4";
        //            }
        //            else if (hr == "11")
        //            {
        //                hrsfullday = hrsfullday + "1";
        //            }

        //            hr = string.Empty;
        //        }

        //        item.Hours = hrsfullday;

        //    }//end for


        //    if (reportsList.Count > 0)
        //    {
        //        reportsList[0].TotalNormalHours = totalNormal.ToString();
        //        reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
        //        reportsList[0].TotalHours = totalhrs.ToString();
        //        reportsList[0].TotalRestHours = totalRest.ToString();
        //    }

        //    return reportsList;
        //}


        public List<ReportsPOCO> GetNCDetails(int Month, int Year,int VesselID, int userId)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            
            reportsList = reportsDAL.GetNCDetails(Month, Year, VesselID, userId);
            //if (reportsList.Count > 0)
            //{
            //    foreach (ReportsPOCO item in reportsList)
            //    {
            //        int normalWorkingHours = GetNormalWorkingHours(item.WorkDate);
            //        item.NormalWorkingHours = normalWorkingHours;

            //        //item.Month = GetMaxNRRestPeriodStatus(item.ComplianceInfo);

            //        //totalNormal += item.NormalWorkingHours;
            //        //totalOvertime += int.Parse(item.OvertimeHours);
            //        //totalhrs += int.Parse(item.TotalWorkedHours);
            //        //totalRest += int.Parse(item.MinTwentyFourHourrest);

                   
            //    }
              
            //}
            return reportsList;
        }




        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        public List<ReportsPOCO> GetCrewIDFromWorkSessionsForWebForUser(ReportsPOCO reportsPOCO)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
			double totalNormal = 0;
			double totalOvertime = 0;
			double totalhrs = 0;
			double totalRest = 0;


            reportsList = reportsDAL.GetCrewIDFromWorkSessionsForUser(reportsPOCO);

            foreach (ReportsPOCO item in reportsList)
            {
				double normalWorkingHours = GetNormalWorkingHours(item.WorkDate);
                item.NormalWorkingHours = normalWorkingHours;

                item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
                item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
                item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
                item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
                item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);

                totalNormal += item.NormalWorkingHours;
                totalOvertime += double.Parse(item.OvertimeHours);
                totalhrs += double.Parse(item.TotalWorkedHours);
                totalRest += double.Parse(item.MinTwentyFourHourrest);


                var bookedhrs = item.Hours;
                hrsfullday = string.Empty;

                //check for adjustemnet factor and chnage time to display accordingly

                if (item.AdjustmentFactor == "-1")
                {
                    //check the occurance of the first 1 
                    int firstpos = bookedhrs.IndexOf('1');

                    if (firstpos >= 2)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();
                        chhrs[firstpos - 2] = '1';
                        chhrs[firstpos - 1] = '1';

                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasOneFirst = false;
                    }
                    else if (firstpos == 1)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();
                        chhrs[firstpos - 1] = '1';
                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasOneFirst = false;
                    }
                    else if (firstpos == 0)
                    {
                        item.HasOneFirst = true;
                    }

                }

                if (item.AdjustmentFactor == "-30")
                {
                    //check the occurance of the first 1 
                    int firstpos = bookedhrs.IndexOf('1');

                    if (firstpos >= 1)
                    {
                        char[] chhrs = bookedhrs.ToCharArray();

                        chhrs[firstpos - 1] = '1';

                        bookedhrs = string.Empty;
                        bookedhrs = new string(chhrs);

                        item.HasThirtyFirst = false;
                    }
                    else if (firstpos == 0)
                    {
                        //char[] chhrs = bookedhrs.ToCharArray();
                        //chhrs[firstpos - 1] = '1';
                        //bookedhrs = string.Empty;
                        //bookedhrs = new string(chhrs);

                        item.HasThirtyFirst = true;
                    }
                    //else if (firstpos == 0)
                    //{
                    //    item.HasThirtyFirst = true;
                    //}

                }

                // now slice into 2, as two make an hour
                for (int i = 0; i < 48; i += 2)
                {

                    string hr = bookedhrs.Substring(i, 2);

                    if (hr == "00")
                    {
                        hrsfullday = hrsfullday + "0";
                    }
                    else if (hr == "01")
                    {
                        hrsfullday = hrsfullday + "3";
                    }
                    else if (hr == "10")
                    {
                        hrsfullday = hrsfullday + "4";
                    }
                    else if (hr == "11")
                    {
                        hrsfullday = hrsfullday + "1";
                    }

                    hr = string.Empty;
                }

                item.Hours = hrsfullday;


            }

            if (reportsList.Count > 0)
            {
                reportsList[0].TotalNormalHours = totalNormal.ToString();
                reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
                reportsList[0].TotalHours = totalhrs.ToString();
                reportsList[0].TotalRestHours = totalRest.ToString();
            }

            return reportsList;
        }

        public List<ReportsPOCO> GetCrewIDFromWorkSessionsForUser(ReportsPOCO reportsPOCO)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
			double totalNormal = 0;
			double totalOvertime = 0;
			double totalhrs = 0;
			double totalRest = 0;


            reportsList = reportsDAL.GetCrewIDFromWorkSessionsForUser(reportsPOCO);

            foreach (ReportsPOCO item in reportsList)
            {
				double normalWorkingHours = GetNormalWorkingHours(item.WorkDate);
                item.NormalWorkingHours = normalWorkingHours;

                item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
                item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
                item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
                item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
                item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);

                totalNormal += item.NormalWorkingHours;
                totalOvertime += double.Parse(item.OvertimeHours);
                totalhrs += double.Parse(item.TotalWorkedHours);
                totalRest += double.Parse(item.MinTwentyFourHourrest);


                var bookedhrs = item.Hours;
                hrsfullday = string.Empty;



                // now slice into 2, as two make an hour
                //for (int i = 0; i < 48; i+=2)
                //{

                //    string hr = bookedhrs.Substring(i, 2); 

                //    if(hr == "00")
                //    {
                //        hrsfullday = hrsfullday + "0";
                //    }
                //    else if(hr =="01")
                //    {
                //        hrsfullday = hrsfullday + "3";
                //    }
                //    else if (hr == "10")
                //    {
                //        hrsfullday = hrsfullday + "4";
                //    }
                //    else if (hr == "11")
                //    {
                //        hrsfullday = hrsfullday + "1";
                //    }

                //    hr = string.Empty;
                //}

                //item.Hours = hrsfullday;


            }

            reportsList[0].TotalNormalHours = totalNormal.ToString();
            reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
            reportsList[0].TotalHours = totalhrs.ToString();
            reportsList[0].TotalRestHours = totalRest.ToString();

            return reportsList;
        }


        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        public List<ReportsPOCO> GetVarianceFromWorkSessionsForUser(ReportsPOCO reportsPOCO, int pageIndex, ref int recordCount, int length)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
			double totalNormal = 0;
			double totalOvertime = 0;
			double totalhrs = 0;
			double totalRest = 0;
            reportsList = reportsDAL.GetDataForVarianceReportForUser(reportsPOCO, pageIndex, ref recordCount, length);
            if (reportsList.Count > 0)
            {
                foreach (ReportsPOCO item in reportsList)
                {
					double normalWorkingHours = GetNormalWorkingHours(item.WorkDate);
                    item.NormalWorkingHours = normalWorkingHours;

                    item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                    item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                    item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                    item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                    item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
                    item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
                    item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
                    item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                    item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
                    item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);
                    item.FomattedComplianceInfo = GetCompliance(item.ComplianceInfo);

                    totalNormal += item.NormalWorkingHours;
                    totalOvertime += double.Parse(item.OvertimeHours);
                    totalhrs += double.Parse(item.TotalWorkedHours);
                    totalRest += double.Parse(item.MinTwentyFourHourrest);

                    var bookedhrs = item.Hours;
                    hrsfullday = string.Empty;
                }
                reportsList[0].TotalNormalHours = totalNormal.ToString();
                reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
                reportsList[0].TotalHours = totalhrs.ToString();
                reportsList[0].TotalRestHours = totalRest.ToString();
                //compliance
            }

            recordCount = reportsList.Count;

            return reportsList;
        }


        public List<ReportsPOCO> GetVarianceFromWorkSessionsForPdfForUser(ReportsPOCO reportsPOCO, int pageIndex, ref int recordCount, int length)
        {
            ReportsDAL reportsDAL = new ReportsDAL();
            List<ReportsPOCO> reportsList = new List<ReportsPOCO>();
            string hrsfullday = string.Empty;
			double totalNormal = 0;
			double totalOvertime = 0;
			double totalhrs = 0;
			double totalRest = 0;       
            reportsList = reportsDAL.GetDataForVarianceReportForUser(reportsPOCO, pageIndex, ref recordCount, length);
            if (reportsList.Count > 0)
            {
                foreach (ReportsPOCO item in reportsList)
                {
					double normalWorkingHours = GetNormalWorkingHours(item.WorkDate);
                    item.NormalWorkingHours = normalWorkingHours;

                    item.MaxNRRestPeriodStatus = GetMaxNRRestPeriodStatus(item.ComplianceInfo);
                    item.MaxRestPeriodStatus = GetMaxRestPeriodStatus(item.ComplianceInfo);
                    item.SevenDayStatus = GetSevenDayStatus(item.ComplianceInfo);
                    item.TwentFourHourRestHourStatus = GetTwentFourHourRestHourStatus(item.ComplianceInfo);
                    item.MinSevenDayRest = GetMinSevenDayRest(item.ComplianceInfo);
                    item.MinTwentyFourHourrest = GetMinTwentyFourHourrest(item.ComplianceInfo);
                    item.MaxRestPeriodInTwentyFourHours = GetMaxRestPeriodInTwentyFourHours(item.ComplianceInfo);
                    item.MaxNrOfrestPeriod = GetMaxNrOfrestPeriod(item.ComplianceInfo);
                    item.TotalWorkedHours = GetTotalWorkedHours(item.ComplianceInfo);
                    item.OvertimeHours = GetOvertimeHours(item.ComplianceInfo);
                    item.FomattedComplianceInfo = GetComplianceforPdf(item.ComplianceInfo);

                    totalNormal += item.NormalWorkingHours;
                    totalOvertime += double.Parse(item.OvertimeHours);
                    totalhrs += double.Parse(item.TotalWorkedHours);
                    totalRest += double.Parse(item.MinTwentyFourHourrest);

                    var bookedhrs = item.Hours;
                    hrsfullday = string.Empty;
                }
                reportsList[0].TotalNormalHours = totalNormal.ToString();
                reportsList[0].TotalOvertimeHours = totalOvertime.ToString();
                reportsList[0].TotalHours = totalhrs.ToString();
                reportsList[0].TotalRestHours = totalRest.ToString();
                //compliance
            }
            return reportsList;
        }
    }
}
