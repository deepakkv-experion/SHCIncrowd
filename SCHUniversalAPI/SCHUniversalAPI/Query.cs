using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.Web;

namespace SCHUniversalAPI
{

    public class Query
    {
        public string projectid { get; set; }

        public string reqn{ get; set; }

        public string specialty{ get; set; }

        public List<queryconditions> querycondition { get; set; }

        public List<string> exclusions { get; set; }


        //new requirement
        public List<string> exclusionidentifiers { get; set; }

        public List<string> inclusionnpi { get; set; }

        public List<string> inclusionidentifiers { get; set; }

        //new requirement
    }


    public class queryconditions
    {

        public string datapointid { get; set; }

        public List<string> datapointoptions { get; set; }
    }


    public class QueryResponse
    {

        public bool success { get; set; }


        public int queryid { get; set; }


        public int projectid { get; set; }


        public int feasibility { get; set; }



        //New requirement
        public int MaxAddressable { get; set; }

    }



    public class DeleteResponse
    {
        public bool success { get; set; }
    }


    public class ReminderResponse
    {
        public bool success { get; set; }
        public int queryid { get; set; }
    }
   
   
   

}