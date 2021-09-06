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
       
        public int Save_LocusOfControl(string[] arrLocusOfControl, int CrewID, int VesselID)
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
                switch (int.Parse(arrQuestionNo[i])) {
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
            return psychologicalEvaluationDAL.Save_LocusOfControl(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID);
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





        public int Save_BeckDepressionInventoryIIFinal(string[] arrBeckDepressionInventoryIIFinal, int CrewID, int VesselID)
        {
            string[] arrQuestionNo = new string[22];
            string[] arrAnswer = new string[22];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrBeckDepressionInventoryIIFinal.Length; i++)
            {
                string[] temp = arrBeckDepressionInventoryIIFinal[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }
            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.Save_BeckDepressionInventoryIIFinal(arrBeckDepressionInventoryIIFinal, CrewID, VesselID);
        }

        public int Save_EmotionalIntelligenceQuizForLeadership(string[] arrEmotionalIntelligenceQuizForLeadership, int CrewID, int VesselID)
        {
            string[] arrQuestionNo = new string[40];
            string[] arrAnswer = new string[40];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrEmotionalIntelligenceQuizForLeadership.Length; i++)
            {
                string[] temp = arrEmotionalIntelligenceQuizForLeadership[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }
            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.Save_EmotionalIntelligenceQuizForLeadership(arrEmotionalIntelligenceQuizForLeadership, CrewID, VesselID);
        }

        public int Save_InstructionsForPSSFinal(string[] arrInstructionsForPSSFinal, int CrewID, int VesselID)
        {
            string[] arrQuestionNo = new string[10];
            string[] arrAnswer = new string[10];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrInstructionsForPSSFinal.Length; i++)
            {
                string[] temp = arrInstructionsForPSSFinal[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }
            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.Save_InstructionsForPSSFinal(arrInstructionsForPSSFinal, CrewID, VesselID);
        }

        public int Save_MASSMindfulnessScaleFinal(string[] arrMASSMindfulnessScaleFinal, int CrewID, int VesselID)
        {
            string[] arrQuestionNo = new string[15];
            string[] arrAnswer = new string[15];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrMASSMindfulnessScaleFinal.Length; i++)
            {
                string[] temp = arrMASSMindfulnessScaleFinal[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }
            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.Save_MASSMindfulnessScaleFinal(arrMASSMindfulnessScaleFinal, CrewID, VesselID);
        }

        public int Save_PSQ30_PERCIEVED_STRESS_QUESTIONAIRE(string[] arrPSQ30_PERCIEVED_STRESS_QUESTIONAIRE, int CrewID, int VesselID)
        {
            string[] arrQuestionNo = new string[30];
            string[] arrAnswer = new string[30];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrPSQ30_PERCIEVED_STRESS_QUESTIONAIRE.Length; i++)
            {
                string[] temp = arrPSQ30_PERCIEVED_STRESS_QUESTIONAIRE[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }
            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.Save_PSQ30_PERCIEVED_STRESS_QUESTIONAIRE(arrPSQ30_PERCIEVED_STRESS_QUESTIONAIRE, CrewID, VesselID);
        }

        public int Save_ROSENBERG_SELF_esteem_scale_final(string[] arrROSENBERG_SELF_esteem_scale_final, int CrewID, int VesselID)
        {
            string[] arrQuestionNo = new string[10];
            string[] arrAnswer = new string[10];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrROSENBERG_SELF_esteem_scale_final.Length; i++)
            {
                string[] temp = arrROSENBERG_SELF_esteem_scale_final[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }
            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.Save_ROSENBERG_SELF_esteem_scale_final(arrROSENBERG_SELF_esteem_scale_final, CrewID, VesselID);
        }

        public int Save_Zhao_ANXIETY(string[] arrZhao_ANXIETY, int CrewID, int VesselID)
        {
            string[] arrQuestionNo = new string[40];
            string[] arrAnswer = new string[40];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int counter = 0;
            for (int i = 0; i < arrZhao_ANXIETY.Length; i++)
            {
                string[] temp = arrZhao_ANXIETY[i].Split('_');
                arrQuestionNo[counter] = temp[0];
                arrAnswer[counter] = temp[1];
                counter++;
            }
            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.Save_Zhao_ANXIETY(arrZhao_ANXIETY, CrewID, VesselID);
        }






        public PsychologicalEvaluationPOCO GetLocusOfControl(int VesselID, int CrewId)
        {
            PsychologicalEvaluationDAL dAL = new PsychologicalEvaluationDAL();
            return dAL.GetLocusOfControl(VesselID, CrewId);
        }
    }
}
