using TM.RestHour.DAL;
using TM.Base.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TM.RestHour.BL
{
    public class PsychologicalEvaluationBL
    {
        public int SaveForms(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId)
        {
            int result = 0;

            switch (formId)
            {
                case 1:
                    result = SaveLocusOfControl(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId);
                    break;
                case 2:
                    result = SavePSSFinal(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId);
                    break;
                case 3:
                    result = SaveMASSMindfulnessScaleFinal(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId);
                    break;
                case 4:
                    result = SaveBeckDepressionInventoryIIFinal(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId);
                    break;
                case 5:
                    result = SavePSQ30_PERCIEVED_STRESS_QUESTIONAIRE(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId);
                    break;
                case 6:
                    result = SaveROSENBERG_SELF_esteem_scale_final(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId);
                    break;
                case 7:
                    result = SaveZhao_ANXIETY_Y1(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId);
                    break;
                case 8:
                    result = SaveZhao_ANXIETY_Y2(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId);
                    break;
                case 9:
                    result = SaveEmotionalIntelligenceQuizForLeadership(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId);
                    break;
            }
            return result;
        }






        private int SaveLocusOfControl(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId)
        {
            string[] arrQuestionNo = new string[10];
            string[] arrAnswer = new string[10];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrLocusOfControl.Length; i++)
            {
                string[] temp = arrLocusOfControl[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }

            for (int i = 0; i < arrQuestionNo.Length; i++)
            {
                switch (int.Parse(arrQuestionNo[i]))
                {
                    case 1:
                        totalCount = totalCount + CalculateAnswer2(int.Parse(arrAnswer[i]));
                        break;
                    case 2:
                        totalCount = totalCount + CalculateAnswer1(int.Parse(arrAnswer[i]));
                        break;
                    case 3:
                        totalCount = totalCount + CalculateAnswer2(int.Parse(arrAnswer[i]));
                        break;
                    case 4:
                        totalCount = totalCount + CalculateAnswer1(int.Parse(arrAnswer[i]));
                        break;
                    case 5:
                        totalCount = totalCount + CalculateAnswer2(int.Parse(arrAnswer[i]));
                        break;
                    case 6:
                        totalCount = totalCount + CalculateAnswer1(int.Parse(arrAnswer[i]));
                        break;
                    case 7:
                        totalCount = totalCount + CalculateAnswer2(int.Parse(arrAnswer[i]));
                        break;
                    case 8:
                        totalCount = totalCount + CalculateAnswer2(int.Parse(arrAnswer[i]));
                        break;
                    case 9:
                        totalCount = totalCount + CalculateAnswer1(int.Parse(arrAnswer[i]));
                        break;
                    case 10:
                        totalCount = totalCount + CalculateAnswer1(int.Parse(arrAnswer[i]));
                        break;
                }
            }

            if (totalCount >= 14)
            {
                testResult = "you have an internal focus of control.";
            }
            else
                testResult = "you need to get a firmer grip on things";

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure);
        }

        private int SavePSSFinal(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId)
        {
            string[] arrQuestionNo = new string[10];
            string[] arrAnswer = new string[10];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrLocusOfControl.Length; i++)
            {
                string[] temp = arrLocusOfControl[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }

            for (int i = 0; i < arrQuestionNo.Length; i++)
            {
                switch (int.Parse(arrQuestionNo[i]))
                {
                    case 1:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 2:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 3:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 4:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 5:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 6:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 7:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 8:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 9:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 10:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                }

            }

            if (totalCount <= 13)
            {
                testResult = "Low perceived stress";
            }

            else if (totalCount >= 14 && totalCount <= 26)
                testResult = "Moderate perceived stress";

            else
                testResult = "High perceived stress";

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure);

        }

        private int SaveMASSMindfulnessScaleFinal(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId)
        {
            string[] arrQuestionNo = new string[15];
            string[] arrAnswer = new string[15];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrLocusOfControl.Length; i++)
            {
                string[] temp = arrLocusOfControl[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }

            for (int i = 0; i < arrQuestionNo.Length; i++)
            {
                totalCount = totalCount + int.Parse(arrAnswer[i]);
            }

            totalCount = totalCount / arrQuestionNo.Length;

            //if (totalCount <= 13)
            //{
            //    testResult = "Low perceived stress";
            //}

            //else if (totalCount >= 14 && totalCount <= 26)
            //    testResult = "Moderate perceived stress";

            //else
            //    testResult = "High perceived stress";
        

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure);

        }

        private int SaveBeckDepressionInventoryIIFinal(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId)
        {
            string[] arrQuestionNo = new string[10];
            string[] arrAnswer = new string[10];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrLocusOfControl.Length; i++)
            {
                string[] temp = arrLocusOfControl[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }

            for (int i = 0; i < arrQuestionNo.Length; i++)
            {
                switch (int.Parse(arrQuestionNo[i]))
                {
                    case 1:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 2:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 3:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 4:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 5:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 6:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 7:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 8:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 9:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 10:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                }

            }

            if (totalCount <= 13)
            {
                testResult = "Low perceived stress";
            }

            else if (totalCount >= 14 && totalCount <= 26)
                testResult = "Moderate perceived stress";

            else
                testResult = "High perceived stress";

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure);

        }

        private int SavePSQ30_PERCIEVED_STRESS_QUESTIONAIRE(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId)
        {
            string[] arrQuestionNo = new string[30];
            string[] arrAnswer = new string[30];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int psq_mean = 0;
            decimal psq = 0;

            int counter = 0;
            for (int i = 0; i < arrLocusOfControl.Length; i++)
            {
                string[] temp = arrLocusOfControl[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }

            for (int i = 0; i < arrQuestionNo.Length; i++)
            {
                switch (int.Parse(arrQuestionNo[i]))
                {
                    case 1:
                        totalCount = totalCount + (5- int.Parse(arrAnswer[i]));
                        break;
                    case 2:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 3:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 4:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 5:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 6:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 7:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 8:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 9:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 10:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 11:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 12:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 13:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 14:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 15:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 16:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 17:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 18:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 19:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 20:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 21:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 22:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 23:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 24:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 25:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 26:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 27:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 28:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 29:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 30:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                }

            }

            psq_mean = totalCount / 30;
            psq = psq_mean - 1;
            psq = psq / 3;
            psq = psq * 100;


           

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, psq, testResult, CrewID, VesselID, StoredProcedure);

        }

        private int SaveROSENBERG_SELF_esteem_scale_final(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId)
        {
            string[] arrQuestionNo = new string[10];
            string[] arrAnswer = new string[10];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrLocusOfControl.Length; i++)
            {
                string[] temp = arrLocusOfControl[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }

            for (int i = 0; i < arrQuestionNo.Length; i++)
            {
                switch (int.Parse(arrQuestionNo[i]))
                {
                    case 1:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 2:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 3:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 4:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 5:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 6:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 7:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 8:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 9:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 10:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                }

            }

            //if (totalCount <= 13)
            //{
            //    testResult = "Low perceived stress";
            //}

            //else if (totalCount >= 14 && totalCount <= 26)
            //    testResult = "Moderate perceived stress";

            //else
            //    testResult = "High perceived stress";

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure);

        }

        private int SaveZhao_ANXIETY_Y1(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId)
        {
            string[] arrQuestionNo = new string[20];
            string[] arrAnswer = new string[20];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrLocusOfControl.Length; i++)
            {
                string[] temp = arrLocusOfControl[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }

            for (int i = 0; i < arrQuestionNo.Length; i++)
            {
                switch (int.Parse(arrQuestionNo[i]))
                {
                    case 1:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 2:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 3:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 4:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 5:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 6:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 7:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 8:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 9:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 10:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 11:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 12:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 13:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 14:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 15:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 16:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 17:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 18:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 19:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 20:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                }

            }

            //if (totalCount <= 13)
            //{
            //    testResult = "Low perceived stress";
            //}

            //else if (totalCount >= 14 && totalCount <= 26)
            //    testResult = "Moderate perceived stress";

            //else
            //    testResult = "High perceived stress";

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure);

        }

        private int SaveZhao_ANXIETY_Y2(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId)
        {
            string[] arrQuestionNo = new string[20];
            string[] arrAnswer = new string[20];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrLocusOfControl.Length; i++)
            {
                string[] temp = arrLocusOfControl[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }

            for (int i = 0; i < arrQuestionNo.Length; i++)
            {
                switch (int.Parse(arrQuestionNo[i]))
                {
                    case 1:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 2:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 3:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 4:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 5:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 6:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 7:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 8:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 9:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 10:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 11:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 12:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 13:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 14:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 15:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 16:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 17:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 18:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 19:
                        totalCount = totalCount + (5 - int.Parse(arrAnswer[i]));
                        break;
                    case 20:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                }

            }

            //if (totalCount <= 13)
            //{
            //    testResult = "Low perceived stress";
            //}

            //else if (totalCount >= 14 && totalCount <= 26)
            //    testResult = "Moderate perceived stress";

            //else
            //    testResult = "High perceived stress";

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure);

        }

        private int SaveEmotionalIntelligenceQuizForLeadership(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId)
        {
            string[] arrQuestionNo = new string[10];
            string[] arrAnswer = new string[10];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrLocusOfControl.Length; i++)
            {
                string[] temp = arrLocusOfControl[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }

            for (int i = 0; i < arrQuestionNo.Length; i++)
            {
                switch (int.Parse(arrQuestionNo[i]))
                {
                    case 1:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 2:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 3:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 4:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 5:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 6:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 7:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 8:
                        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                        break;
                    case 9:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                    case 10:
                        totalCount = totalCount + int.Parse(arrAnswer[i]);
                        break;
                }

            }

            if (totalCount <= 13)
            {
                testResult = "Low perceived stress";
            }

            else if (totalCount >= 14 && totalCount <= 26)
                testResult = "Moderate perceived stress";

            else
                testResult = "High perceived stress";

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure);

        }




        private int CalculateAnswer1(int answer) 
        {
            if (answer == 1)
            {
                return 2;
            }
            else 
                return 0;
        }

        private int CalculateAnswer2(int answer)
        {
            if (answer == 2)
            {
                return 2;
            }
            else
                return 0;
        }

        private int CalculateAnswerForPSSFinal(int answer)
        {
            if (answer == 1)
            {
                return 4;
            }
            else if (answer == 2)
                return 3;
            else if (answer == 3)
                return 2;
            else
                return 1;
        }


    }
}
