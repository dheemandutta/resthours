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
    public class MentalHealthDAL
    {
        public MentalHealthPOCO GetMentalHealthPageWise(int pageIndex, ref int postJoiningRecordCount, int length, ref int preSignOffRecordCount)
        {
            List<MentalHealthPOCO> mentalHealthPOCOList = new List<MentalHealthPOCO>();
            List<MentalHealthPOCO> equipmentsPO = new List<MentalHealthPOCO>();

            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetMentalHealth", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PageIndex", pageIndex);
                    cmd.Parameters.AddWithValue("@PageSize", length);
                    cmd.Parameters.Add("@RecordCountPostJoin", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCountPostJoin"].Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@RecordCountPreSignOff", SqlDbType.Int, 4);
                    cmd.Parameters["@RecordCountPreSignOff"].Direction = ParameterDirection.Output;

                    //cmd.CommandTimeout = 60;
                    con.Open();
                  
                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    da.Fill(ds);


                    postJoiningRecordCount = Convert.ToInt32(cmd.Parameters["@RecordCountPostJoin"].Value);
                    preSignOffRecordCount = Convert.ToInt32(cmd.Parameters["@RecordCountPreSignOff"].Value);
                    con.Close();
                }
            }
            return ConvertDataTableToMentalHealth(ds);
        }

        private MentalHealthPOCO ConvertDataTableToMentalHealth(DataSet ds)
        {
            MentalHealthPOCO pC = new MentalHealthPOCO();
            List<MentalHealthPostJoiningPOCO> mentalHealthPostJoiningPOCOs = new List<MentalHealthPostJoiningPOCO>();
            List<MentalHealthPreSignOffPOCO> mentalHealthPreSignOffPOCOs = new List<MentalHealthPreSignOffPOCO>();

            //check if there is at all any data
            if (ds.Tables.Count > 0)
            {
                foreach (DataRow item in ds.Tables[1].Rows)
                {
                    MentalHealthPreSignOffPOCO mentalHealthPreSign = new MentalHealthPreSignOffPOCO();
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        mentalHealthPreSign.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["CrewName"] != DBNull.Value)
                        mentalHealthPreSign.CrewName = item["CrewName"].ToString();

                    if (item["PreSignOffDate"] != DBNull.Value)
                        mentalHealthPreSign.PreSignOffDate = item["PreSignOffDate"].ToString().Substring(0, 10);

                    if (item["L"] != DBNull.Value)
                        mentalHealthPreSign.IsLocusTested = Convert.ToBoolean(item["L"].ToString());
                    else
                        mentalHealthPreSign.IsLocusTested = false;

                    if (item["M"] != DBNull.Value)
                        mentalHealthPreSign.IsMassTested = Convert.ToBoolean(item["M"].ToString());
                    else
                        mentalHealthPreSign.IsLocusTested = false;

                    if (item["P"] != DBNull.Value)
                        mentalHealthPreSign.IsPSQ30Tested = Convert.ToBoolean(item["P"].ToString());
                    else
                        mentalHealthPreSign.IsPSQ30Tested = false;

                    if (item["B"] != DBNull.Value)
                        mentalHealthPreSign.IsBeckTested = Convert.ToBoolean(item["B"].ToString());
                    else
                        mentalHealthPreSign.IsBeckTested = false;

                    if (item["Y1"] != DBNull.Value)
                        mentalHealthPreSign.IsZ1Tested = Convert.ToBoolean(item["Y1"].ToString());
                    else
                        mentalHealthPreSign.IsZ1Tested = false;

                    if (item["Y2"] != DBNull.Value)
                        mentalHealthPreSign.IsZ2Tested = Convert.ToBoolean(item["Y2"].ToString());
                    else
                        mentalHealthPreSign.IsZ2Tested = false;

                    if (item["R"] != DBNull.Value)
                        mentalHealthPreSign.IsRoseTested = Convert.ToBoolean(item["R"].ToString());
                    else
                        mentalHealthPreSign.IsRoseTested = false;

                    if (item["E"] != DBNull.Value)
                        mentalHealthPreSign.IsEmotionalTested = Convert.ToBoolean(item["E"].ToString());
                    else
                        mentalHealthPreSign.IsEmotionalTested = false;

                    mentalHealthPreSignOffPOCOs.Add(mentalHealthPreSign);
                }

                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    MentalHealthPostJoiningPOCO preSignOffTestValues = new MentalHealthPostJoiningPOCO();
                    //if (item["Id"] != DBNull.Value)
                    //    pC.Id = Convert.ToInt32(item["Id"].ToString());

                    if (item["CrewId"] != DBNull.Value)
                        preSignOffTestValues.CrewId = Convert.ToInt32(item["CrewId"].ToString());

                    if (item["CrewName"] != DBNull.Value)
                        preSignOffTestValues.CrewName = item["CrewName"].ToString();

                    if (item["PostJoinDate"] != DBNull.Value)
                        preSignOffTestValues.PostJoiningDate = item["PostJoinDate"].ToString().Substring(0, 10);

                    if (item["L"] != DBNull.Value)
                        preSignOffTestValues.IsLocusTested = Convert.ToBoolean(item["L"].ToString());
                    else
                        preSignOffTestValues.IsLocusTested = false;

                    if (item["M"] != DBNull.Value)
                        preSignOffTestValues.IsMassTested = Convert.ToBoolean(item["M"].ToString());
                    else
                        preSignOffTestValues.IsLocusTested = false;

                    if (item["P"] != DBNull.Value)
                        preSignOffTestValues.IsPSQ30Tested = Convert.ToBoolean(item["P"].ToString());
                    else
                        preSignOffTestValues.IsPSQ30Tested = false;

                    if (item["B"] != DBNull.Value)
                        preSignOffTestValues.IsBeckTested = Convert.ToBoolean(item["B"].ToString());
                    else
                        preSignOffTestValues.IsBeckTested = false;

                    if (item["Y1"] != DBNull.Value)
                        preSignOffTestValues.IsZ1Tested = Convert.ToBoolean(item["Y1"].ToString());
                    else
                        preSignOffTestValues.IsZ1Tested = false;

                    if (item["Y2"] != DBNull.Value)
                        preSignOffTestValues.IsZ2Tested = Convert.ToBoolean(item["Y2"].ToString());
                    else
                        preSignOffTestValues.IsZ2Tested = false;

                    if (item["R"] != DBNull.Value)
                        preSignOffTestValues.IsRoseTested = Convert.ToBoolean(item["R"].ToString());
                    else
                        preSignOffTestValues.IsRoseTested = false;

                    if (item["E"] != DBNull.Value)
                        preSignOffTestValues.IsEmotionalTested = Convert.ToBoolean(item["E"].ToString());
                    else
                        preSignOffTestValues.IsEmotionalTested = false;

                    mentalHealthPostJoiningPOCOs.Add(preSignOffTestValues);
                }

            }
            pC.MentalHealthPostJoiningList = mentalHealthPostJoiningPOCOs;
            pC.MentalHealthPreSignOffList = mentalHealthPreSignOffPOCOs;

            return pC;
        }


    }
}
