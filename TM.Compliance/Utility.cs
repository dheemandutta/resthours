using TM.Compliance;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using TM.Base.Entities;

namespace TM.Compliance
{
    public static class Utility
    {
        const int TOT_7_DAYS_SESSION = 336;
        const int TOT_8_DAYS_SESSION = 384;
        const int SESSION_BLOCK = 48;

        public static string[] CreateWorkSchedule(DateTime startDate, DateTime endDate)
        {
            int numberOfDays = (int)(endDate - startDate).TotalDays;
            Console.WriteLine(numberOfDays);
            string[] workHours = new string[numberOfDays * 48];
            //int setValue = 12;
            //bool boolValue = true;
            //int c = 0;
            //for (int i = 0; i < workHours.Length-1; i++)
            //{

            //    workHours.(i, boolValue);
            //    c++;
            //    if(c == setValue)
            //    {
            //        boolValue = !boolValue;
            //        c = 0;
            //    }


            //}
            return workHours;

        }

        public static string[] TrimTrailingNulls(string[] sourceArray)
        {

            int startIndex = 0;
            int lastIndex = Array.IndexOf(sourceArray, null) - 1;
            if (lastIndex > 0)
            {
                string[] _returnCleanArray = new string[(lastIndex - startIndex) + 1];
                int _internalCtr = 0;
                for (int i = startIndex; i < lastIndex + 1; i++)
                {
                    _returnCleanArray[_internalCtr] = sourceArray[i];
                    _internalCtr++;
                }

                return _returnCleanArray;
            }
            return sourceArray;
        }

        public static string[] TrimTrailingZeros(string[] sourceArray)
        {

            int startIndex = 0;
            int lastIndex = Array.LastIndexOf(sourceArray, "1") - 1;
            if (lastIndex > 0)
            {
                string[] _returnCleanArray = new string[(lastIndex - startIndex) + 1];
                int _internalCtr = 0;
                for (int i = startIndex; i < lastIndex + 1; i++)
                {
                    _returnCleanArray[_internalCtr] = sourceArray[i];
                    _internalCtr++;
                }

                return _returnCleanArray;
            }
            return sourceArray;
        }

        public static string[] TrimLeadingZeros(string[] sourceArray)
        {

            
            int lastIndex = Array.IndexOf(sourceArray, "1");

            if (lastIndex > 0 && lastIndex != sourceArray.Length)
            {
                string[] _returnCleanArray = new string[(sourceArray.Length - lastIndex)];
                int _internalCtr = 0;
                for (int i = lastIndex; i < sourceArray.Length; i++)
                {
                    _returnCleanArray[_internalCtr] = sourceArray[i];
                    _internalCtr++;
                }

                return AdjustForFirstDay(_returnCleanArray);
            }
            return sourceArray;
        }

        public static string[] TrimLeadingZerosNonAdjusted(string[] sourceArray)
        {


            int lastIndex = Array.IndexOf(sourceArray, "1");

            if (lastIndex > 0 && lastIndex != sourceArray.Length)
            {
                string[] _returnCleanArray = new string[(sourceArray.Length - lastIndex)];
                int _internalCtr = 0;
                for (int i = lastIndex; i < sourceArray.Length; i++)
                {
                    _returnCleanArray[_internalCtr] = sourceArray[i];
                    _internalCtr++;
                }

                return _returnCleanArray;
            }
            return sourceArray;
        }

        public static string[] AdjustForFirstDay(string[] sourceArray)
        {
            string[] _retunArray = new string[48];
            if(sourceArray.Length <= 48 && sourceArray.Length!=0)
            {
                int lastIndexOfFill = 48 - sourceArray.Length;
                for (int i = 0; i < lastIndexOfFill; i++)
                {
                    _retunArray[i] = "0";
                }
                for (int i = 0; i < sourceArray.Length; i++)
                {
                    _retunArray[i + lastIndexOfFill] = sourceArray[i]; 
                }
                return _retunArray;
            }

            return sourceArray;
        }


        public static string[] TrimLeadingnTrailingZeros(string[] sourceArray)
        {

            int startIndex = Array.IndexOf(sourceArray, "l") < 0 ? 0 : Array.IndexOf(sourceArray, "l");
            int lastIndex = Array.LastIndexOf(sourceArray, "1") < 0 ? sourceArray.Count() - 1 : Array.LastIndexOf(sourceArray, "1");
            if (lastIndex > 0)
            {
                string[] _returnCleanArray = new string[(lastIndex - startIndex) + 1];
                int _internalCtr = 0;
                for (int i = startIndex; i < lastIndex + 1; i++)
                {
                    _returnCleanArray[_internalCtr] = sourceArray[i];
                    _internalCtr++;
                }

                return _returnCleanArray;
            }
            return sourceArray;
        }

        public static string[] GetLast7DaysSession(int crewID, DateTime currentDate)
        {

            DateTime startDate = currentDate.AddDays(-7);
            string[] strSessions = TrimTrailingNulls(GetSessionsFromDB(crewID, startDate, currentDate));
            return strSessions;

        }

        static string[] GetAny7DaysSession(string[] workSessions)
        {
            if (workSessions == null)
            {
                throw new ArgumentNullException();
            }

            if (workSessions.Length <= TOT_7_DAYS_SESSION)
            {
                return workSessions;
            }

            string[] _returnArray = new string[TOT_7_DAYS_SESSION];
            int diffCounter = TOT_8_DAYS_SESSION - workSessions.Length;
            int sourceStartIndex = workSessions.Length - TOT_7_DAYS_SESSION;//(SESSION_BLOCK - diffCounter);
            int destStartIndex = 0;
            for (int i = sourceStartIndex; i < workSessions.Length; i++)
            {
                _returnArray[destStartIndex] = workSessions[i];
                destStartIndex++;
            }

            return _returnArray;
        }

        public static string[] GetSessionsFromLastDay(int nrOfDays, string[] sessions)
        {
            if (sessions == null)
            {
                throw new ArgumentNullException();
            }

            int _reqSessionLength = (48 * nrOfDays);

            string[] _tempArray;
            if (sessions.Length > _reqSessionLength)
            {
                _tempArray = new string[_reqSessionLength];
                int _tempArrayIdx = 0;
                int _startIndex = (sessions.Length - _reqSessionLength);
                for (int i = _startIndex; i < sessions.Length; i++)
                {
                    _tempArray[_tempArrayIdx] = sessions[i];
                    _tempArrayIdx++;
                }
            }
            else
            {
                _tempArray = sessions;
            }
            return _tempArray;

        }

        public static bool CheckConsecutiveMinRestPeriod(List<int> restPeriods, int minRestHour)
        {
            bool _isValidConsMinRestHours = false;
            if (restPeriods.Count > 2)
            {
                for (int i = 0; i < restPeriods.Count - 1; i++)
                {
                    if ((restPeriods[i]) / 2 >= minRestHour)
                    {
                        _isValidConsMinRestHours = (restPeriods[i] >= restPeriods[i + 1]);//restPeriods[i] == restPeriods[i + 1];
                    }
                }
            }

            if (restPeriods.Count == 2)
            {
                _isValidConsMinRestHours = (restPeriods.Max() / 2) >= minRestHour;
            }
            if (restPeriods.Count == 1)
            {
                _isValidConsMinRestHours = (restPeriods[0] / 2) >= minRestHour;
            }

            return _isValidConsMinRestHours;
        }

        static string[] GetSessionsFromDB(int crewID, DateTime startDate, DateTime endDate)
        {
            SqlConnection sqlCon;
            SqlDataReader sqlDataReader;

            string[] newArray = null;
            int numberOfDays = (int)(endDate - startDate).TotalDays + 1;


            int id;
            sqlCon = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);//new SqlConnection(Properties.Settings.Default.connectionString);
            sqlCon.Open();

            id = crewID;
            StringBuilder sqlString = new StringBuilder("Select [Hours],[ValidOn] from[AlteredSessions] where CrewId = " + id);
            sqlString.Append(" AND ");
            sqlString.Append(" ValidOn BETWEEN '" + startDate + "' AND '" + endDate + "'");

            sqlDataReader = new SqlCommand(sqlString.ToString(), sqlCon).ExecuteReader();
            int i = 0;
            string[] fullStrArray = new string[numberOfDays * 48];
            List<string> validDates = new List<string>();
            if (sqlDataReader.HasRows)
            {
                while (sqlDataReader.Read())
                {

                    //Console.WriteLine("Date: {0}", sqlDataReader.GetDateTime(1).ToShortDateString());
                    //Console.WriteLine("WorkHours: {0}", sqlDataReader.GetString(0));
                    validDates.Add(sqlDataReader.GetDateTime(1).ToShortDateString());
                    string[] tempStr = sqlDataReader.GetString(0).Select(c => c.ToString()).ToArray();

                    Array.Copy(tempStr, 0, fullStrArray, i, 48);
                    i += 48;

                }
                if (validDates.Last<string>() != endDate.ToShortDateString())
                {
                    throw new Exception("No datafound for current date: " + endDate.ToShortDateString());
                }


                if (fullStrArray[48] == null)
                {
                    newArray = fullStrArray.RemoveAt<string>(48, fullStrArray.Length - 48); ;
                }
                else
                {
                    newArray = fullStrArray;
                }
            }

            else
            {
                Console.WriteLine("No rows found.");
            }
            sqlDataReader.Close();


            return newArray;
        }

        public static RegimesPOCO GetRegimeById(int regimeId/*, int VesselId*/)
        {

            
                Regime _returnRegime1 = new Regime();
               
                SqlDataReader sqlDataReader;

                RegimesPOCO _returnRegime = new RegimesPOCO();
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("stpGetRegimeById", con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@RegimeId", regimeId);
					   // cmd.Parameters.AddWithValue("@VesselID", VesselId);
                        con.Open();

                        sqlDataReader = cmd.ExecuteReader();

                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {

                                _returnRegime.ID = sqlDataReader.GetInt32(0);
                                _returnRegime.RegimeName = sqlDataReader.GetString(1);
                                _returnRegime.MinTotalRestIn7Days = Convert.ToSingle(sqlDataReader.GetDouble(2));
                                _returnRegime.MaxTotalWorkIn24Hours = Convert.ToSingle(sqlDataReader.GetDouble(3));
                                _returnRegime.MinContRestIn24Hours = Convert.ToSingle(sqlDataReader.GetDouble(4));
                                _returnRegime.MinTotalRestIn24Hours = Convert.ToSingle(sqlDataReader.GetDouble(5));
                                _returnRegime.MaxTotalWorkIn7Days = Convert.ToSingle(sqlDataReader.GetDouble(6));
                                _returnRegime.OPA90 = sqlDataReader.GetBoolean(7);
                                _returnRegime.CheckOnlyWorkHours = sqlDataReader.GetBoolean(11);
                            }

                          
                        }

                        con.Close();


                    }
                }
                return _returnRegime;
            
        }

        public static T[] RemoveAt<T>(this T[] array, int startIndex, int length)
        {
            if (array == null)
                throw new ArgumentNullException("array");

            if (length < 0)
            {
                startIndex += 1 + length;
                length = -length;
            }

            if (startIndex < 0)
                throw new ArgumentOutOfRangeException("startIndex");
            if (startIndex + length > array.Length)
                throw new ArgumentOutOfRangeException("length");

            T[] newArray = new T[array.Length - length];

            Array.Copy(array, 0, newArray, 0, startIndex);
            Array.Copy(array, startIndex + length, newArray, startIndex, array.Length - startIndex - length);

            return newArray;
        }

        public static T[] AppendToArray<T>(T[] arrayToResize, T[] elementsArray)
        {
            int arrayLength = arrayToResize.Length + elementsArray.Length;
            T[] resizedArray = new T[arrayLength];

            for (int i = 0; i < arrayToResize.Length; i++)
            {
                resizedArray[i] = arrayToResize[i];
            }

            int counter = 0;
            for (int i = arrayToResize.Length; i < arrayLength; i++)
            {
                resizedArray[i] = elementsArray[counter];
                counter++;
            }

            return resizedArray;
        }

        public static string[] InitializeZeroStringArray(string[] arrayObj)
        {
            for (int i = 0; i < arrayObj.Length; i++)
            {
                arrayObj[i] = "0";
            }

            return arrayObj;
        }
    }
}
