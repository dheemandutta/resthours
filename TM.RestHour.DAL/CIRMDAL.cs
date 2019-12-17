﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.Base.Entities;

namespace TM.RestHour.DAL
{
    public class CIRMDAL
    {
        public int SaveCIRM(CIRMPOCO cIRM/*, int VesselID*/)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSaveCIRM", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@NameOfVessel", cIRM.NameOfVessel.ToString());

            if (!String.IsNullOrEmpty(cIRM.RadioCallSign))
            {
                cmd.Parameters.AddWithValue("@RadioCallSign", cIRM.RadioCallSign.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@RadioCallSign", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PortofDestination))
            {
                cmd.Parameters.AddWithValue("@PortofDestination", cIRM.PortofDestination.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortofDestination", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Route))
            {
                cmd.Parameters.AddWithValue("@Route", cIRM.Route.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Route", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.LocationOfShip))
            {
                cmd.Parameters.AddWithValue("@LocationOfShip", cIRM.LocationOfShip.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@LocationOfShip", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.PortofDeparture))
            {
                cmd.Parameters.AddWithValue("@PortofDeparture", cIRM.PortofDeparture.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PortofDeparture", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.EstimatedTimeOfarrivalhrs))
            {
                cmd.Parameters.AddWithValue("@EstimatedTimeOfarrivalhrs", cIRM.EstimatedTimeOfarrivalhrs.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@EstimatedTimeOfarrivalhrs", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Speed))
            {
                cmd.Parameters.AddWithValue("@Speed", cIRM.Speed.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Speed", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Nationality))
            {
                cmd.Parameters.AddWithValue("@Nationality", cIRM.Nationality.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Nationality", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Qualification))
            {
                cmd.Parameters.AddWithValue("@Qualification", cIRM.Qualification.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Qualification", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.RespiratoryRate))
            {
                cmd.Parameters.AddWithValue("@RespiratoryRate", cIRM.RespiratoryRate.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@RespiratoryRate", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Pulse))
            {
                cmd.Parameters.AddWithValue("@Pulse", cIRM.Pulse.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Pulse", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Temperature))
            {
                cmd.Parameters.AddWithValue("@Temperature", cIRM.Temperature.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Temperature", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Systolic))
            {
                cmd.Parameters.AddWithValue("@Systolic", cIRM.Systolic.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Systolic", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Diastolic))
            {
                cmd.Parameters.AddWithValue("@Diastolic", cIRM.Diastolic.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Diastolic", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.Symptomatology))
            {
                cmd.Parameters.AddWithValue("@Symptomatology", cIRM.Symptomatology.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@Symptomatology", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.LocationAndTypeOfPain))
            {
                cmd.Parameters.AddWithValue("@LocationAndTypeOfPain", cIRM.LocationAndTypeOfPain.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@LocationAndTypeOfPain", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.RelevantInformationForDesease))
            {
                cmd.Parameters.AddWithValue("@RelevantInformationForDesease", cIRM.RelevantInformationForDesease.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@RelevantInformationForDesease", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@WhereAndHowAccidentIsCausedCHK", cIRM.WhereAndHowAccidentIsCausedCHK);

            //if (!String.IsNullOrEmpty(cIRM.WhereAndHowAccidentIsCausedCHK))
            //{
            //    cmd.Parameters.AddWithValue("@WhereAndHowAccidentIsCausedCHK", cIRM.WhereAndHowAccidentIsCausedCHK.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@WhereAndHowAccidentIsCausedCHK", DBNull.Value);
            //}

            if (!String.IsNullOrEmpty(cIRM.UploadMedicalHistory))
            {
                cmd.Parameters.AddWithValue("@UploadMedicalHistory", cIRM.UploadMedicalHistory.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@UploadMedicalHistory", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.UploadMedicinesAvailable))
            {
                cmd.Parameters.AddWithValue("@UploadMedicinesAvailable", cIRM.UploadMedicinesAvailable.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@UploadMedicinesAvailable", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.MedicalProductsAdministered))
            {
                cmd.Parameters.AddWithValue("@MedicalProductsAdministered", cIRM.MedicalProductsAdministered.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@MedicalProductsAdministered", DBNull.Value);
            }

            if (!String.IsNullOrEmpty(cIRM.WhereAndHowAccidentIsausedARA))
            {
                cmd.Parameters.AddWithValue("@WhereAndHowAccidentIsausedARA", cIRM.WhereAndHowAccidentIsausedARA.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@WhereAndHowAccidentIsausedARA", DBNull.Value);
            }

            cmd.Parameters.AddWithValue("@CrewId", cIRM.CrewId);


            if (cIRM.CIRMId > 0)
            {
                cmd.Parameters.AddWithValue("@CIRMId", cIRM.CIRMId);
            }
            else
            {
                cmd.Parameters.AddWithValue("@CIRMId", DBNull.Value);
            }
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }       
    }
}
