using System;
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
    public class PsychologicalEvaluationDAL
    {

        public int SaveForms(string[] arrQuestionNo, string[] arrAnswer, int totalCount, string testResult, int CrewID, int VesselID, string StoredProcedure)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();

            //SqlCommand cmd = new SqlCommand("stpSaveLocusOfControl", con);
            SqlCommand cmd = new SqlCommand(StoredProcedure, con);   /////////////// StoredProcedure ///////////////

            var questions = string.Join(",", arrQuestionNo);
            var answers = string.Join(",", arrAnswer);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Question", questions);
            cmd.Parameters.AddWithValue("@Answer", answers);
            cmd.Parameters.AddWithValue("@FinalScore", totalCount);
            cmd.Parameters.AddWithValue("@TestResult", testResult.ToString());
            cmd.Parameters.AddWithValue("@VesselID", CrewID);
            cmd.Parameters.AddWithValue("@CrewId", VesselID);

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int SaveForms(string[] arrQuestionNo, string[] arrAnswer, decimal totalCount, string testResult, int CrewID, int VesselID, string StoredProcedure)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();

            //SqlCommand cmd = new SqlCommand("stpSaveLocusOfControl", con);
            SqlCommand cmd = new SqlCommand(StoredProcedure, con);   /////////////// StoredProcedure ///////////////

            var questions = string.Join(",", arrQuestionNo);
            var answers = string.Join(",", arrAnswer);

            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Question", questions);
            cmd.Parameters.AddWithValue("@Answer", answers);
            cmd.Parameters.AddWithValue("@FinalScore", totalCount);
            cmd.Parameters.AddWithValue("@TestResult", testResult.ToString());
            cmd.Parameters.AddWithValue("@VesselID", CrewID);
            cmd.Parameters.AddWithValue("@CrewId", VesselID);

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }




        public PsychologicalEvaluationPOCO GetLocusOfControl(int VesselID, int CrewId)
        {
            List<PsychologicalEvaluationPOCO> prodPOList = new List<PsychologicalEvaluationPOCO>();
            List<PsychologicalEvaluationPOCO> prodPO = new List<PsychologicalEvaluationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetLocusOfControl", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@VesselID", VesselID);
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToLocusOfControlList(ds);
        }

        private PsychologicalEvaluationPOCO ConvertDataTableToLocusOfControlList(DataSet ds)
        {
            PsychologicalEvaluationPOCO pC = new PsychologicalEvaluationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    if (item["Id"] != DBNull.Value)
                        pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["Question"] != DBNull.Value)
                        pC.Question = item["Question"].ToString();

                    if (item["Answer"] != DBNull.Value)
                        pC.Answer = item["Answer"].ToString();

                    if (item["FinalScore"] != DBNull.Value)
                        pC.FinalScore = Convert.ToInt32(item["FinalScore"].ToString());

                    if (item["TestResult"] != DBNull.Value)
                        pC.TestResult = item["TestResult"].ToString();

                    if (item["VesselID"] != DBNull.Value)
                        pC.VesselID = Convert.ToInt32(item["VesselID"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        pC.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    //List<int> days = new List<int>();
                    //departmentList.Add(departmentPC);
                }
            }
            return pC;
        }








        public int Save_BeckDepressionInventoryIIFinal(string[] LocusOfControl, int CrewID, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSave_BeckDepressionInventoryIIFinal", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@DoctorName", consultant.DoctorName.ToString());
            //cmd.Parameters.AddWithValue("@DoctorEmail", consultant.DoctorEmail.ToString());
            //cmd.Parameters.AddWithValue("@SpecialityID", consultant.SpecialityID);

            //if (!String.IsNullOrEmpty(consultant.Comment))
            //{
            //    cmd.Parameters.AddWithValue("@Comment", consultant.Comment.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Comment", DBNull.Value);
            //}

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int Save_EmotionalIntelligenceQuizForLeadership(string[] LocusOfControl, int CrewID, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSave_EmotionalIntelligenceQuizForLeadership", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@DoctorName", consultant.DoctorName.ToString());
            //cmd.Parameters.AddWithValue("@DoctorEmail", consultant.DoctorEmail.ToString());
            //cmd.Parameters.AddWithValue("@SpecialityID", consultant.SpecialityID);

            //if (!String.IsNullOrEmpty(consultant.Comment))
            //{
            //    cmd.Parameters.AddWithValue("@Comment", consultant.Comment.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Comment", DBNull.Value);
            //}

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int Save_InstructionsForPSSFinal(string[] LocusOfControl, int CrewID, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSave_BeckDepressionInventoryIIFinal", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@DoctorName", consultant.DoctorName.ToString());
            //cmd.Parameters.AddWithValue("@DoctorEmail", consultant.DoctorEmail.ToString());
            //cmd.Parameters.AddWithValue("@SpecialityID", consultant.SpecialityID);

            //if (!String.IsNullOrEmpty(consultant.Comment))
            //{
            //    cmd.Parameters.AddWithValue("@Comment", consultant.Comment.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Comment", DBNull.Value);
            //}

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int Save_MASSMindfulnessScaleFinal(string[] LocusOfControl, int CrewID, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSave_BeckDepressionInventoryIIFinal", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@DoctorName", consultant.DoctorName.ToString());
            //cmd.Parameters.AddWithValue("@DoctorEmail", consultant.DoctorEmail.ToString());
            //cmd.Parameters.AddWithValue("@SpecialityID", consultant.SpecialityID);

            //if (!String.IsNullOrEmpty(consultant.Comment))
            //{
            //    cmd.Parameters.AddWithValue("@Comment", consultant.Comment.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Comment", DBNull.Value);
            //}

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int Save_PSQ30_PERCIEVED_STRESS_QUESTIONAIRE(string[] LocusOfControl, int CrewID, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSave_BeckDepressionInventoryIIFinal", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@DoctorName", consultant.DoctorName.ToString());
            //cmd.Parameters.AddWithValue("@DoctorEmail", consultant.DoctorEmail.ToString());
            //cmd.Parameters.AddWithValue("@SpecialityID", consultant.SpecialityID);

            //if (!String.IsNullOrEmpty(consultant.Comment))
            //{
            //    cmd.Parameters.AddWithValue("@Comment", consultant.Comment.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Comment", DBNull.Value);
            //}

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int Save_ROSENBERG_SELF_esteem_scale_final(string[] LocusOfControl, int CrewID, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSave_BeckDepressionInventoryIIFinal", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@DoctorName", consultant.DoctorName.ToString());
            //cmd.Parameters.AddWithValue("@DoctorEmail", consultant.DoctorEmail.ToString());
            //cmd.Parameters.AddWithValue("@SpecialityID", consultant.SpecialityID);

            //if (!String.IsNullOrEmpty(consultant.Comment))
            //{
            //    cmd.Parameters.AddWithValue("@Comment", consultant.Comment.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Comment", DBNull.Value);
            //}

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int Save_Zhao_ANXIETY(string[] LocusOfControl, int CrewID, int VesselID)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSave_BeckDepressionInventoryIIFinal", con);
            cmd.CommandType = CommandType.StoredProcedure;
            //cmd.Parameters.AddWithValue("@DoctorName", consultant.DoctorName.ToString());
            //cmd.Parameters.AddWithValue("@DoctorEmail", consultant.DoctorEmail.ToString());
            //cmd.Parameters.AddWithValue("@SpecialityID", consultant.SpecialityID);

            //if (!String.IsNullOrEmpty(consultant.Comment))
            //{
            //    cmd.Parameters.AddWithValue("@Comment", consultant.Comment.ToString());
            //}
            //else
            //{
            //    cmd.Parameters.AddWithValue("@Comment", DBNull.Value);
            //}

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

    }
}
