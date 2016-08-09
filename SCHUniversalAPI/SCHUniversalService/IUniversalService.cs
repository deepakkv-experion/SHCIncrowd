using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Web;
using System.Text;

namespace SCHUniversalService
{
    [ServiceContract]
    public interface IUniversalService
    {
        [OperationContract]
        [WebInvoke(Method = "POST", UriTemplate = "updatequery", BodyStyle = WebMessageBodyStyle.Bare, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Stream UpdateQuery(SHCUniversalModel updatingValues);

        [OperationContract]
        [WebGet( UriTemplate = "getprojectstatus/{projectid}", BodyStyle = WebMessageBodyStyle.WrappedRequest, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Stream GetProjectStatus(string projectId);
    }
}
