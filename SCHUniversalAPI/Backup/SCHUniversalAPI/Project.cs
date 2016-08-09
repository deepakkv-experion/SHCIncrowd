using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SCHUniversalAPI
{
    public class Project
    {
      public string name { get; set; }
      public string loi {get; set;}
      public string incidence {get; set;}
      public string surveylink {get; set;}
      public string emailsubject { get; set; }
      public string referencecode { get; set; }
      public string surveytopic { get; set; }

    }
    public class ProjectStatus
    {
        public string projectid { get; set; }
        public string statusid { get; set; }
    }
    public class ProjectResponse
    {
        public int projectid { get; set; }
        public bool success { get; set; }
    }
    public class ErrorResponse
    {
        public bool success { get; set; }
        public string error { get; set; }
    }
}