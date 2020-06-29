using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class CrewBL
    {
        public int SaveCrew(CrewPOCO crew, int VesselID)
        {
            CrewDAL crewDAL = new CrewDAL();
            return crewDAL.SaveCrew(crew, VesselID);
        }

        //for Ranks drp
        public List<CrewPOCO> GetAllRanksForDrp(int VesselID)
        {
            CrewDAL crew = new CrewDAL();
            return crew.GetAllRanksForDrp(VesselID);
        }

        public CrewPOCO GetCrewByID(int ID)
        {
            CrewDAL crewDAL = new CrewDAL();
            return crewDAL.GetCrewByID(ID);
        }

        public List<CrewPOCO> GetCrewPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {
            CrewDAL crew = new CrewDAL();
            return crew.GetCrewPageWise(pageIndex, ref recordCount, length, VesselID);
        }

        public List<CrewTemperaturePOCO> GetCrewTemperaturePageWiseByCrewID(int pageIndex, ref int recordCount, int length, int crewID)
        {
            CrewDAL crew = new CrewDAL();
            return crew.GetCrewTemperaturePageWiseByCrewID(pageIndex, ref recordCount, length, crewID);
        }


        public List<CrewPOCO> GetCrewForInactivPageWise(int pageIndex, ref int recordCount, int length, int VesselID)
        {
            CrewDAL crew = new CrewDAL();
            return crew.GetCrewForInactivPageWise(pageIndex, ref recordCount, length, VesselID);
        }


        public int[] AddCrewTimeSheet(CrewTimesheetPOCO timesheetjsondata, int VesselID)
        {
            CrewDAL crewDAL = new CrewDAL();
            return crewDAL.AddCrewTimeSheet(timesheetjsondata, VesselID);
        }

        public CrewPOCO GetAllCrewByCrewID(int ID, int VesselID)
        {
            CrewDAL crewDAL = new CrewDAL();
            return crewDAL.GetAllCrewByCrewID(ID, VesselID).FirstOrDefault();
        }

        public CrewTimesheetPOCO GetLastSevenDaysWorkSchedule(int CrewId, DateTime bookDate, int VesselID, int[] todaybookedHours)
        {
            List<CrewTimesheetPOCO> crewtimesheetList = new List<CrewTimesheetPOCO>();
            CrewDAL crewDAL = new CrewDAL();
            bool isAllZero = true;
            //check if todays array is empty 
            // this indiactes if I am saving or updating vs loading data.
            for (int i = 0; i < todaybookedHours.Length; i++)
            {
                if (todaybookedHours[i] == 1)
                {
                    isAllZero = false;
                    break;
                }
            }

            if (isAllZero)
                crewtimesheetList = crewDAL.GetLastSevenDaysWorkSchedule(CrewId, bookDate, VesselID, 7);
            else
                crewtimesheetList = crewDAL.GetLastSevenDaysWorkSchedule(CrewId, bookDate, VesselID, 6);

            CrewTimesheetPOCO last7daysbookedHours = new CrewTimesheetPOCO();
            int index = 0;
            int nullindex = 0;
            bool isAllZeros = true;
            int[] arr = new int[] { 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 };



            //CASE 1 : NO DATA
            if (crewtimesheetList.Count == 0)
            {

                //insert  current day on top
                for (int i = 0; i < 48; i++)
                {
                    last7daysbookedHours.last7DaysBookedHoursReversed[i] = todaybookedHours[i].ToString();
                    //last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[i] = todaybookedHours[i].ToString();
                }

                for (int i = 48; i < 336; i++)
                {
                    last7daysbookedHours.last7DaysBookedHoursReversed[i] = null;
                    //last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[i] = null;
                }

            }
            else if (crewtimesheetList.Count == 7) //CASE 2: 7 valid data
            {

                int arrayindex = 0;
                for (int j = 0; j < crewtimesheetList.Count; j++)
                {
                    for (int k = 0; k < crewtimesheetList[j].BookedHours.Length; k++)
                    {
                        last7daysbookedHours.last7DaysBookedHoursReversed[arrayindex++] = crewtimesheetList[j].BookedHours[k].ToString();
                        //last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[arrayindex++] = crewtimesheetList[j].BookedHours[k].ToString();
                    }
                }


            }
            else if (crewtimesheetList.Count > 0 && crewtimesheetList.Count < 7) //CASE 3 : partial data
            {
                DateTime furthestDate = bookDate.AddDays(-7);
                int insertarrayIndex = 0;
                int validdataindexCounter = 0;
                DateTime nearestDate = bookDate;
                bool isDataFilled = false;
                bool hassaveddataforBookDate = false;

                //            while (nearestDate >= furthestDate)
                //{
                //	//check if data for this date exist

                //	int pos = crewtimesheetList.FindIndex(i => i.BookDate == furthestDate);

                //	//check if there is saved data for the book date already
                //	if (furthestDate == nearestDate)
                //	{
                //		if (pos >= 0) hassaveddataforBookDate = true;
                //		else hassaveddataforBookDate = false;

                //	}

                //	if(pos >= 0) //data present for this date
                //	{
                //		for (int k = 0; k < crewtimesheetList[pos].BookedHours.Length; k++)
                //		{
                //			last7daysbookedHours.last7DaysBookedHoursReversed[insertarrayIndex++] = crewtimesheetList[pos].BookedHours[k].ToString();
                //			//last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[insertarrayIndex++] = crewtimesheetList[pos].BookedHours[k].ToString();
                //		}

                //		isDataFilled = true;
                //		//setting the last index where valid data is stored
                //		validdataindexCounter = insertarrayIndex;

                //	}
                //	else if(isDataFilled) //data not present for this date
                //	{
                //		for (int i = insertarrayIndex; i < insertarrayIndex + 48 ; i++)
                //		{
                //			last7daysbookedHours.last7DaysBookedHoursReversed[i] = null;
                //			//last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[i] = null;
                //		}

                //		insertarrayIndex += 48;
                //	}

                //	furthestDate = furthestDate.AddDays(1);

                //}

                //if(hassaveddataforBookDate) //there is already data for current bookdate
                //{
                //	//populating current day data at last 
                //	for (int i = validdataindexCounter - 48, w = 0; i < validdataindexCounter; i++, w++)
                //	{
                //		last7daysbookedHours.last7DaysBookedHoursReversed[i] = todaybookedHours[w].ToString();
                //		//last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[i] = todaybookedHours[w].ToString();
                //	}
                //}
                //else // data is being typed in the UI
                //{
                //	//populating current day data at last 
                //	for (int i = validdataindexCounter, w = 0; i < validdataindexCounter + 48 ; i++, w++)
                //	{
                //		last7daysbookedHours.last7DaysBookedHoursReversed[i] = todaybookedHours[w].ToString();
                //		//last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[i] = todaybookedHours[w].ToString();
                //	}
                //}


                int arrayindex = 0;
                for (int j = 0; j < crewtimesheetList.Count; j++)
                {
                    for (int k = 0; k < crewtimesheetList[j].BookedHours.Length; k++)
                    {
                        last7daysbookedHours.last7DaysBookedHoursReversed[arrayindex++] = crewtimesheetList[j].BookedHours[k].ToString();
                        //last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[arrayindex++] = crewtimesheetList[j].BookedHours[k].ToString();
                    }
                }


                //populating current day data at last 
                for (int i = 288, w = 0; i < 336; i++, w++)
                {
                    last7daysbookedHours.last7DaysBookedHoursReversed[i] = todaybookedHours[w].ToString();
                    //last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[i] = todaybookedHours[w].ToString();
                }



            }

            //copy array
            Array.Copy(last7daysbookedHours.last7DaysBookedHoursReversed, last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues, 336);

            for (int i = 0; i < last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues.Length; i++)
            {
                if (String.IsNullOrEmpty(last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[i]))
                {
                    last7daysbookedHours.last7DaysBookedHoursReversedWithZeroValues[i] = "0";
                }
            }


            return last7daysbookedHours;

        }



        public int UpdateInActive(int ID)
        {
            CrewDAL crewDAL = new CrewDAL();
            return crewDAL.UpdateInActive(ID);
        }


        public bool GetCrewOvertimeValue(int ID, int VesselID)
        {
            CrewDAL crewDAL = new CrewDAL();
            return crewDAL.GetCrewOvertimeValue(ID, VesselID).OvertimeEnabled;
        }


        //for Department drp
        public List<DepartmentPOCO> GetAllDepartmentForDrp(int VesselID)
        {
            CrewDAL crew = new CrewDAL();
            return crew.GetAllDepartmentForDrp(VesselID);
        }

        //for CountryMaster drp
        public List<CrewPOCO> GetAllCountryForDrp(/*int VesselID*/)
        {
            CrewDAL crew = new CrewDAL();
            return crew.GetAllCountryForDrp(/*VesselID*/);
        }

        public int SaveJoiningMedicalFilePath(int crewId, string filepath)
        {
            CrewDAL crewDAL = new CrewDAL();
            return crewDAL.SaveJoiningMedicalFilePath(crewId, filepath);        //UploadJoiningMedical  --->  in Controler
        }

        public string GetJoiningMedicalFileDatawByID(int CrewId)
        {
            CrewDAL crewDAL = new CrewDAL();
            return crewDAL.GetJoiningMedicalFileDatawByID(CrewId);
        }
        public int SaveCrewTemperature(CrewTemperaturePOCO crewTemperature)
        {
            CrewDAL crew = new CrewDAL();
            return crew.SaveCrewTemperature(crewTemperature);
        }

        public List<CrewPOCO> GetAllTemperatureModeForDrp()
        {
            CrewDAL crew = new CrewDAL();
            return crew.GetAllTemperatureModeForDrp();
        }

    }
}