using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TM.Base.Entities
{
    public class TestValuesPOCO
    {
        private List<PreSignOffTestValuesPOCO> preSignOffTestValues;
        private List<PostJoiningTestValuesPOCO> postJoiningTestValues;

        public TestValuesPOCO()
        {
            preSignOffTestValues = new List<PreSignOffTestValuesPOCO>();
            postJoiningTestValues = new List<PostJoiningTestValuesPOCO>();
        }
        public List<PreSignOffTestValuesPOCO> PreSignOffTestValues { get; set; }
        public List<PostJoiningTestValuesPOCO> PostJoiningTestValues { get; set; }
    }
}