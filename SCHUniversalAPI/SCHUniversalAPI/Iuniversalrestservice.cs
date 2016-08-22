using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Web;
using System.ServiceModel.Channels;
using System.IO;

namespace SCHUniversalAPI
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "Iuniversalrestservice" in both code and config file together.
    [ServiceContract]
    public interface Iuniversalrestservice
    {
        [OperationContract]
        [WebInvoke(UriTemplate = "project", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Stream CreateProject(Project projectData);

        [OperationContract]
        [WebInvoke(UriTemplate = "project/{id}", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Stream UpdateProject(string id, Project projectData);

        [OperationContract]
        [WebInvoke(UriTemplate = "status", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Stream ChangeProjectStatus(ProjectStatus Status);

        [OperationContract]
        [WebInvoke(UriTemplate = "query", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Stream DefineQuery(Query QueryData);

        [OperationContract]
        [WebInvoke(UriTemplate = "query/{id}", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Stream DeleteQuery(string id);

        [OperationContract]
        [WebInvoke(UriTemplate = "reminder/{id}", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Stream SendReminder(string id);

        #region NewRequirement

        [OperationContract]
        [WebInvoke(UriTemplate = "updatedetails", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Stream UpdateQuery(SHCUniversalModel updatingValues);

        [OperationContract]
        [WebGet(UriTemplate = "getprojectstatus/{projectid}", BodyStyle = WebMessageBodyStyle.WrappedRequest, ResponseFormat = WebMessageFormat.Json, RequestFormat = WebMessageFormat.Json)]
        Stream GetProjectStatus(string projectId);

        #endregion
    }
}
