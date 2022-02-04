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
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            cmd.Parameters.AddWithValue("@CrewId", CrewID);

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
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            cmd.Parameters.AddWithValue("@CrewId", CrewID);

            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }


        public int SaveForms(string[] arrQuestionNo, string[] arrAnswer, int[] totalScore, string[] testResult, int CrewID, int VesselID, string StoredProcedure)
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
            cmd.Parameters.AddWithValue("@SAScore", totalScore[0]);
            cmd.Parameters.AddWithValue("@SCScore", totalScore[1]);
            cmd.Parameters.AddWithValue("@EmpathyScore", totalScore[2]);
            cmd.Parameters.AddWithValue("@RIScore", totalScore[3]);
            cmd.Parameters.AddWithValue("@SATestResult", testResult[0].ToString());
            cmd.Parameters.AddWithValue("@SCTestResult", testResult[1].ToString());
            cmd.Parameters.AddWithValue("@EmpathyTestResult", testResult[2].ToString());
            cmd.Parameters.AddWithValue("@RITestResult", testResult[3].ToString());
            cmd.Parameters.AddWithValue("@VesselID", VesselID);
            cmd.Parameters.AddWithValue("@CrewId", CrewID);

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








        public PsychologicalEvaluationPOCO GetLocusOfControlByJoiningCondition(int CrewId, int JoiningCondition)
        {
            List<PsychologicalEvaluationPOCO> prodPOList = new List<PsychologicalEvaluationPOCO>();
            List<PsychologicalEvaluationPOCO> prodPO = new List<PsychologicalEvaluationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stptblLocusOfControlByJoiningCondition", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@JoiningCondition", JoiningCondition);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToLocusOfControlByJoiningConditionList(ds);
        }

        private PsychologicalEvaluationPOCO ConvertDataTableToLocusOfControlByJoiningConditionList(DataSet ds)
        {
            PsychologicalEvaluationPOCO pC = new PsychologicalEvaluationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["Question"] != DBNull.Value)
                        pC.Question = item["Question"].ToString();

                    if (item["Answer"] != DBNull.Value)
                        pC.Answer = item["Answer"].ToString();

                    if (item["FinalScore"] != DBNull.Value)
                        pC.FinalScore = Convert.ToInt32(item["FinalScore"].ToString());

                    if (item["TestResult"] != DBNull.Value)
                        pC.TestResult = item["TestResult"].ToString();

                    if (item["TestDate"] != DBNull.Value)
                        pC.TestDate = Convert.ToDateTime(item["TestDate"].ToString());

                    if (item["VesselID"] != DBNull.Value)
                        pC.VesselID = Convert.ToInt32(item["VesselID"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        pC.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["IsExport"] != DBNull.Value)
                        pC.IsExport = Convert.ToInt32(item["IsExport"].ToString());
                }
            }
            return pC;
        }



        public PsychologicalEvaluationPOCO GetMASSMindfulnessScaleFinalByJoiningCondition(int CrewId, int JoiningCondition)
        {
            List<PsychologicalEvaluationPOCO> prodPOList = new List<PsychologicalEvaluationPOCO>();
            List<PsychologicalEvaluationPOCO> prodPO = new List<PsychologicalEvaluationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stptblMASSMindfulnessScaleFinalByJoiningCondition", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@JoiningCondition", JoiningCondition);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToMASSMindfulnessScaleFinalByJoiningConditionList(ds);
        }

        private PsychologicalEvaluationPOCO ConvertDataTableToMASSMindfulnessScaleFinalByJoiningConditionList(DataSet ds)
        {
            PsychologicalEvaluationPOCO pC = new PsychologicalEvaluationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["Question"] != DBNull.Value)
                        pC.Question = item["Question"].ToString();

                    if (item["Answer"] != DBNull.Value)
                        pC.Answer = item["Answer"].ToString();

                    if (item["FinalScore"] != DBNull.Value)
                        pC.FinalScore = Convert.ToInt32(item["FinalScore"].ToString());

                    if (item["TestResult"] != DBNull.Value)
                        pC.TestResult = item["TestResult"].ToString();

                    if (item["TestDate"] != DBNull.Value)
                        pC.TestDate = Convert.ToDateTime(item["TestDate"].ToString());

                    if (item["VesselID"] != DBNull.Value)
                        pC.VesselID = Convert.ToInt32(item["VesselID"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        pC.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["IsExport"] != DBNull.Value)
                        pC.IsExport = Convert.ToInt32(item["IsExport"].ToString());
                }
            }
            return pC;
        }



        public PsychologicalEvaluationPOCO GetPSQ30PercievedStressByJoiningCondition(int CrewId, int JoiningCondition)
        {
            List<PsychologicalEvaluationPOCO> prodPOList = new List<PsychologicalEvaluationPOCO>();
            List<PsychologicalEvaluationPOCO> prodPO = new List<PsychologicalEvaluationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stptblPSQ30PercievedStressByJoiningCondition", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@JoiningCondition", JoiningCondition);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToPSQ30PercievedStressByJoiningConditionList(ds);
        }

        private PsychologicalEvaluationPOCO ConvertDataTableToPSQ30PercievedStressByJoiningConditionList(DataSet ds)
        {
            PsychologicalEvaluationPOCO pC = new PsychologicalEvaluationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["Question"] != DBNull.Value)
                        pC.Question = item["Question"].ToString();

                    if (item["Answer"] != DBNull.Value)
                        pC.Answer = item["Answer"].ToString();

                    if (item["FinalScore"] != DBNull.Value)
                        pC.FinalScore = Convert.ToInt32(item["FinalScore"].ToString());

                    if (item["TestResult"] != DBNull.Value)
                        pC.TestResult = item["TestResult"].ToString();

                    if (item["TestDate"] != DBNull.Value)
                        pC.TestDate = Convert.ToDateTime(item["TestDate"].ToString());

                    if (item["VesselID"] != DBNull.Value)
                        pC.VesselID = Convert.ToInt32(item["VesselID"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        pC.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["IsExport"] != DBNull.Value)
                        pC.IsExport = Convert.ToInt32(item["IsExport"].ToString());
                }
            }
            return pC;
        }



        public PsychologicalEvaluationPOCO GetBeckDepressionInventoryByJoiningCondition(int CrewId, int JoiningCondition)
        {
            List<PsychologicalEvaluationPOCO> prodPOList = new List<PsychologicalEvaluationPOCO>();
            List<PsychologicalEvaluationPOCO> prodPO = new List<PsychologicalEvaluationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stptblBeckDepressionInventoryByJoiningCondition", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@JoiningCondition", JoiningCondition);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToBeckDepressionInventoryByJoiningConditionList(ds);
        }

        private PsychologicalEvaluationPOCO ConvertDataTableToBeckDepressionInventoryByJoiningConditionList(DataSet ds)
        {
            PsychologicalEvaluationPOCO pC = new PsychologicalEvaluationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["Question"] != DBNull.Value)
                        pC.Question = item["Question"].ToString();

                    if (item["Answer"] != DBNull.Value)
                        pC.Answer = item["Answer"].ToString();

                    if (item["FinalScore"] != DBNull.Value)
                        pC.FinalScore = Convert.ToInt32(item["FinalScore"].ToString());

                    if (item["TestResult"] != DBNull.Value)
                        pC.TestResult = item["TestResult"].ToString();

                    if (item["TestDate"] != DBNull.Value)
                        pC.TestDate = Convert.ToDateTime(item["TestDate"].ToString());

                    if (item["VesselID"] != DBNull.Value)
                        pC.VesselID = Convert.ToInt32(item["VesselID"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        pC.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["IsExport"] != DBNull.Value)
                        pC.IsExport = Convert.ToInt32(item["IsExport"].ToString());
                }
            }
            return pC;
        }



        public PsychologicalEvaluationPOCO GetZhaoANXIETY_Y1ByJoiningCondition(int CrewId, int JoiningCondition)
        {
            List<PsychologicalEvaluationPOCO> prodPOList = new List<PsychologicalEvaluationPOCO>();
            List<PsychologicalEvaluationPOCO> prodPO = new List<PsychologicalEvaluationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stptblZhaoANXIETY_Y1ByJoiningCondition", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@JoiningCondition", JoiningCondition);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToZhaoANXIETY_Y1ByJoiningConditionList(ds);
        }

        private PsychologicalEvaluationPOCO ConvertDataTableToZhaoANXIETY_Y1ByJoiningConditionList(DataSet ds)
        {
            PsychologicalEvaluationPOCO pC = new PsychologicalEvaluationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["Question"] != DBNull.Value)
                        pC.Question = item["Question"].ToString();

                    if (item["Answer"] != DBNull.Value)
                        pC.Answer = item["Answer"].ToString();

                    if (item["FinalScore"] != DBNull.Value)
                        pC.FinalScore = Convert.ToInt32(item["FinalScore"].ToString());

                    if (item["TestResult"] != DBNull.Value)
                        pC.TestResult = item["TestResult"].ToString();

                    if (item["TestDate"] != DBNull.Value)
                        pC.TestDate = Convert.ToDateTime(item["TestDate"].ToString());

                    if (item["VesselID"] != DBNull.Value)
                        pC.VesselID = Convert.ToInt32(item["VesselID"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        pC.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["IsExport"] != DBNull.Value)
                        pC.IsExport = Convert.ToInt32(item["IsExport"].ToString());
                }
            }
            return pC;
        }



        public PsychologicalEvaluationPOCO GetZhaoANXIETY_Y2ByJoiningCondition(int CrewId, int JoiningCondition)
        {
            List<PsychologicalEvaluationPOCO> prodPOList = new List<PsychologicalEvaluationPOCO>();
            List<PsychologicalEvaluationPOCO> prodPO = new List<PsychologicalEvaluationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stptblZhaoANXIETY_Y2ByJoiningCondition", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@JoiningCondition", JoiningCondition);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToZhaoANXIETY_Y2ByJoiningConditionList(ds);
        }

        private PsychologicalEvaluationPOCO ConvertDataTableToZhaoANXIETY_Y2ByJoiningConditionList(DataSet ds)
        {
            PsychologicalEvaluationPOCO pC = new PsychologicalEvaluationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["Question"] != DBNull.Value)
                        pC.Question = item["Question"].ToString();

                    if (item["Answer"] != DBNull.Value)
                        pC.Answer = item["Answer"].ToString();

                    if (item["FinalScore"] != DBNull.Value)
                        pC.FinalScore = Convert.ToInt32(item["FinalScore"].ToString());

                    if (item["TestResult"] != DBNull.Value)
                        pC.TestResult = item["TestResult"].ToString();

                    if (item["TestDate"] != DBNull.Value)
                        pC.TestDate = Convert.ToDateTime(item["TestDate"].ToString());

                    if (item["VesselID"] != DBNull.Value)
                        pC.VesselID = Convert.ToInt32(item["VesselID"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        pC.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["IsExport"] != DBNull.Value)
                        pC.IsExport = Convert.ToInt32(item["IsExport"].ToString());
                }
            }
            return pC;
        }



        public PsychologicalEvaluationPOCO GetRosenbergSelfEsteemByJoiningCondition(int CrewId, int JoiningCondition)
        {
            List<PsychologicalEvaluationPOCO> prodPOList = new List<PsychologicalEvaluationPOCO>();
            List<PsychologicalEvaluationPOCO> prodPO = new List<PsychologicalEvaluationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stptblRosenbergSelfEsteemByJoiningCondition", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@JoiningCondition", JoiningCondition);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToRosenbergSelfEsteemByJoiningConditionList(ds);
        }

        private PsychologicalEvaluationPOCO ConvertDataTableToRosenbergSelfEsteemByJoiningConditionList(DataSet ds)
        {
            PsychologicalEvaluationPOCO pC = new PsychologicalEvaluationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["Question"] != DBNull.Value)
                        pC.Question = item["Question"].ToString();

                    if (item["Answer"] != DBNull.Value)
                        pC.Answer = item["Answer"].ToString();

                    if (item["FinalScore"] != DBNull.Value)
                        pC.FinalScore = Convert.ToInt32(item["FinalScore"].ToString());

                    if (item["TestResult"] != DBNull.Value)
                        pC.TestResult = item["TestResult"].ToString();

                    if (item["TestDate"] != DBNull.Value)
                        pC.TestDate = Convert.ToDateTime(item["TestDate"].ToString());

                    if (item["VesselID"] != DBNull.Value)
                        pC.VesselID = Convert.ToInt32(item["VesselID"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        pC.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["IsExport"] != DBNull.Value)
                        pC.IsExport = Convert.ToInt32(item["IsExport"].ToString());
                }
            }
            return pC;
        }



        public PsychologicalEvaluationPOCO GetEmotionalIntelligenceByJoiningCondition(int CrewId, int JoiningCondition)
        {
            List<PsychologicalEvaluationPOCO> prodPOList = new List<PsychologicalEvaluationPOCO>();
            List<PsychologicalEvaluationPOCO> prodPO = new List<PsychologicalEvaluationPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stptblEmotionalIntelligenceByJoiningCondition", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CrewId", CrewId);
                    cmd.Parameters.AddWithValue("@JoiningCondition", JoiningCondition);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            return ConvertDataTableToEmotionalIntelligenceByJoiningConditionList(ds);
        }

        private PsychologicalEvaluationPOCO ConvertDataTableToEmotionalIntelligenceByJoiningConditionList(DataSet ds)
        {
            PsychologicalEvaluationPOCO pC = new PsychologicalEvaluationPOCO();
            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["Question"] != DBNull.Value)
                        pC.Question = item["Question"].ToString();

                    if (item["Answer"] != DBNull.Value)
                        pC.Answer = item["Answer"].ToString();

                    if (item["FinalScore"] != DBNull.Value)
                        pC.FinalScore = Convert.ToInt32(item["FinalScore"].ToString());

                    if (item["TestResult"] != DBNull.Value)
                        pC.TestResult = item["TestResult"].ToString();

                    if (item["TestDate"] != DBNull.Value)
                        pC.TestDate = Convert.ToDateTime(item["TestDate"].ToString());

                    if (item["VesselID"] != DBNull.Value)
                        pC.VesselID = Convert.ToInt32(item["VesselID"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        pC.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["IsExport"] != DBNull.Value)
                        pC.IsExport = Convert.ToInt32(item["IsExport"].ToString());



                    if (item["SAScore"] != DBNull.Value)
                        pC.SAScore = Convert.ToInt32(item["SAScore"].ToString());

                    if (item["SATestResult"] != DBNull.Value)
                        pC.SATestResult = item["SATestResult"].ToString();

                    if (item["SCScore"] != DBNull.Value)
                        pC.SCScore = Convert.ToInt32(item["SCScore"].ToString());

                    if (item["SCTestResult"] != DBNull.Value)
                        pC.SCTestResult = item["SCTestResult"].ToString();

                    if (item["EmpathyScore"] != DBNull.Value)
                        pC.EmpathyScore = Convert.ToInt32(item["EmpathyScore"].ToString());

                    if (item["EmpathyTestResult"] != DBNull.Value)
                        pC.EmpathyTestResult = item["EmpathyTestResult"].ToString();

                    if (item["RIScore"] != DBNull.Value)
                        pC.RIScore = Convert.ToInt32(item["RIScore"].ToString());

                    if (item["RITestResult"] != DBNull.Value)
                        pC.RITestResult = item["RITestResult"].ToString();

                }
            }
            return pC;
        }

    }
}
