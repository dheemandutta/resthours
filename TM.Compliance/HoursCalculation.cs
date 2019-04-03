using TM.Compliance;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.Base.Entities;

namespace TM.Compliance
{
    public static class HoursCalculation
    {
        const int TOT_7_DAYS_SESSION = 336;

        #region Obsolete Code

        //public static Compliance24Hrs Check24hrsRestHrs(string[] workHours, RegimesPOCO currentRegime)
        //{
        //    if (workHours == null)
        //    {
        //        throw new ArgumentNullException();
        //    }

        //    if (currentRegime == null)
        //    {
        //        throw new ArgumentNullException();
        //    }

        //    #region local variables
        //    Compliance24Hrs temp24Compliance = new Compliance24Hrs();

        //    int timeBlock = 48;
        //    bool _isValidMinRest10Hrs = true;
        //    bool _isValidMaxRestPeriod = true;
        //    bool _isValidMaxNrOfRestPeriod = true;

        //    double _minRest10Hrs = 0;
        //    double _maxRestPeriod = 0;
        //    int _maxNrOfRestPeriod = 0;

        //    string _strValidMinRest10Hrs = String.Empty;
        //    string _strValidMaxRestPeriod = String.Empty;
        //    string _strValidMaxNrOfRestPeriod = String.Empty;
        //    #endregion local variables

        //    if (workHours.Length <= timeBlock)
        //    {
        //        return Process24HrsCompliance(workHours, currentRegime);
        //    }

        //    #region MultiDaysCheckByParts
        //    #region Only Work Sessions 24hrs back check
        //    List<int> checkSessions = new List<int>();

        //    for (int i = 0; i < workHours.Length; i++)
        //    {
        //        if (workHours[i] == "1")
        //        {
        //            checkSessions.Add(i);
        //        }
        //    }

        //    int[] arrCheckSessions = checkSessions.ToArray<int>();

        //    #endregion Only Work Sessions 24hrs back check

        //    #region OCIMF Check

        //    int checkOnlyWorkSessions = Convert.ToInt32(currentRegime.CheckOnlyWorkHours);
        //    int startIndex = 0;//Array.LastIndexOf(workHours, "1"); // Shift backwards every 30 mins
        //    int endIndex = 0;
        //    if (checkOnlyWorkSessions == 0)// OCIMF check all work sessions
        //    {
        //        startIndex = workHours.Length - 1;//Array.LastIndexOf(workHours, "1"); // Shift backwards every 30 mins
        //        endIndex = timeBlock;
        //    }
        //    else
        //    {
        //        startIndex = arrCheckSessions.Length - 1;//Array.LastIndexOf(workHours, "1"); // Shift backwards every 30 mins
        //        endIndex = arrCheckSessions[0];
        //    }
        //    #endregion OCIMF Check

        //    //for (int i = arrCheckSessions.Length - 1; i >= 0; i--)
        //    for (int i = startIndex; i >= endIndex; i--)
        //    {
        //        string[] tempArray = null;
        //        int tempArrayStartIndex = 0;
        //        int tempArrayEndInIndex = 0;

        //        if (checkOnlyWorkSessions == 0)
        //        {
        //            tempArrayStartIndex = i;
        //            tempArrayEndInIndex = (i - timeBlock) + 1;
        //        }
        //        else
        //        {
        //            tempArrayStartIndex = arrCheckSessions[i];
        //            tempArrayEndInIndex = (arrCheckSessions[i] - timeBlock) + 1;
        //        }
        //        //-----
        //        if (checkOnlyWorkSessions != 0 && tempArrayEndInIndex > arrCheckSessions[0])
        //        {
        //            tempArray = GetShiftedArray(workHours, tempArrayStartIndex, tempArrayEndInIndex);
        //        }
        //        else if (tempArrayEndInIndex > 0)
        //        {
        //            tempArray = GetShiftedArray(workHours, tempArrayStartIndex, tempArrayEndInIndex);
        //        }
        //        //---------------

        //        //if (tempArrayEndInIndex > arrCheckSessions[0])
        //        //{
        //        //    tempArray = GetShiftedArray(workHours, tempArrayStartIndex, tempArrayEndInIndex);

        //        if (tempArray != null && tempArray.Count<string>() > 0)
        //        {
        //            #region check any 24hr Compliance

        //            temp24Compliance = Process24HrsCompliance(tempArray, currentRegime);

        //            if (_isValidMinRest10Hrs)
        //            {
        //                _isValidMinRest10Hrs = temp24Compliance.IsValidTotalRestHours && _isValidMinRest10Hrs;
        //                _strValidMinRest10Hrs = temp24Compliance.TotalRestHoursStatus;
        //                _minRest10Hrs = temp24Compliance.TotalRestHours;
        //            }

        //            if (_isValidMaxRestPeriod)
        //            {
        //                _isValidMaxRestPeriod = temp24Compliance.IsValidMaxRestPeriod && _isValidMaxRestPeriod;
        //                _strValidMaxRestPeriod = temp24Compliance.MaxRestPeriodStatus;
        //                _maxRestPeriod = temp24Compliance.MaxRestPeriod;
        //            }

        //            if (_isValidMaxNrOfRestPeriod)
        //            {
        //                _isValidMaxNrOfRestPeriod = temp24Compliance.IsValidMaxNrOfRestPeriod && _isValidMaxNrOfRestPeriod;
        //                _strValidMaxNrOfRestPeriod = temp24Compliance.MaxNrOfRestPeriodStatus;
        //                _maxNrOfRestPeriod = temp24Compliance.MaxNrOfRestPeriod;
        //            }
        //            #endregion check any 24hr Compliance
        //        }

        //        //}

        //    }
        //    #endregion MultiDaysCheckByParts

        //    temp24Compliance.IsValidTotalRestHours = _isValidMinRest10Hrs;
        //    temp24Compliance.TotalRestHours = _minRest10Hrs;
        //    temp24Compliance.TotalRestHoursStatus = _strValidMinRest10Hrs;
        //    temp24Compliance.IsValidMaxRestPeriod = _isValidMaxRestPeriod;
        //    temp24Compliance.MaxRestPeriod = _maxRestPeriod;
        //    temp24Compliance.MaxRestPeriodStatus = _strValidMaxRestPeriod;
        //    temp24Compliance.IsValidMaxNrOfRestPeriod = _isValidMaxNrOfRestPeriod;
        //    temp24Compliance.MaxNrOfRestPeriod = _maxNrOfRestPeriod;
        //    temp24Compliance.MaxNrOfRestPeriodStatus = _strValidMaxNrOfRestPeriod;
        //    temp24Compliance.IsCompliant = _isValidMinRest10Hrs && _isValidMaxRestPeriod && _isValidMaxNrOfRestPeriod;

        //    return temp24Compliance;
        //}

        //static string[] GetShiftedArray(string[] sourceArray, int startIndex, int endIndex)
        //{
        //    string[] _retArray = new string[48];
        //    int shiftCountrer = 47;
        //    for (int i = startIndex; i >= endIndex; i--)
        //    {
        //        _retArray[shiftCountrer] = sourceArray[i];
        //        shiftCountrer--;
        //    }
        //    return _retArray;
        //}

        #endregion Obsolete Code


        #region Public Methods
        //NEW METHODS:
        //Calculate any 7 days compliance 
        public static Compliance7Days ProcessAny7DaysSession(string[] workSessions, RegimesPOCO currentRegime, bool isFirstSevenDays)
        {
            if (workSessions == null)
            {
                throw new ArgumentNullException();
            }

            if (currentRegime == null)
            {
                throw new ArgumentNullException();
            }

            Compliance7Days temp7DaysCompliance = new Compliance7Days();

            int totalWorkSessions = TotalWorkHours(workSessions);
            temp7DaysCompliance.TotalWorkHours = (double)totalWorkSessions / 2;

            if (isFirstSevenDays)
            {
                temp7DaysCompliance.TotalRestHours = 200.00;
                temp7DaysCompliance.IsCompliant = true;
                temp7DaysCompliance.StatusMessage = ""; // (temp7DaysCompliance.TotalRestSessions / 2) + " hours of rest in 7 days";
                return temp7DaysCompliance;
            }

            if (totalWorkSessions <= (currentRegime.MaxTotalWorkIn7Days * 2))
            {
                temp7DaysCompliance.TotalRestHours = (double)TotalRestHours(workSessions) / 2;
                temp7DaysCompliance.IsCompliant = true;
                temp7DaysCompliance.StatusMessage = ""; // (temp7DaysCompliance.TotalRestSessions / 2) + " hours of rest in 7 days";
                return temp7DaysCompliance;
            }

            temp7DaysCompliance.TotalRestHours = (double)TotalRestHours(workSessions) / 2;
            temp7DaysCompliance.IsCompliant = false;
            temp7DaysCompliance.StatusMessage = "Less than " + (TOT_7_DAYS_SESSION - (currentRegime.MaxTotalWorkIn7Days * 2)) / 2 + " hours of rest in 7 days";
            return temp7DaysCompliance;
        }

        //Calculate Any 24 hrs compliance
        public static Compliance24Hrs ProcessAny24HrsSession(string[] workSession, RegimesPOCO currentRegime, bool isFirstDay)
        {
            const int TIME_BLOCK = 47;
            int startIndex = 0, endIndex = 0;
            Compliance24Hrs temp24Compliance = new Compliance24Hrs();
            Compliance24Hrs _checkTNCComp = new Compliance24Hrs();

            if (workSession == null)
            {
                throw new ArgumentNullException();
            }

            if (currentRegime == null)
            {
                throw new ArgumentNullException();
            }

            //if first day of work session do not calculate any 24 hours. Return 25 hrs as rest period to denote first day.
            /* DISABLING based on discussion with Amitabh Da
            if(isFirstDay)
            {
                temp24Compliance.IsValidTotalRestHours = true;
                temp24Compliance.TotalRestHours = 25;
                temp24Compliance.TotalRestHoursStatus = "";
                temp24Compliance.IsValidMaxRestPeriod = true;
                temp24Compliance.MaxRestPeriod = 25;
                temp24Compliance.MaxRestPeriodStatus = "";
                temp24Compliance.IsValidMaxNrOfRestPeriod = true;
                temp24Compliance.MaxNrOfRestPeriod = 1;
                temp24Compliance.MaxNrOfRestPeriodStatus = "";
                temp24Compliance.IsCompliant = temp24Compliance.IsValidTotalRestHours && temp24Compliance.IsValidMaxRestPeriod && temp24Compliance.IsValidMaxNrOfRestPeriod;
                return temp24Compliance;
            }
            */
            
            bool _isValidMinRest10Hrs = true;
            bool _isValidMaxRestPeriod = true;
            bool _isValidMaxNrOfRestPeriod = true;

            double _minRest10Hrs = 0;
            double _maxRestPeriod = 0;
            int _maxNrOfRestPeriod = 0;

            string _strValidMinRest10Hrs = String.Empty;
            string _strValidMaxRestPeriod = String.Empty;
            string _strValidMaxNrOfRestPeriod = String.Empty;

            if (workSession.Count() <= TIME_BLOCK)////Check if worksession data is only for the 24 hours/48 work sessions
            {
                //string[] tempWorkSession = Utility.TrimLeadingZeros(workSession); // remove leading zeros to start with 1st working session as per rule.
                temp24Compliance =Process24HrsCompliance(workSession, currentRegime, isFirstDay);
                if(isFirstDay)
                {
                    temp24Compliance.MaxRestPeriod = 25.0;
                    temp24Compliance.MaxRestPeriodStatus = string.Empty;
                }
                //
                _checkTNCComp = CheckForTechnicalNC(workSession, currentRegime, isFirstDay);
                temp24Compliance.IsTechnicalNC = _checkTNCComp.IsTechnicalNC;
                temp24Compliance.IsCompliant = temp24Compliance.IsValidTotalRestHours && temp24Compliance.IsValidMaxRestPeriod && temp24Compliance.IsValidMaxNrOfRestPeriod;
                if(!_checkTNCComp.IsCompliant)
                {
                    if (!_checkTNCComp.IsValidTotalRestHours)
                    {
                        temp24Compliance.TotalRestHoursStatus = _checkTNCComp.TotalRestHoursStatus;
                    }
                    else
                    {
                        temp24Compliance.TotalRestHoursStatus = string.Empty;
                    }
                    if (!_checkTNCComp.IsValidMaxRestPeriod)
                    {
                        temp24Compliance.MaxRestPeriodStatus = _checkTNCComp.MaxRestPeriodStatus;
                    }
                    else
                    {
                        temp24Compliance.MaxRestPeriodStatus = string.Empty;
                    }
                    if (!_checkTNCComp.IsValidMaxNrOfRestPeriod)
                    {
                        temp24Compliance.MaxNrOfRestPeriodStatus = _checkTNCComp.MaxNrOfRestPeriodStatus;
                    }
                    else
                    {
                        temp24Compliance.MaxNrOfRestPeriodStatus = string.Empty;
                    }
                }
                //
                if (currentRegime.RegimeName.ToLower() == "ocimf")
                {
                    if (temp24Compliance.IsTechnicalNC)
                    {

                        temp24Compliance.TotalRestHoursStatus = string.IsNullOrEmpty(temp24Compliance.TotalRestHoursStatus) ? string.Empty : temp24Compliance.TotalRestHoursStatus + " (Technical NC)";
                        temp24Compliance.MaxRestPeriodStatus = string.IsNullOrEmpty(temp24Compliance.MaxRestPeriodStatus) ? string.Empty : temp24Compliance.MaxRestPeriodStatus + " (Technical NC)";
                        temp24Compliance.MaxNrOfRestPeriodStatus = string.IsNullOrEmpty(temp24Compliance.MaxNrOfRestPeriodStatus) ? string.Empty : temp24Compliance.MaxNrOfRestPeriodStatus + " (Technical NC)";
                    }
                }
                else
                {
                    if (temp24Compliance.IsTechnicalNC)
                    {

                        temp24Compliance.TotalRestHoursStatus = string.Empty;
                        temp24Compliance.MaxRestPeriodStatus = string.Empty;
                        temp24Compliance.MaxNrOfRestPeriodStatus = string.Empty;
                    }
                }

                return temp24Compliance;
            }
            else
            {
                startIndex = Array.IndexOf(workSession, "1"); // start index of work session ignoring the leading zeros
                int relativeIndex = Array.LastIndexOf(workSession, "1") - 47; // this is relative index based on last working index
                endIndex = relativeIndex > startIndex ? relativeIndex : startIndex; // the end index counter for teh shifted array

            }

            //If the both previous day and current day has full rest and no work
            if (startIndex <= 0 && endIndex <=0)
            {
                temp24Compliance.IsValidTotalRestHours = true;
                temp24Compliance.TotalRestHours = 24;
                temp24Compliance.TotalRestHoursStatus = "";
                temp24Compliance.IsValidMaxRestPeriod = true;
                temp24Compliance.MaxRestPeriod = 24;
                temp24Compliance.MaxRestPeriodStatus = "";
                temp24Compliance.IsValidMaxNrOfRestPeriod = true;
                temp24Compliance.MaxNrOfRestPeriod = 1;
                temp24Compliance.MaxNrOfRestPeriodStatus = "";
                temp24Compliance.IsCompliant = _isValidMinRest10Hrs && _isValidMaxRestPeriod && _isValidMaxNrOfRestPeriod;
                return temp24Compliance;
            }
            else if(startIndex > 47 && startIndex < 95) //If the previous day is full rest and current day has some work sessions
            {
                temp24Compliance = Process24HrsCompliance(getSelectedDayWorkSessionfromTwoDays(1,workSession), currentRegime, isFirstDay);
                //
                _checkTNCComp = CheckForTechnicalNC(workSession, currentRegime, isFirstDay);
                temp24Compliance.IsTechnicalNC = _checkTNCComp.IsTechnicalNC;
                temp24Compliance.IsCompliant = temp24Compliance.IsValidTotalRestHours && temp24Compliance.IsValidMaxRestPeriod && temp24Compliance.IsValidMaxNrOfRestPeriod;
                if (!_checkTNCComp.IsCompliant)
                {
                    if (!_checkTNCComp.IsValidTotalRestHours)
                    {
                        temp24Compliance.TotalRestHoursStatus = _checkTNCComp.TotalRestHoursStatus;
                    }
                    else
                    {
                        temp24Compliance.TotalRestHoursStatus = string.Empty;
                    }
                    if (!_checkTNCComp.IsValidMaxRestPeriod)
                    {
                        temp24Compliance.MaxRestPeriodStatus = _checkTNCComp.MaxRestPeriodStatus;
                    }
                    else
                    {
                        temp24Compliance.MaxRestPeriodStatus = string.Empty;
                    }
                    if(!_checkTNCComp.IsValidMaxNrOfRestPeriod)
                    {
                        temp24Compliance.MaxNrOfRestPeriodStatus = _checkTNCComp.MaxNrOfRestPeriodStatus;
                    }
                    else
                    {
                        temp24Compliance.MaxNrOfRestPeriodStatus = string.Empty;
                    }
                }
                //
                temp24Compliance.IsCompliant = temp24Compliance.IsValidTotalRestHours && temp24Compliance.IsValidMaxRestPeriod && temp24Compliance.IsValidMaxNrOfRestPeriod;
                if (currentRegime.RegimeName.ToLower() == "ocimf")
                {
                    if (temp24Compliance.IsTechnicalNC)
                    {

                        temp24Compliance.TotalRestHoursStatus = string.IsNullOrEmpty(temp24Compliance.TotalRestHoursStatus) ? string.Empty : temp24Compliance.TotalRestHoursStatus + " (Technical NC)";
                        temp24Compliance.MaxRestPeriodStatus = string.IsNullOrEmpty(temp24Compliance.MaxRestPeriodStatus) ? string.Empty : temp24Compliance.MaxRestPeriodStatus + " (Technical NC)";
                        temp24Compliance.MaxNrOfRestPeriodStatus = string.IsNullOrEmpty(temp24Compliance.MaxNrOfRestPeriodStatus) ? string.Empty : temp24Compliance.MaxNrOfRestPeriodStatus + " (Technical NC)";
                    }
                }
                else
                {
                    if (temp24Compliance.IsTechnicalNC)
                    {

                        temp24Compliance.TotalRestHoursStatus = string.Empty;
                        temp24Compliance.MaxRestPeriodStatus = string.Empty;
                        temp24Compliance.MaxNrOfRestPeriodStatus = string.Empty;
                    }
                }

                return temp24Compliance;
            }

            bool _isDirtyMinRest10Hrs = false;
            bool _isDirtyMaxRestPeriod = false;
            //Start parsing shifting array e.g. if the start index starts at 4 and end index id as 64
            //the parsing would start in a block of 48 items/worksessions with index starting at 4 and ending at 4+47 = 51
            //then shifting 1 place starting at 5 and ending at 5+47 = 52 and so on till the end index is greater than calculated end index
            for (int startCounter = startIndex;  startCounter <= endIndex;  startCounter++)
            {
                string[] temp48WorkSession = new string[48];
                for (int iCounter = 0; iCounter <= TIME_BLOCK; iCounter++)
                {
                    temp48WorkSession[iCounter] = workSession[iCounter + startCounter];
                }
                //Validate24HrsCompliance(Utility.TrimLeadingZeros(temp48WorkSession));
                temp24Compliance = Process24HrsCompliance(Utility.TrimLeadingZeros(temp48WorkSession), currentRegime, isFirstDay);

               if (_isValidMinRest10Hrs)
                {
                    _isValidMinRest10Hrs = temp24Compliance.IsValidTotalRestHours && _isValidMinRest10Hrs;
                    _strValidMinRest10Hrs = temp24Compliance.TotalRestHoursStatus;
                    if (!_isDirtyMinRest10Hrs)
                    {
                        _minRest10Hrs = temp24Compliance.TotalRestHours;
                        _isDirtyMinRest10Hrs = true;
                    }
                    else
                    {
                        _minRest10Hrs = _minRest10Hrs < temp24Compliance.TotalRestHours ? _minRest10Hrs : temp24Compliance.TotalRestHours;
                    }
                }
                else
                {
                    _minRest10Hrs = _minRest10Hrs < temp24Compliance.TotalRestHours ? _minRest10Hrs : temp24Compliance.TotalRestHours;
                }

                if (_isValidMaxRestPeriod)
                {
                    _isValidMaxRestPeriod = temp24Compliance.IsValidMaxRestPeriod && _isValidMaxRestPeriod;
                    _strValidMaxRestPeriod = temp24Compliance.MaxRestPeriodStatus;
                    _maxRestPeriod = temp24Compliance.MaxRestPeriod;
                }
                else
                {
                    _maxRestPeriod = _maxRestPeriod < temp24Compliance.MaxRestPeriod ? _maxRestPeriod : temp24Compliance.MaxRestPeriod;
                }

                if (_isValidMaxNrOfRestPeriod)
                {
                    _isValidMaxNrOfRestPeriod = temp24Compliance.IsValidMaxNrOfRestPeriod && _isValidMaxNrOfRestPeriod;
                    _strValidMaxNrOfRestPeriod = temp24Compliance.MaxNrOfRestPeriodStatus;
                    _maxNrOfRestPeriod = temp24Compliance.MaxNrOfRestPeriod;
                }

            }

            //// REMOVE to allow any 24hrs checking for number of rest periods and maximum rest period
            //string[] currentDayWorkSession = Utility.GetSessionsFromLastDay(1, workSession);
            //temp24Compliance = Process24HrsCompliance(Utility.TrimLeadingZerosNonAdjusted(currentDayWorkSession), currentRegime);
            //// REMOVE till here
            //
            _checkTNCComp = CheckForTechnicalNC(workSession, currentRegime, isFirstDay);
            temp24Compliance.IsTechnicalNC = _checkTNCComp.IsTechnicalNC;
            temp24Compliance.IsCompliant = temp24Compliance.IsValidTotalRestHours && temp24Compliance.IsValidMaxRestPeriod && temp24Compliance.IsValidMaxNrOfRestPeriod;
            if (!_checkTNCComp.IsCompliant)
            {
                if (!_checkTNCComp.IsValidTotalRestHours)
                {
                    temp24Compliance.TotalRestHoursStatus = _checkTNCComp.TotalRestHoursStatus;
                }
                else
                {
                    temp24Compliance.TotalRestHoursStatus = string.Empty;
                }
                if (!_checkTNCComp.IsValidMaxRestPeriod)
                {
                    temp24Compliance.MaxRestPeriodStatus = _checkTNCComp.MaxRestPeriodStatus;
                }
                else
                {
                    temp24Compliance.MaxRestPeriodStatus = string.Empty;
                }
                if (!_checkTNCComp.IsValidMaxNrOfRestPeriod)
                {
                    temp24Compliance.MaxNrOfRestPeriodStatus = _checkTNCComp.MaxNrOfRestPeriodStatus;
                }
                else
                {
                    temp24Compliance.MaxNrOfRestPeriodStatus = string.Empty;
                }
            }
            //
            temp24Compliance.IsValidTotalRestHours = _isValidMinRest10Hrs;
            temp24Compliance.TotalRestHours = _minRest10Hrs;
            temp24Compliance.TotalRestHoursStatus = _strValidMinRest10Hrs;
            temp24Compliance.IsValidMaxRestPeriod = _isValidMaxRestPeriod;
            temp24Compliance.MaxRestPeriod = _maxRestPeriod;
            temp24Compliance.MaxRestPeriodStatus = _strValidMaxRestPeriod;
            temp24Compliance.IsValidMaxNrOfRestPeriod = _isValidMaxNrOfRestPeriod;
            temp24Compliance.MaxNrOfRestPeriod = _maxNrOfRestPeriod;
            temp24Compliance.MaxNrOfRestPeriodStatus = _strValidMaxNrOfRestPeriod;
            temp24Compliance.IsCompliant = _isValidMinRest10Hrs && _isValidMaxRestPeriod && _isValidMaxNrOfRestPeriod;
            if (currentRegime.RegimeName.ToLower() == "ocimf")
            {
                if(temp24Compliance.IsTechnicalNC)
                {

                    temp24Compliance.TotalRestHoursStatus = string.IsNullOrEmpty(temp24Compliance.TotalRestHoursStatus) ? string.Empty : temp24Compliance.TotalRestHoursStatus + " (Technical NC)";
                    temp24Compliance.MaxRestPeriodStatus = string.IsNullOrEmpty(temp24Compliance.MaxRestPeriodStatus)? string.Empty : temp24Compliance.MaxRestPeriodStatus + " (Technical NC)";
                    temp24Compliance.MaxNrOfRestPeriodStatus = string.IsNullOrEmpty(temp24Compliance.MaxNrOfRestPeriodStatus)? string.Empty : temp24Compliance.MaxNrOfRestPeriodStatus + " (Technical NC)";
                }
            }
            else
            {
                if (temp24Compliance.IsTechnicalNC)
                {

                    temp24Compliance.TotalRestHoursStatus = string.Empty;
                    temp24Compliance.MaxRestPeriodStatus = string.Empty;
                    temp24Compliance.MaxNrOfRestPeriodStatus = string.Empty;
                }
            }
            
            

            //// REMOVE to allow any 24hrs checking for number of rest periods and maximum rest period
            //temp24Compliance.IsCompliant = _isValidMinRest10Hrs && temp24Compliance.IsValidMaxRestPeriod && temp24Compliance.IsValidMaxNrOfRestPeriod;
            //// REMOVE till here
            
            return temp24Compliance;

        }

        

        public static  ComplianceInfo GetComplianceInfo(string[] last48HrsSessions, string[] last7daysSessions, DateTime currentDate, RegimesPOCO currentRegime,bool isFirstWorkingDay, bool isFirstSevenDays)
        {

            Compliance24Hrs comp24hrs = ProcessAny24HrsSession(last48HrsSessions, currentRegime, isFirstWorkingDay); ;
            Compliance7Days comp7days = ProcessAny7DaysSession(last7daysSessions, currentRegime, isFirstSevenDays); ;
            ComplianceInfo compInfo;
            if (currentRegime.RegimeName.ToLower() == "ocimf")
            {
                compInfo = new ComplianceInfo
                {
                    ComplianceDate = currentDate,
                    IsCompliant = comp7days.IsCompliant && (comp24hrs.IsTechnicalNC || comp24hrs.IsCompliant),
                    IsTechnicalNC = comp24hrs.IsTechnicalNC,
                    PaintOrange = comp24hrs.IsTechnicalNC && comp24hrs.IsCompliant ? false : true,
                    Is24HoursCompliant = comp24hrs.IsCompliant,
                    IsSevenDaysCompliant = comp7days.IsCompliant,
                    TwentyFourHourCompliance = comp24hrs,
                    SevenDaysCompliance = comp7days
                };
                //Remove TNC status msg in case of 7 days NC already present
                if (!comp7days.IsCompliant && comp24hrs.IsTechnicalNC)
                {
                    compInfo.TwentyFourHourCompliance.MaxNrOfRestPeriodStatus = string.Empty;
                    compInfo.TwentyFourHourCompliance.MaxRestPeriodStatus = string.Empty;
                    compInfo.TwentyFourHourCompliance.TotalRestHoursStatus = string.Empty;
                    compInfo.PaintOrange = false;
                }
            }
            else
            {
                compInfo = new ComplianceInfo
                {
                    ComplianceDate = currentDate,
                    IsCompliant = comp7days.IsCompliant && (comp24hrs.IsTechnicalNC || comp24hrs.IsCompliant),
                    IsTechnicalNC = comp24hrs.IsTechnicalNC,
                    PaintOrange = false,
                    Is24HoursCompliant = comp24hrs.IsCompliant,
                    IsSevenDaysCompliant = comp7days.IsCompliant,
                    TwentyFourHourCompliance = comp24hrs,
                    SevenDaysCompliance = comp7days
                };
            }

            return compInfo;
        }

        #endregion Public Methods

        #region Private Methods

        // Split work session in to days from 2 days work sessions. The day parameter takes 0 for previous day and 1 for the current day
        private static string[] getSelectedDayWorkSessionfromTwoDays(int day, string[] workSessions)
        {
            if(day < 0 || day >1) // return null if day is not 0 which is previous day or 1 which is current day
            {
                return null;
            }

            if(workSessions.Count() < 96) // if there is not 96 elements in the work session return null
            {
                return null;
            }

            int startIndex = day > 0 ? 48 : 0;
            int endIndex = day > 0 ? 96 : 48;
            string[] tempArray = new string[48];
            int tempArrayCntr = 0;
            for (int iCntr = startIndex; iCntr < endIndex; iCntr++)
            {
                
                tempArray[tempArrayCntr] = workSessions[iCntr];
                tempArrayCntr++;
            }
            return tempArray;
        }

        private static Compliance24Hrs Process24HrsCompliance(string[] workSessions, RegimesPOCO currentRegime, bool isFirstDay)
        {
            Compliance24Hrs temp24Compliance = new Compliance24Hrs
            {
                IsCompliant = true,
                IsValidTotalRestHours = true,
                IsValidMaxRestPeriod = true,
                IsValidMaxNrOfRestPeriod = true
            };

            int wrkSessions;
            int restSessions;
            int nrOfRestPeriod;
            double maxRestPeriod;
            List<int> restPeriods;

            Check24hrsMinRestPeriod(workSessions, isFirstDay, out wrkSessions, out restSessions, out nrOfRestPeriod, out maxRestPeriod, out restPeriods);

            double restHours = (double)(48 - wrkSessions) / 2; //(double)restSessions / 2;
            temp24Compliance.TotalRestHours = restHours;
            if (restHours < currentRegime.MinTotalRestIn24Hours)
            {

                temp24Compliance.IsValidTotalRestHours = false;
                temp24Compliance.TotalRestHoursStatus = "Less than 10 hrs of rest in 24 hrs period";
            }


            //if (!Utility.CheckConsecutiveMinRestPeriod(restPeriods, (int)currentRegime.MinContRestIn24Hours))

            if (restPeriods.Count <=0 ||  (double)restPeriods.Max() / 2 < 6)
            {

                temp24Compliance.IsValidMaxRestPeriod = false;
                temp24Compliance.MaxRestPeriodStatus = "No minimum 6 hrs rest period";
            }
            temp24Compliance.MaxRestPeriod = maxRestPeriod;


            temp24Compliance.MaxNrOfRestPeriod = nrOfRestPeriod;

            if (nrOfRestPeriod > 2)
            {

                temp24Compliance.IsValidMaxNrOfRestPeriod = false;
                temp24Compliance.MaxNrOfRestPeriodStatus = "Maximum number of rest period is more than 2";
            }

            temp24Compliance.IsCompliant = temp24Compliance.IsValidTotalRestHours && temp24Compliance.IsValidMaxRestPeriod && temp24Compliance.IsValidMaxNrOfRestPeriod;

            return temp24Compliance;
        }

        private static void Check24hrsMinRestPeriod(string[] workHours, bool isFirstDay, out int workSessions, out int restSessions, out int numberOfRestPeriod, out double maxRestPeriod, out List<int> restPeriods)
        {
            if (workHours == null)
            {
                throw new ArgumentNullException();
            }

            List<int> tempSessions = new List<int>();

            workSessions = 0;
            restSessions = 0;

            restPeriods = new List<int>();

            int restSessionCountrer = 0;
            int workSessionCounter = 0;
            for (int i = 0; i < workHours.Length; i++)
            {
                if (workHours[i] == "0")
                {
                    restSessionCountrer++;
                    if (i < workHours.Length - 1)
                    {
                        continue;
                    }
                }
                if (restSessionCountrer > 0)
                {
                    restPeriods.Add(restSessionCountrer);
                    restSessionCountrer = 0;
                }
                if (workHours[i] == "1")
                {
                    workSessionCounter++;
                }
            }


            workSessions = workSessionCounter;
            restSessions = restPeriods.Sum();

            if (isFirstDay)// If first day of booking or previous day is not booked then remove the rest period at the top
            {
                int addAtTop = 1;
                //int arraySize = 0; ;
                if (workHours[0] == "0")
                {
                    //restPeriods.RemoveAt(0);
                    addAtTop = 0;
                }

                if (restPeriods.Count > 1)
                {
                    int arraySize = restPeriods.Count - addAtTop;

                    int[] firstDayRestPeriods = new int[arraySize];
                    int interCounter = 0;
                    for (int i = 0; i < firstDayRestPeriods.Length; i++)
                    {
                        firstDayRestPeriods[interCounter] = i == 0 ? 24 : restPeriods[i];
                        interCounter++;
                    }
                    restPeriods = firstDayRestPeriods.ToList<int>();
                }
            }


            numberOfRestPeriod = GetNumberOfRestPeriod(restPeriods);
            maxRestPeriod = restPeriods.Count() > 0 ? (double)restPeriods.Max() / 2 : 0;
        }

        private static int GetNumberOfRestPeriod(List<int> restPeriods)
        {
            /* Minimum 10 hrs of rest should not be broken into more than 2 periods. If more than 10 hrs of rest is taken then 
             1) the minumum 10 hrs of rest should be made up to two periods
             2) The periods which are over minimum 10 hrs will not count towards NC
             3) The leading zero sessions will be considered as well*/
            int _returnValue = 0;
            int _maxRestPeriod = restPeriods.Count>0? restPeriods.Max():0 ;
            //ToDo: Fix 2nd highest
            List<int> _tempArray = (from number in restPeriods
                                    orderby number descending
                                    select number).Distinct().ToList<int>();
            int _secondHighestRestPeriod = 0;
            if (_tempArray.Count() == 1)
            {
                if (restPeriods.Count() == 1)
                {
                    _secondHighestRestPeriod = 0;//_tempArrey[0];//if restperiod is of only one 
                }
                else
                {
                    _secondHighestRestPeriod = _tempArray[0];//All the restperiods are of similar length
                }

            }
            if (_tempArray.Count() > 1)
            {
                _secondHighestRestPeriod = _tempArray.Skip(1).First();//Get the 2nd highest in case of more than one element

            }
            //int _secondHighestRestPeriod = restPeriods.Count() > 1 ? (from number in restPeriods
            //                                                          orderby number descending
            //                                                          select number).Distinct().Skip(1).First() : 0;

            if ((_maxRestPeriod + _secondHighestRestPeriod) >= 20)
            {
                _returnValue = 2;
            }
            else
            {
                _returnValue = restPeriods.Count;
            }

            return _returnValue;


            //throw new NotImplementedException();
        }

        private static int TotalRestHours(string[] workSessions)
        {
            if (workSessions == null)
            {
                throw new ArgumentNullException();
            }

            int _restHours = 0;
            for (int i = 0; i < workSessions.Length; i++)
            {
                if (workSessions[i] == "0")
                {
                    _restHours += 1;
                }
            }
            return _restHours;
        }

        private static int TotalWorkHours(string[] workSessions)
        {
            if (workSessions == null)
            {
                throw new ArgumentNullException();
            }

            int _workHours = 0;
            for (int i = 0; i < workSessions.Length; i++)
            {
                if (workSessions[i] == "1")
                {
                    _workHours += 1;
                }
            }
            return _workHours;
        }

        private static Compliance24Hrs CheckForTechnicalNC(string[] workSessions, RegimesPOCO currentRegime, bool isFirstDay)
        {

            int previousDaysTrailingRestSessions = GetTrailingRestHoursForSelectedDay(workSessions);
            string[] previousDaysRestSessions = new string[previousDaysTrailingRestSessions];
            Array.Clear(previousDaysRestSessions, 0, previousDaysTrailingRestSessions);
            previousDaysRestSessions = Utility.InitializeZeroStringArray(previousDaysRestSessions);
            string[] currentDayWorkSessions = GetWorkSessionsForSelectedDay(workSessions, 2);

            

            string[] workSessionsToBeChecked = Utility.AppendToArray<string>(previousDaysRestSessions, currentDayWorkSessions);

            Compliance24Hrs compliance24HrsTNC = Process24HrsCompliance(workSessionsToBeChecked, currentRegime, isFirstDay);
            compliance24HrsTNC.IsTechnicalNC = compliance24HrsTNC.IsCompliant;

            return compliance24HrsTNC;
        }

        private static string[] GetWorkSessionsForSelectedDay(string[] workSessions, int selectedDay)
        {
            string[] selectedDayWorkSessions = new string[48];
            int _startindex = 0;
            int _endindex = 0;

            switch (selectedDay)
            {
                case 1:
                    _startindex = 0;
                    _endindex = 47;
                    break;
                case 2:
                    _startindex = 48;
                    _endindex = 95;
                    break;
                default:
                    break;
            }

            int _innerCounter = 0;
            for (int i = _startindex; i <= _endindex; i++)
            {
                
                selectedDayWorkSessions[_innerCounter] = workSessions[i];
                _innerCounter++;
            }

            return selectedDayWorkSessions;
        }

        private static int GetTrailingRestHoursForSelectedDay(string[] workSessions)
        {
            string[] previousDaysWorkSessions = GetWorkSessionsForSelectedDay(workSessions, 1);

            int _lastIndexofWorkSession = Array.LastIndexOf(previousDaysWorkSessions, "1");
            int _restSessions = 47 - _lastIndexofWorkSession;

            return _restSessions;
        }



        #endregion Private Methods


    }

    
}
