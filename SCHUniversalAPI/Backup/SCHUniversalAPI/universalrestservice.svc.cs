using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using System.IO;
using System.Web;
using System.ServiceModel.Web;
using System.Net;
using System.ServiceModel.Channels;


namespace SCHUniversalAPI
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "universalrestservice" in code, svc and config file together.
    public class universalrestservice : Iuniversalrestservice
    {
        public Message CreateProject(Project projectData)
        {
            int logId = 0;
            string response = string.Empty;

            WriteToLog(" In CreateProject", "L2");

            if (AuthorizeRequest())
            {
                if (projectData != null)
                {
                    if (projectData.name != null && projectData.incidence != null && projectData.loi != null && projectData.surveylink != null && Convert.ToInt32(projectData.loi) <= Convert.ToInt32(ConfigurationManager.AppSettings["MaxLOI"]))
                    {
                        if (Convert.ToInt32(projectData.incidence) > 0)
                        {
                            logId = SaveRequestResponseLog("0", JsonConvert.SerializeObject(projectData));
                            response = SaveProject("0", projectData);
                        }
                        else
                        {
                            WriteToLog("CreateProject: Incidence is less than zero", "L1");
                            response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["ValIncidence"]);
                        }
                    }
                    else
                    {
                        WriteToLog("CreateProject: Invalid data", "L1");
                        response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["InvalidData"]);
                    }
                }
                else
                {
                    WriteToLog("CreateProject: NULL data", "L1");
                    response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["InvalidData"]);
                }

            }
            else
            {
                
                WriteToLog("CreateProject: Authorization Failed", "L1");
                response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["AuthError"]);
            }
            SaveRequestResponseLog(logId.ToString(), response);

            return ParseJsonMessage(response);
          //  return response;
        }
        public Message UpdateProject(string projectId, Project projectData)
        {
            string response = string.Empty;
            int logId = 0;

            WriteToLog(" In UpdateProject", "L2");

            if (AuthorizeRequest())
            {
                if (projectData != null)
                {
                    if (projectId != null && projectId != "0" && projectData.name != null && projectData.incidence != null && projectData.loi != null && projectData.surveylink != null)
                    {
                        logId = SaveRequestResponseLog("0", JsonConvert.SerializeObject(projectData));
                        response = SaveProject(projectId, projectData);
                    }
                    else
                    {
                        WriteToLog("UpdateProject: Invalid data", "L1");
                        response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["InvalidData"]);
                    }
                }
                else
                {
                    WriteToLog("UpdateProject: NULL data", "L1");
                    response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["InvalidData"]);
                }
            }
            else
            {
                WriteToLog("UpdateProject: Authorization Failed", "L1");
                response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["AuthError"]);
            }

            SaveRequestResponseLog(logId.ToString(), response);

            return ParseJsonMessage(response);
        }
        public Message ChangeProjectStatus(ProjectStatus status)
        {
            string response = string.Empty;
            int logId = 0;

            WriteToLog(" In ChangeProjectStatus", "L2");

            if (AuthorizeRequest())
            {
                if (status != null)
                {
                    if (status.projectid != null && status.statusid != null)
                    {
                        logId = SaveRequestResponseLog("0", JsonConvert.SerializeObject(status));
                        if (status.statusid == "3" || status.statusid == "1")
                        {
                            response = UpdateProjectStatus(status.projectid, status);
                        }
                        else
                        {
                            response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["InvalidStatusData"]);
                        }
                    }
                    else
                    {
                        WriteToLog("ChangeProjectStatus: Invalid data", "L1");
                        response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["InvalidData"]);
                    }
                }
                else
                {
                    WriteToLog("ChangeProjectStatus: NULL data", "L1");
                    response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["InvalidData"]);
                }
            }
            else
            {
                WriteToLog("ChangeProjectStatus: Authorization Failed", "L1");
                response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["AuthError"]);
            }

            SaveRequestResponseLog(logId.ToString(), response);

            return ParseJsonMessage(response);
            
        }
        public Message DefineQuery(Query queryData)
        {
            string response = string.Empty;
            int logId = 0;

            WriteToLog("In DefineQuery", "L2");            
            if (AuthorizeRequest())
            {
                if (queryData != null)
                {
                   
                      if (queryData.projectid == null || queryData.projectid == "0")
                       {
                           WriteToLog("DefineQuery: Invalid Project Id", "L1");
                           response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["ValProjectId"]);
                       }
                      else if (!queryData.querycondition.Where(item => item.datapointid == ConfigurationManager.AppSettings["SpecialtyId"]).Any())
                       {
                           WriteToLog("DefineQuery: Invalid Specialty", "L1");
                           response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["ValSpeciality"]);
                       }
                      else if (queryData.querycondition.FirstOrDefault(item => item.datapointid == ConfigurationManager.AppSettings["SpecialtyId"]).datapointoptions.Count > 1)
                      {
                          WriteToLog("DefineQuery: Multiple Specialty", "L1");
                          response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["MultipleSpecialty"]);
                      }
                      else if (queryData.querycondition == null || queryData.querycondition.Count <= 0 || queryData.querycondition[0].datapointoptions.Count <= 0 || queryData.querycondition[0].datapointid == null)
                      {
                          WriteToLog("DefineQuery: Invalid Query Condition", "L1");
                          response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["ValQueryCondition"]);
                      }
                      else if (queryData.reqn == null || queryData.reqn == "0")
                      {
                          WriteToLog("DefineQuery: Invalid Req N", "L1");
                          response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["ValQueryCondition"]);
                      }
                      else
                      {
                          logId = SaveRequestResponseLog("0", JsonConvert.SerializeObject(queryData));
                          response = GenerateAndSaveQuery(queryData);
                      }
                    
                }
                else
                {
                    WriteToLog("DefineQuery: NULL data", "L1");
                    response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["InvalidData"]);
                }
            }
            else
            {
                WriteToLog("DefineQuery: Authorization Failed", "L1");
                response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["AuthError"]);
            }

            SaveRequestResponseLog(logId.ToString(), response);

            return ParseJsonMessage(response);
        }
        public Message DeleteQuery(string queryId)
        {
            
            string response = string.Empty;
            int logId = 0;

            WriteToLog("In DeleteQuery", "L2");

            if (AuthorizeRequest())
            {
                if (queryId != null && queryId != string.Empty)
                {
                    logId = SaveRequestResponseLog("0", queryId);
                    response = DeleteQueryDetails(queryId);
                }
                else
                {
                    WriteToLog("DeleteQuery: Invalid data", "L1");
                    response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["InvalidData"]);
                }
            }
            else
            {
                WriteToLog("DeleteQuery: Authorization Failed", "L1");
                response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["AuthError"]);
            }

            SaveRequestResponseLog(logId.ToString(), response);
            return ParseJsonMessage(response);
        }
        public Message SendReminder(string queryId)
        {

            string response = string.Empty;
            int logId = 0;

            WriteToLog("In SendReminder", "L2");

            if (AuthorizeRequest())
            {
                if (queryId != null && queryId != string.Empty)
                {
                    logId = SaveRequestResponseLog("0", queryId);
                    response = SaveReminderToDB(queryId);
                }
                else
                {
                    WriteToLog("SendReminder: Invalid data", "L1");
                    response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["InvalidData"]);
                }
            }
            else
            {
                WriteToLog("SendReminder: Authorization Failed", "L1");
                response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["AuthError"]);
            }

            SaveRequestResponseLog(logId.ToString(), response);
            return ParseJsonMessage(response);
        }

       
        #region DBCall
        private string SaveReminderToDB(string queryId)
        {
            string response = string.Empty;
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conUniversal"].ToString());
            try
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SaveReminder", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@QueryId", queryId));
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataSet dsReminder = new DataSet();
                adapter.Fill(dsReminder);
                if (dsReminder.Tables.Count > 0)
                {
                    if (dsReminder.Tables[0].Rows.Count > 0)
                    {
                        if (dsReminder.Tables[0].Rows[0][0].ToString() == "true")
                        {
                            ReminderResponse reminder = new ReminderResponse();
                            reminder.queryid = Convert.ToInt32(queryId);
                            reminder.success = true;
                            response = JsonConvert.SerializeObject(reminder);
                        }
                        else
                        {
                            response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["ReminderError"]);
                        }

                    }
                    else
                    {
                        response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["QueryError"]);
                    }
                }
                else
                {
                    response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["QueryError"]);
                }

            }
            catch (Exception ex)
            {

                WriteToLog("Error in SaveReminderToDB: " + ex.Message, "L1");
                response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["QueryError"]); 
            }

            return response;
        }
        public string SaveProject(string projectId, Project ProjectData)
        {
            string response = string.Empty;
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conUniversal"].ToString());
            DataSet dsProject = new DataSet();
           
            try
            {
                WriteToLog("In SaveProject: " + projectId, "L2");
                con.Open();
                SqlCommand cmd = new SqlCommand("SaveProject", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@ProjectId", projectId));
                cmd.Parameters.Add(new SqlParameter("@ProjectName", ProjectData.name));
                cmd.Parameters.Add(new SqlParameter("@LOI", ProjectData.loi));
                cmd.Parameters.Add(new SqlParameter("@Incidence", ProjectData.incidence));
                cmd.Parameters.Add(new SqlParameter("@SurveyLink", ProjectData.surveylink));
                cmd.Parameters.Add(new SqlParameter("@EmailSubject", ProjectData.emailsubject));
                cmd.Parameters.Add(new SqlParameter("@SurveyTopic", ProjectData.surveytopic));
                cmd.Parameters.Add(new SqlParameter("@ReferenceCode", ProjectData.referencecode));
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dsProject);
                if (dsProject.Tables.Count > 0)
                {
                    if (dsProject.Tables[0].Rows.Count > 0)
                    {
                        if (dsProject.Tables[0].Rows[0][0].ToString() != "false")
                        {
                            response = GenerateProjectResponseJson(dsProject.Tables[0].Rows[0][0].ToString());
                        }
                        else
                        {
                            response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["UpdateVal"]);
                        }

                    }
                    else
                    {
                        response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["ProjectError"]);
                    }
                }

            }
            catch (Exception ex)
            {
                WriteToLog("Error in SaveProject: " + ex.Message, "L1");
                response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["ProjectError"]); 
            }
            finally
            {
              
                con.Close();
            }
            return response;
        }
        public string GenerateAndSaveQuery(Query queryData)
        {
            string response = "false";
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conUniversal"].ToString());
          
            try
            {
                WriteToLog("In GenerateAndSaveQuery: ", "L2");
               // string datapointValues = string.Empty;
                string queryCondition = string.Empty;
                string datapointId = string.Empty;
                int exclusionCount;

                DataSet dsQuery = new DataSet();
                if (queryData != null && queryData.querycondition.Where(item => item.datapointid == ConfigurationManager.AppSettings["SpecialtyId"]).Any() && queryData.projectid != null)
                {

                    for (int i = 0; i < queryData.querycondition.Count; i++)
                    {
                        //  datapointValues = string.Join(",", queryData.querycondition[i].datapointoptions);
                        string datapointValues = string.Empty;
                        foreach (var option in queryData.querycondition[i].datapointoptions)
                        {
                            datapointValues = datapointValues + "'" + option + "',";
                        }

                        datapointValues = datapointValues.Remove(datapointValues.Length - 1);
                        if (queryCondition == string.Empty)
                        {
                            queryCondition = " (DataPointId = " + queryData.querycondition[i].datapointid + " AND OptionId IN(" + datapointValues + ") ) ";
                        }
                        else
                        {
                            queryCondition = queryCondition + "AND EXISTS (SELECT * FROM PanelistMaster P" + i + " WHERE P.Identifier=P" + i + ".Identifier AND DataPointId = " + queryData.querycondition[i].datapointid + " AND OptionId IN(" + datapointValues + ")) ";
                        }
                    }

                   // queryCondition = queryCondition + " AND " + ConfigurationManager.AppSettings["SpecializationDatapoint"] + " = 10 AND Option = " + queryData.specialty;
                }
                if (queryData.exclusions != null && queryData.exclusions.Count > 0)
                {
                    exclusionCount = queryData.exclusions.Count;
                    string exclusion = string.Empty;
                    foreach (var excl in queryData.exclusions)
                    {
                        exclusion = exclusion + "'" + excl + "',";
                    }

                    exclusion = exclusion.Remove(exclusion.Length - 1);
                    if (queryCondition != string.Empty)
                    {
                        queryCondition = queryCondition + "AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = " + ConfigurationManager.AppSettings["ExclusionId"] + " AND OptionId IN(" + exclusion + ")) ";
                    }
                    else
                    {
                        queryCondition = " (DataPointId != " + ConfigurationManager.AppSettings["ExclusionId"] + " AND OptionId NOT IN(" + exclusion + ") ) ";
                    }

                }
                else
                {
                    exclusionCount = 0;
                }

                con.Open();

                SqlCommand cmd = new SqlCommand("SaveQueryAndGetProjectStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["CommandTimeOut"]);
                cmd.Parameters.Add(new SqlParameter("@ProjectId", queryData.projectid));
                cmd.Parameters.Add(new SqlParameter("@Query", queryCondition));
                cmd.Parameters.Add(new SqlParameter("@ReqN", queryData.reqn));
                cmd.Parameters.Add(new SqlParameter("@JsonText", JsonConvert.SerializeObject(queryData)));
                string specialty = queryData.querycondition.FirstOrDefault(item => item.datapointid == ConfigurationManager.AppSettings["SpecialtyId"]).datapointoptions[0];
                cmd.Parameters.Add(new SqlParameter("@Speciality", specialty));
                cmd.Parameters.Add(new SqlParameter("@ExclusionCount", exclusionCount));
            
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dsQuery);
                if (dsQuery.Tables.Count > 0)
                {
                    if (dsQuery.Tables[0].Rows.Count > 0)
                    {
                        if (dsQuery.Tables[0].Rows[0][0].ToString() == "close")
                        {
                           response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["QueryVal"]);
                        }
                        else if (dsQuery.Tables[0].Rows[0][0].ToString() == "noproject")
                        {
                           response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["NoProject"]);
                        }
                        else
                        {
                           response = SaveRespondents(dsQuery.Tables[0].Rows[0][0].ToString(), queryData.projectid, queryData.reqn, queryCondition);
                        }
                    }
                    else
                    {

                        response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["QueryError"]);
                    }
                }

            }
            catch (Exception ex)
            {
                WriteToLog("Error in GenerateAndSaveQuery: " + ex.Message, "L1");
                response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["QueryError"]);
            }
            finally
            {
                con.Close();
            }
            return response;
            
        }
        public string UpdateProjectStatus(string projectId, ProjectStatus Status)
        {
            string status=string.Empty;
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conUniversal"].ToString());
            DataSet dsProject = new DataSet();
            
            try
            {

                WriteToLog("In UpdateProjectStatus: " + projectId, "L2");
                con.Open();
                SqlCommand cmd = new SqlCommand("ChangeProjectStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@ProjectId", projectId));
                cmd.Parameters.Add(new SqlParameter("@StatusId", Status.statusid));
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dsProject);
                if (dsProject.Tables.Count > 0)
                {
                    if (dsProject.Tables[0].Rows.Count > 0)
                    {
                        if (dsProject.Tables[0].Rows[0][0].ToString() == projectId)
                        {
                            status = GenerateProjectResponseJson(projectId);
                        }
                        else
                        {
                            string currentStatus = dsProject.Tables[0].Rows[0][0].ToString();
                            if (currentStatus == "4")
                            {
                                status = GenerateErrorResponseJson(ConfigurationManager.AppSettings["StatusVal"]);
                            }
                        }
                    }
                    else
                    {
                        status = GenerateErrorResponseJson(ConfigurationManager.AppSettings["ProjectStatus"]);
                    }
                }
               
            }
            catch (Exception ex)
            {
                WriteToLog("Error in UpdateProjectStatus: " + ex.Message, "L1");
                status = GenerateErrorResponseJson(ConfigurationManager.AppSettings["ProjectStatus"]);
            }
            finally
            {
                con.Close();
            }
            return status;
        }
        public string DeleteQueryDetails(string queryId)
        {
            string response  = string.Empty;
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conUniversal"].ToString());
            DataSet dsStatus = new DataSet();
            try
            {
                WriteToLog("In DeleteQueryDetails: " + queryId, "L2");
                con.Open();
                SqlCommand cmd = new SqlCommand("DeleteQuery", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@QueryId", queryId));
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dsStatus);
                if (dsStatus.Tables.Count > 0)
                {
                    if (dsStatus.Tables[0].Rows.Count > 0)
                    {
                        if (dsStatus.Tables[0].Rows[0][0].ToString() == "true")
                        {
                            DeleteResponse delete = new DeleteResponse();
                            delete.success = true;
                            response = JsonConvert.SerializeObject(delete);
                        }
                        else
                        {
                            response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["QueryDeleteVal"]);
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                WriteToLog("Error in DeleteQueryDetails: " + ex.Message, "L1");
                response = GenerateErrorResponseJson(ConfigurationManager.AppSettings["QueryDeleteError"]);
            }
            return response;
        }
        public string SaveRespondents(string queryId, string projectId, string reqN, string queryCondition)
        {
            string responseJson = string.Empty;          
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conUniversal"].ToString());
            DataSet dsFeasibility = new DataSet();
            try
            {

                WriteToLog("In SaveRespondentList: " + projectId, "L2");
                con.Open();
                SqlCommand cmd = new SqlCommand("SaveRespondentList", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["CommandTimeOut"]);
                cmd.Parameters.Add(new SqlParameter("@ProjectId", projectId));
                cmd.Parameters.Add(new SqlParameter("@QueryId", queryId));
                cmd.Parameters.Add(new SqlParameter("@ReqN", reqN));
                cmd.Parameters.Add(new SqlParameter("@RR", ConfigurationManager.AppSettings["RR"]));
                cmd.Parameters.Add(new SqlParameter("@QueryCondition", queryCondition));
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dsFeasibility);
                if (dsFeasibility.Tables.Count > 0)
                {
                    if (dsFeasibility.Tables[0].Rows.Count > 0)
                    {
                        responseJson = GenerateQueryResponseJson(projectId, queryId, dsFeasibility.Tables[0].Rows[0][0].ToString());
                    }
                    else
                    {
                        responseJson = GenerateErrorResponseJson(ConfigurationManager.AppSettings["QueryError"]);
                    }
                }
             
            }
            catch (Exception ex)
            {
                WriteToLog("Error in SaveRespondentList: " + ex.Message, "L1");
                responseJson = GenerateErrorResponseJson(ConfigurationManager.AppSettings["QueryError"]);
            }
            finally
            {
                con.Close();
            }
            return responseJson;
        }
        private void WriteToLog(string contents, string logLevel)
        {
            string configLogLevel = Convert.ToString(ConfigurationManager.AppSettings["LogLevel"] ?? "L1");

            if ((configLogLevel == "L1" && logLevel == "L1") || (configLogLevel == "L2"))
            {
                string folder = Path.GetFullPath(Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "Log"));
                string filePath = folder + "\\Log.txt";

                if (!System.IO.Directory.Exists(folder))
                {
                    System.IO.Directory.CreateDirectory(folder);
                }

                if (File.Exists(filePath))
                {
                    FileInfo info = new FileInfo(filePath);
                    if (info.Length > 2097152)
                    {
                        File.Delete(filePath);
                        File.Create(filePath).Close();
                    }
                }
                else
                {
                    File.Create(filePath).Close();
                }

                using (StreamWriter w = File.AppendText(filePath))
                {
                    w.WriteLine("\r\nLog Entry : " + DateTime.Now.ToString());
                    w.WriteLine(contents);
                    w.WriteLine("__________________________");
                    w.Flush();
                    w.Close();
                }
            }
        }
        public string GenerateErrorResponseJson(string error)
        {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.success = false;
            errorResponse.error = error;
            return JsonConvert.SerializeObject(errorResponse);
        }
        public string GenerateProjectResponseJson(string projectId)
        {
            ProjectResponse projectResponse = new ProjectResponse();
            projectResponse.success = true;
            projectResponse.projectid = Convert.ToInt32(projectId);
            return JsonConvert.SerializeObject(projectResponse);

        }
        public string GenerateQueryResponseJson(string projectId,string queryId,string feasibility)
        {
            QueryResponse queryResponse = new QueryResponse();
            queryResponse.success = true;
            queryResponse.projectid = Convert.ToInt32(projectId);
            queryResponse.queryid = Convert.ToInt32(queryId);
            queryResponse.feasibility = Convert.ToInt32(feasibility);

            return JsonConvert.SerializeObject(queryResponse);

        }
        public bool AuthorizeRequest()
        {
            bool status = false;
            try
            {
                WriteToLog("In AuthorizeRequest", "L2");
                IncomingWebRequestContext request = WebOperationContext.Current.IncomingRequest;
                WebHeaderCollection headers = request.Headers;
                if (ConfigurationManager.AppSettings["Authorization"] == headers["Authorization"])
                {
                    status = true;
                }

            }
            catch (Exception ex)
            {
                WriteToLog("Error in AuthorizeRequest: " + ex.Message, "L1");
            }
            return status;
        }
        public int SaveRequestResponseLog(string LogId,string JsonText)
        {
            int logId = 0;
            WriteToLog("In SaveRequestResponseLog: ", "L1");
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conUniversal"].ToString());
            try
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SaveRequestLog", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@LogId", LogId));
                cmd.Parameters.Add(new SqlParameter("@Json", JsonText));
                 object result = cmd.ExecuteScalar();
                 if (logId != null)
                 {
                     logId = Convert.ToInt32(result);
                 }
            }
            catch (Exception ex)
            {

                WriteToLog("Error in SaveRequestResponseLog: " + ex.Message, "L1");
            }
            finally
            {
                con.Close();
            }
            return logId;

        }
        public Message ParseJsonMessage(string jsonResponse)
        {
            Message textResponse = null;

            if (WebOperationContext.Current != null)
            {
                {
                    textResponse = WebOperationContext.Current.CreateTextResponse(jsonResponse, "application/json; charset=utf-8", Encoding.Default);
                }
            }
            return textResponse;
        }
        #endregion
    }
}
