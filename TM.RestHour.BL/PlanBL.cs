using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class PlanBL
    {
        public int SavePlanCategory(PlanPOCO planCat)
        {
            PlanDAL planDal = new PlanDAL();

            return planDal.SavePlanCategory(planCat);
        }

        public int SavePlan(PlanPOCO plan)
        {
            PlanDAL planDal = new PlanDAL();

            return planDal.SavePlan(plan);
        }

        public List<PlanPOCO> GetAllPlanCategory()
        {
            PlanDAL planDal = new PlanDAL();
            List<PlanPOCO> planCatPoList = new List<PlanPOCO>();
            planCatPoList = planDal.GetAllPlanCategory();
            return planCatPoList;
        }
        public List<PlanPOCO> GetPlanByCategory(int categoryId)
        {
            PlanDAL planDal = new PlanDAL();
            PlanPOCO planPo = new PlanPOCO();
            planPo.CategoryId = categoryId;
            List<PlanPOCO> planPoList = new List<PlanPOCO>();
            planPoList = planDal.GetPlanByCategory(planPo);
            return planPoList;
        }

        public List<PlanPOCO> GetAllPlan()
        {
            PlanDAL planDal = new PlanDAL();
            List<PlanPOCO> planPoList = new List<PlanPOCO>();
            planPoList = planDal.GetAllPlan();
            return planPoList;
        }

        public PlanPOCO GetPlanById(PlanPOCO plan)
        {
            PlanDAL planDal = new PlanDAL();
            PlanPOCO planPo = new PlanPOCO();
            planPo = planDal.GetPlanById(plan);
            return planPo;
        }
    }
}
