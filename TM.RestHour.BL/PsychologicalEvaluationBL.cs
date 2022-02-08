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
            string Evaluation = string.Empty;
            string SAEvaluation = string.Empty;
            string SCEvaluation = string.Empty;
            string EmpathyEvaluation = string.Empty;
            string RIEvaluation = string.Empty;

            switch (formId)
            {
                case 1:
                    result = SaveLocusOfControl(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId, Evaluation);
                    break;
                case 2:
                    result = SavePSSFinal(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId, Evaluation);
                    break;
                case 3:
                    result = SaveMASSMindfulnessScaleFinal(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId, Evaluation);
                    break;
                case 4:
                    result = SaveBeckDepressionInventoryIIFinal(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId, Evaluation);
                    break;
                case 5:
                    result = SavePSQ30_PERCIEVED_STRESS_QUESTIONAIRE(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId, Evaluation);
                    break;
                case 6:
                    result = SaveROSENBERG_SELF_esteem_scale_final(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId, Evaluation);
                    break;
                case 7:
                    result = SaveZhao_ANXIETY_Y1(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId, Evaluation);
                    break;
                case 8:
                    result = SaveZhao_ANXIETY_Y2(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId, Evaluation);
                    break;
                case 9:
                    result = SaveEmotionalIntelligenceQuizForLeadership(arrLocusOfControl, CrewID, VesselID, StoredProcedure, formId, SAEvaluation, SCEvaluation, EmpathyEvaluation, RIEvaluation);
                    break;
            }
            return result;
        }






        private int SaveLocusOfControl(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId, string Evaluation)
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
                testResult = "Internal Locus of Control";
                Evaluation = "The stronger your internal locus of control, the more rewarding you will find life. You will no longer feel the need to blame others or be fearful of doing interesting activities, and you will find those around you will admire your sense of self and how you now are the master of your destiny.";
            }
            else
            {
                testResult = "External Locus of Control";
                Evaluation = "1.Change the blame game : learn to take responsibility of the outcome of a situation rather than shifting the blame to someone or something other than you." +
                    "2.Take charge: when I make this happen”, “when they see my effort”, or “determination, not luck will take me to my future goals”." +
                    "3.Embrace failure; Take failure as an opportunity to learn; go out and do something that you know will result in failure.";
            }



            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure, Evaluation);
        }

        private int SavePSSFinal(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId, string Evaluation)
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
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure, Evaluation);

        }

        private int SaveMASSMindfulnessScaleFinal(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId, string Evaluation)
        {
            string[] arrQuestionNo = new string[15];
            string[] arrAnswer = new string[15];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            decimal score = 0; // Added on 19th Jan 2022 @BK

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
            //score = totalCount / arrQuestionNo.Length;

            score = Math.Round(decimal.Divide(Convert.ToDecimal( totalCount),Convert.ToDecimal( arrQuestionNo.Length)),2); // Added on 19th Jan 2022 @BK
            totalCount = totalCount / arrQuestionNo.Length;



            if (totalCount <= 4)
            {
                testResult = "Low level";
                Evaluation = "1. Meditate. Taking even just 5 minutes to sit quietly and follow your breath can help you feel more conscious and connected for the rest of your day." +
                    "2. Focus On One Thing At A Time. Studies have found that tasks take 50% longer with 50% more errors when multi-tasking, so consider “uni-tasking”, with breaks in between, whenever possible." +
                    "3. Slow Down. Savor the process, whether it’s writing a report, drinking a cup of tea, or cleaning out closets. Deliberate and thoughtful attention to daily actions promotes healthy focus and can keep you from feeling overwhelmed." +
                    "4. Eat Mindfully. Eating your meal without the TV, computer or paper in front of you, where you can truly taste and enjoy what you’re eating, is good, not only for your body, but for your soul as well." +
                    "5. Keep Phone and Computer Time In Check. With all of the media at our fingertips, we can easily be on information overload. Set boundaries for screen time – with designated times for social networking (even set an alarm) – and do your best to keep mobile devices out of reach at bedtime." +
                    "6. Move. Whether it’s walking, practicing yoga, or just stretching at your desk, become aware of your body’s sensations by moving." +
                    "7. Spend Time In Nature. Take walks through a park, the woods, mountain trails or by the beach – wherever you can be outside. Getting outdoors is good for body, mind and spirit, and keeps you in the present.";
            }

            else if (totalCount >= 5 && totalCount <= 6)
            {
                testResult = "High level";
                Evaluation = "1. Meditate. Taking even just 5 minutes to sit quietly and follow your breath can help you feel more conscious and connected for the rest of your day." +
                    "2. Focus On One Thing At A Time. Studies have found that tasks take 50% longer with 50% more errors when multi-tasking, so consider “uni-tasking”, with breaks in between, whenever possible." +
                    "3. Slow Down. Savor the process, whether it’s writing a report, drinking a cup of tea, or cleaning out closets. Deliberate and thoughtful attention to daily actions promotes healthy focus and can keep you from feeling overwhelmed." +
                    "4. Eat Mindfully. Eating your meal without the TV, computer or paper in front of you, where you can truly taste and enjoy what you’re eating, is good, not only for your body, but for your soul as well." +
                    "5. Keep Phone and Computer Time In Check. With all of the media at our fingertips, we can easily be on information overload. Set boundaries for screen time – with designated times for social networking (even set an alarm) – and do your best to keep mobile devices out of reach at bedtime." +
                    "6. Move. Whether it’s walking, practicing yoga, or just stretching at your desk, become aware of your body’s sensations by moving." +
                    "7. Spend Time In Nature. Take walks through a park, the woods, mountain trails or by the beach – wherever you can be outside. Getting outdoors is good for body, mind and spirit, and keeps you in the present.";
            }




            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            //return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure);// Commented on 19th Jan 2022 @BK
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, score, testResult, CrewID, VesselID, StoredProcedure, Evaluation); // Added on 19th Jan 2022 @BK

        }

        private int SaveBeckDepressionInventoryIIFinal(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId, string Evaluation)
        {
            string[] arrQuestionNo = new string[21];
            string[] arrAnswer = new string[21];
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
                totalCount = totalCount + (int.Parse(arrAnswer[i]) +1);

                #region Switch Case 

                //switch (int.Parse(arrQuestionNo[i]))
                //{
                //    case 1:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 2:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 3:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 4:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 5:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 6:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 7:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 8:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 9:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 10:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 11:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 12:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 13:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 14:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 15:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 16:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 17:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 18:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 19:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 20:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 21:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 22:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //}

                #endregion

            }

            if (totalCount <= 13)
            {
                testResult = "Minimal depression";
                Evaluation = "1.Recreational activities, which can offer distraction and social interaction." +
                    "2.Relaxation and meditation." +
                    "3.Sleep habits.";
            }
            else if (totalCount >= 14 && totalCount <= 19)
            { 
                testResult = "Mild depression";
                Evaluation = "1.Change in Diet." +
                    "2.Increase exercise levels." +
                    "3.Recreational activities, which can offer distraction and social interaction." +
                    "4.Music therapy." +
                    "5.Relaxation and meditation." +
                    "6.Sleep habits." +
                    "7.contact with other people, especially if they can offer emotional support." +
                    "8.Interacting with pets and animals." +
                    "9.Reducing the use of alcohol and tobacco.";
            }
            else if (totalCount >= 20 && totalCount <= 28)
            {
                testResult = "Moderate depression";
                Evaluation = "1.Recreational activities, which can offer distraction and social interaction." +
                    "2.Music therapy." +
                    "3.Relaxation and meditation." +
                    "4.Sleep habits." +
                    "Seek Medical Advice.";
            }
            else
            {
                testResult = "Severe depression";
                Evaluation = "Seek medical Advice";
            }
                

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure, Evaluation);

        }

        private int SavePSQ30_PERCIEVED_STRESS_QUESTIONAIRE(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId, string Evaluation)
        {
            string[] arrQuestionNo = new string[30];
            string[] arrAnswer = new string[30];
            int totalCount = 0; // 13578
            string testResult = string.Empty;

            int psq_mean = 0;
            decimal psq = 0;

            int scaleRank = 0;// Added on 19th Jan 2022 @BK

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

            scaleRank = Convert.ToInt32( Math.Round(psq));// Added on 19th Jan 2022 @BK

            if (scaleRank <= 30)
            {
                testResult = "Low perceived stress";
                Evaluation = "";
            }
            else if (scaleRank >= 31 && scaleRank <= 60)
            {
                testResult = "Moderate perceived stress";
                Evaluation = "";
            }
            else if (scaleRank >= 61 && scaleRank <= 100)
            {
                testResult = "High perceived stress";
                Evaluation = "";
            }

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            //return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, psq, testResult, CrewID, VesselID, StoredProcedure);// Commented on 19th Jan 2022 @BK

            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, scaleRank, testResult, CrewID, VesselID, StoredProcedure, Evaluation);// Added on 19th Jan 2022 @BK

        }

        private int SaveROSENBERG_SELF_esteem_scale_final(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId, string Evaluation)
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

            if (totalCount >= 0 && totalCount <= 20)
            {
                testResult = "Low";
                Evaluation = "1.Be kind to yourself add. Recognise and challenge your unkind thoughts." +
                    "2.Look after yourself." +
                    "3.Focus on the positives." +
                    "4.Spend time with people." +
                    "5.Learn to assert yourself." +
                    "6.Do things you enjoy." +
                    "7.Act confident when you don't feel it." +
                    "8.Try something new.";
            }
            else if (totalCount >= 21 && totalCount <= 30)
            {
                testResult = "Moderate";
                Evaluation = "1.Recognize what you're good at." +
                    "2.Build positive relationships." +
                    "3.Be kind to yourself." +
                    "4.Learn to be assertive." +
                    @"5.Start saying ""no"" ";
            }
            else
            {
                testResult = "High";
                Evaluation = "";
            }

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure, Evaluation);

        }

        private int SaveZhao_ANXIETY_Y1(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId, string Evaluation)
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

            if (totalCount >= 20 && totalCount <= 37)
            {
                testResult = "No Anxiety";
                Evaluation = "";
            }
            else if (totalCount >= 38 && totalCount <= 44)
            {
                testResult = "Mild";
                Evaluation = "";
            }
            else if (totalCount >= 45 && totalCount <= 54)
            {
                testResult = "Moderate Anxiety";
                Evaluation = "";
            }
            else
            {
                testResult = "Severe Anxiety";
                Evaluation = "";
            }

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure, Evaluation);

        }

        private int SaveZhao_ANXIETY_Y2(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId, string Evaluation)
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

            if (totalCount >= 20 && totalCount <= 37)
            {
                testResult = "No Anxiety";
                Evaluation = "";
            }
            else if (totalCount >= 38 && totalCount <= 44)
            {
                testResult = "Mild";
                Evaluation = "";
            }
            else if (totalCount >= 45 && totalCount <= 54)
            {
                testResult = "Moderate Anxiety";
                Evaluation = "";
            }
            else
            {
                testResult = "Severe Anxiety";
                Evaluation = "";
            }

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalCount, testResult, CrewID, VesselID, StoredProcedure, Evaluation);

        }

        private int SaveEmotionalIntelligenceQuizForLeadership(string[] arrLocusOfControl, int CrewID, int VesselID, string StoredProcedure, int formId, string SAEvaluation, string SCEvaluation, string EmpathyEvaluation, string RIEvaluation)
        {
            string[] arrQuestionNo = new string[40];
            string[] arrAnswer = new string[40];
            int totalCount = 0; // 13578
            int[] totalScore = new int[4];
            string[] allResults = new string[4];

            int totalOfSelfAwerness = 0;
            int totalOfSelfControl = 0;
            int totalOfEmpathy = 0;
            int totalOfRespondingIntegrity = 0;

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
                #region Switch Case Commented
                //switch (int.Parse(arrQuestionNo[i]))
                //{
                //    case 1:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 2:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 3:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 4:
                //        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                //        break;
                //    case 5:
                //        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                //        break;
                //    case 6:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 7:
                //        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                //        break;
                //    case 8:
                //        totalCount = totalCount + CalculateAnswerForPSSFinal(int.Parse(arrAnswer[i]));
                //        break;
                //    case 9:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //    case 10:
                //        totalCount = totalCount + int.Parse(arrAnswer[i]);
                //        break;
                //}

                #endregion

                totalCount = totalCount + int.Parse(arrAnswer[i]);

                if (int.Parse(arrQuestionNo[i]) <= 10)
                {
                    totalOfSelfAwerness = totalOfSelfAwerness + int.Parse(arrAnswer[i]);
                }
                else if (int.Parse(arrQuestionNo[i]) >= 11 && int.Parse(arrQuestionNo[i]) <= 20)
                {
                    totalOfSelfControl = totalOfSelfControl + int.Parse(arrAnswer[i]);
                }
                else if (int.Parse(arrQuestionNo[i]) >= 21 && int.Parse(arrQuestionNo[i]) <= 30)
                {
                    totalOfEmpathy = totalOfEmpathy + int.Parse(arrAnswer[i]);
                }
                else if (int.Parse(arrQuestionNo[i]) >= 31 && int.Parse(arrQuestionNo[i]) <= 40)
                {
                    totalOfRespondingIntegrity = totalOfRespondingIntegrity + int.Parse(arrAnswer[i]);
                }


            }

            #region SA
            totalScore[0] = totalOfSelfAwerness;
            if (totalOfSelfAwerness <= 24)
            {
                allResults[0] = "Area for Enrichment: Requires attention and development";
                SAEvaluation = "Self-Awareness " +
                    "1.Keep an Emotions Diary." +
                    "2.Set an Awareness Trigger." +
                    "3.Develop Your Feelings." +
                    "4.Know Who and What Pushes Your Buttons." +
                    "5.Ask Yourself Why You Do the Things You Do." +
                    "6.Don't Treat Your Feelings as Good or Bad." +
                    "7.Draw a timeline of your life." +
                    "8.Ask for feedback (and take it well)." +
                    "9.Do some micro-travel." +
                    "10.Identify cognitive distortions.";
            }

            else if (totalOfSelfAwerness >= 25 && totalOfSelfAwerness <= 34)
            {
                allResults[0] = "Effective Functioning: Consider Strengthenin";
                SAEvaluation = "Self-Awareness." +
                    "1.Pay attention to what bothers you about other people." +
                    "2.Meditate on your mind." +
                    "3.Read high-quality fiction." +
                    "4.Learn a new skill." +
                    "5.Make time to clarify your values.";
            }

            else
            { 
                allResults[0] = "Enhanced Skills: Use as leverage to develop weaker area";
                SAEvaluation = "Self-Awareness:" +
                    "Enhanced Skills:" +
                    "Use as leverage to develop weaker areas";
            }

            #endregion

            #region SC

            totalScore[1] = totalOfSelfControl;
            if (totalOfSelfControl <= 24)
            {
                allResults[1] = "Area for Enrichment: Requires attention and development";
                SCEvaluation = "Self-Control." +
                    "1.Remove temptation." +
                    "2.Measure Your Progress." +
                    "3.Learn How To Manage Stress." +
                    "4.Prioritize Things." +
                    "5.Forgive Yourself.";
            }

            else if (totalOfSelfControl >= 25 && totalOfSelfControl <= 34)
            {
                allResults[1] = "Effective Functioning: Consider Strengthenin";
                SCEvaluation = "Self-Control." +
                    "1.Increase your capacity for pressure: Learn how to manage stress." +
                    "2.Encourage yourself to stick to your plan." +
                    "3.Get more sleep to help your brain manage energy better." +
                    "4.Better exercise and nutrition." +
                    "5.Meditate.";
            }
            else
            { 
                allResults[1] = "Enhanced Skills: Use as leverage to develop weaker area";
                SCEvaluation = "Self-Control:" +
                    "Enhanced Skills:" +
                    "Use as leverage to develop weaker areas";
            }
            #endregion

            #region Empathy
            totalScore[2] = totalOfEmpathy;
            if (totalOfEmpathy <= 24)
            {
                allResults[2] = "Area for Enrichment: Requires attention and development";
                EmpathyEvaluation = "Empathy." +
                    "1.Challenge yourself." +
                    "2.Get out of your usual environment." +
                    "3.Get feedback." +
                    "4.Explore the heart not just the head." +
                    "5.Walk in others’ shoes." +
                    "6.Examine your biases." +
                    "7.Cultivate your sense of curiosity." +
                    "8.Ask better questions.";
            }
            else if (totalOfEmpathy >= 25 && totalOfEmpathy <= 34)
            {
                allResults[2] = "Effective Functioning: Consider Strengthenin";
                EmpathyEvaluation = "Empathy." +
                    "1.Get feedback." +
                    "2.Explore the heart not just the head." +
                    "3.Walk in others’ shoes." +
                    "4.Examine your biases.";
            }
            else
            { 
                allResults[2] = "Enhanced Skills: Use as leverage to develop weaker area";
                EmpathyEvaluation = "Empathy:" +
                    "Enhanced Skills:" +
                    "Use as leverage to develop weaker areas";
            }
            #endregion

            #region RI
            totalScore[3] = totalOfRespondingIntegrity;
            if (totalOfRespondingIntegrity <= 24)
            {
                allResults[3] = "Area for Enrichment: Requires attention and development";
                RIEvaluation = "Responding with Integrity." +
                    "1.Show up ready to work." +
                    "2.Set a positive example." +
                    "3.Be respectful during conflict." +
                    "4.Practice accountability." +
                    "5.Follow and enforce company policies." +
                    "6.Improve your work ethic." +
                    "7.Respect property.";
            }
            else if (totalOfRespondingIntegrity >= 25 && totalOfRespondingIntegrity <= 34)
            {
                allResults[3] = "Effective Functioning: Consider Strengthenin";
                RIEvaluation = "Responding with Integrity." +
                    "1.Set a positive example." +
                    "2.Be respectful during conflict." +
                    "3.Practice accountability." +
                    "4.Respect property.";
            }
            else
            {
                allResults[3] = "Enhanced Skills: Use as leverage to develop weaker area";
                RIEvaluation = "Responding with Integrity:" +
                    "Enhanced Skills:" +
                    "Use as leverage to develop weaker areas";
            }

            #endregion

            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            //return 1;
            return psychologicalEvaluationDAL.SaveForms(arrQuestionNo, arrAnswer, totalScore, allResults, CrewID, VesselID, StoredProcedure, SAEvaluation, SCEvaluation, EmpathyEvaluation, RIEvaluation);

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





        public PsychologicalEvaluationPOCO GetLocusOfControlByJoiningCondition(int CrewId, int JoiningCondition)
        {
            PsychologicalEvaluationDAL psychologicalEvaluationDAL = new PsychologicalEvaluationDAL();
            return psychologicalEvaluationDAL.GetLocusOfControlByJoiningCondition(CrewId, JoiningCondition);
        }
    }
}
