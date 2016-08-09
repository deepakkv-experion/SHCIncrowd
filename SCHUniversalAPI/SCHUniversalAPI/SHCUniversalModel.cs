using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Web;

namespace SCHUniversalAPI
{
    [DataContract]
    [KnownType(typeof(SHCUniversalModel))]
    public class SHCUniversalModel
    {
        [DataMember]
        public int queryid { get; set; }

        [DataMember]
        public int newrequiredN { get; set; }

        [DataMember]
        public string newhonorarium { get; set; }

        [DataMember]
        public string newincidence { get; set; }
    }
    
    [DataContract]
    public class ProjectStatusResponse
    {
        [DataMember]
        public bool success { get; set; }

        [DataMember]
        public List<ProjectStatusRequest> projectstatus { get; set; }
    }

    [DataContract]
    public class ProjectStatusRequest
    {
        [DataMember]
        public int queryid{ get; set; }

        [DataMember]
        public int invitationsent { get; set; }

        [DataMember]
        public int remaindersent { get; set; }

        [DataMember]
        public int numberofcompletes { get; set; }

        [DataMember]
        public string honorarium { get; set; }
    }
   

    [MessageContract]
    public class SuccessResponse
    {
        [MessageBodyMember]
        public string Status { get; set; }

        [MessageBodyMember]
        public string Message { get; set; }
    }
}