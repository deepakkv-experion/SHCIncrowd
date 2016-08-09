using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Web;
using System.ServiceModel.Channels;

namespace SCHUniversalAPI
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "Iuniversalrestservice" in both code and config file together.
    [ServiceContract]
    public interface Iuniversalrestservice
    {
        [OperationContract]
        [WebInvoke(UriTemplate = "project", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Message CreateProject(Project projectData);

        [OperationContract]
        [WebInvoke(UriTemplate = "project/{id}", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Message UpdateProject(string id, Project projectData);

        [OperationContract]
        [WebInvoke(UriTemplate = "status", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Message ChangeProjectStatus(ProjectStatus Status);

        [OperationContract]
        [WebInvoke(UriTemplate = "query", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Message DefineQuery(Query QueryData);

        [OperationContract]
        [WebInvoke(UriTemplate = "query/{id}", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Message DeleteQuery(string id);

        [OperationContract]
        [WebInvoke(UriTemplate = "reminder/{id}", Method = "POST", BodyStyle = WebMessageBodyStyle.Bare, RequestFormat = WebMessageFormat.Json, ResponseFormat = WebMessageFormat.Json)]
        Message SendReminder(string id);
    }
}
