using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Web;

namespace SCHUniversalAPI
{
    [DataContract]
    public class Project
    {

        [DataMember]
        public string projectid { get; set; }

        [DataMember]
        public string name { get; set; }

        [DataMember]
        public string loi {get; set;}

        [DataMember]
        public string incidence {get; set;}

        [DataMember]
        public string surveylink {get; set;}

        [DataMember]
        public string emailsubject { get; set; }

        [DataMember]
        public string referencecode { get; set; }

        [DataMember]
        public string surveytopic { get; set; }

    }

    [DataContract]
    public class ProjectStatus
    {
        [DataMember]

        public string projectid { get; set; }

        [DataMember]

        public string statusid { get; set; }
    }

    [DataContract]
    public class ProjectResponse
    {
        [DataMember]
        public int projectid { get; set; }

        [DataMember]
        public bool success { get; set; }
    }

    [DataContract]
    public class ErrorResponse
    {
        [DataMember]
        public bool success { get; set; }

        [DataMember]
        public string error { get; set; }
    }
}