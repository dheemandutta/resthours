using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TM.Base.Entities;

namespace TM.RestHour.DAL
{
    public class PlanDAL
    {
        public int SavePlanCategory(PlanPOCO planCat)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSavePlanCategory", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@CategoryId", planCat.CategoryId);
            cmd.Parameters.AddWithValue("@CategoryName", planCat.CategoryName.ToString()); 
            
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public int SavePlan(PlanPOCO plan)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString);
            con.Open();
            SqlCommand cmd = new SqlCommand("stpSavePlan", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@PlanId", plan.PlanId);
            cmd.Parameters.AddWithValue("@CategoryId", plan.CategoryId);
            cmd.Parameters.AddWithValue("@PlanName", plan.PlanName.ToString());
            if (!String.IsNullOrEmpty(plan.PlanImagePath))
            {
                cmd.Parameters.AddWithValue("@PlanImagePath", plan.PlanImagePath.ToString());
            }
            else
            {
                cmd.Parameters.AddWithValue("@PlanImagePath", DBNull.Value);
            }
            cmd.Parameters.AddWithValue("@CreatedOrUpdatedBy", plan.CreatedBy);
            
            int recordsAffected = cmd.ExecuteNonQuery();
            con.Close();

            return recordsAffected;
        }

        public List<PlanPOCO> GetAllPlanCategory()
        {
            List<PlanPOCO> planCatPoList = new List<PlanPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetAllPlanCategory", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            if (ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    PlanPOCO planPo = new PlanPOCO();
                    if (item["CategoryId"] != null)
                        planPo.CategoryId = Convert.ToInt32(item["CategoryId"].ToString());


                    if (item["CategoryName"] != null)
                        planPo.CategoryName = item["CategoryName"].ToString();

                    
                    planCatPoList.Add(planPo);

                }
            }

            return planCatPoList;
        }
        public List<PlanPOCO> GetPlanByCategory(PlanPOCO plan)
        {
            List<PlanPOCO> planPoList = new List<PlanPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetPlanByCategory", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CategoryId", plan.CategoryId);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            if (ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    PlanPOCO planPo = new PlanPOCO();
                    if (item["PlanId"] != null)
                        planPo.PlanId = Convert.ToInt32(item["PlanId"].ToString());
                    if (item["CategoryId"] != null)
                        planPo.CategoryId = Convert.ToInt32(item["CategoryId"].ToString());


                    if (item["PlanName"] != null)
                        planPo.PlanName = item["PlanName"].ToString();

                    if (item["PlanImagePath"] != null)
                        planPo.PlanImagePath = item["PlanImagePath"].ToString();

                    if (item["CreatedBy"] != null)
                        planPo.CreatedBy = Convert.ToInt32(item["CreatedBy"].ToString());

                    if (item["CreatedAt"] != null)
                        planPo.CreatedAt = item["CreatedAt"].ToString();


                    if (item["UpdatedBy"] != null)
                        planPo.UpdatedBy = Convert.ToInt32(item["UpdatedBy"].ToString());

                    if (item["UpdatedAt"] != null)
                        planPo.UpdatedAt = item["UpdatedAt"].ToString();

                    planPoList.Add(planPo);

                }
            }

            return planPoList;
        }

        public List<PlanPOCO> GetAllPlan()
        {
            List<PlanPOCO> planPoList = new List<PlanPOCO>();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetAllPlan", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            if (ds.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow item in ds.Tables[0].Rows)
                {
                    PlanPOCO planPo = new PlanPOCO();
                    if (item["PlanId"] != null)
                        planPo.PlanId = Convert.ToInt32(item["PlanId"].ToString());
                    if (item["CategoryId"] != null)
                        planPo.CategoryId = Convert.ToInt32(item["CategoryId"].ToString());


                    if (item["PlanName"] != null)
                        planPo.PlanName = item["PlanName"].ToString();

                    if (item["PlanImagePath"] != null)
                        planPo.PlanImagePath = item["PlanImagePath"].ToString();

                    if (item["CreatedBy"] != null)
                        planPo.CreatedBy = Convert.ToInt32(item["CreatedBy"].ToString());

                    if (item["CreatedAt"] != null)
                        planPo.CreatedAt = item["CreatedAt"].ToString();


                    if (item["UpdatedBy"] != null)
                        planPo.UpdatedBy = Convert.ToInt32(item["UpdatedBy"].ToString());

                    if (item["UpdatedAt"] != null)
                        planPo.UpdatedAt = item["UpdatedAt"].ToString();

                    planPoList.Add(planPo);

                }
            }

            return planPoList;
        }

        public PlanPOCO GetPlanById(PlanPOCO plan)
        {
            
            PlanPOCO planPo = new PlanPOCO();
            DataSet ds = new DataSet();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["RestHourDBConnectionString"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("stpGetPlanById", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PlanId", plan.PlanId);
                    con.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(ds);
                    con.Close();
                }
            }
            if (ds.Tables[0].Rows.Count > 0)
            {

                if (ds.Tables[0].Rows[0]["PlanId"] != null)
                    planPo.PlanId = Convert.ToInt32(ds.Tables[0].Rows[0]["PlanId"].ToString());
                if (ds.Tables[0].Rows[0]["CategoryId"] != null)
                    planPo.CategoryId = Convert.ToInt32(ds.Tables[0].Rows[0]["CategoryId"].ToString());


                if (ds.Tables[0].Rows[0]["PlanName"] != null)
                    planPo.PlanName = ds.Tables[0].Rows[0]["PlanName"].ToString();

                if (ds.Tables[0].Rows[0]["PlanImagePath"] != null)
                    planPo.PlanImagePath = ds.Tables[0].Rows[0]["PlanImagePath"].ToString();

                if (ds.Tables[0].Rows[0]["CreatedBy"] != null)
                    planPo.CreatedBy = Convert.ToInt32(ds.Tables[0].Rows[0]["CreatedBy"].ToString());

                if (ds.Tables[0].Rows[0]["CreatedAt"] != null)
                    planPo.CreatedAt = ds.Tables[0].Rows[0]["CreatedAt"].ToString();


                if (ds.Tables[0].Rows[0]["UpdatedBy"] != null)
                    planPo.UpdatedBy = Convert.ToInt32(ds.Tables[0].Rows[0]["UpdatedBy"].ToString());

                if (ds.Tables[0].Rows[0]["UpdatedAt"] != null)
                    planPo.UpdatedAt = ds.Tables[0].Rows[0]["UpdatedAt"].ToString();


            }

            return planPo;
        }

    }
}
