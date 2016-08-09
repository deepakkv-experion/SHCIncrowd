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
using System.ServiceModel.Activation;

namespace SCHUniversalAPI
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "universalrestservice" in code, svc and config file together.
    //[AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class universalrestservice : Iuniversalrestservice
    {
        public Stream CreateProject(Project projectData)
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

            ////return ParseJsonMessage(response);
            //  return response;
            // New Requirement
            return GetCurrentCart(response);
        }
        public Stream UpdateProject(string projectId, Project projectData)
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

            ////return ParseJsonMessage(response);
            return GetCurrentCart(response);
        }
        public Stream ChangeProjectStatus(ProjectStatus status)
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

            return GetCurrentCart(response);
            ////return ParseJsonMessage(response);

        }
        public Stream DefineQuery(Query queryData)
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

            ////return ParseJsonMessage(response);
            return GetCurrentCart(response);
        }
        public Stream DeleteQuery(string queryId)
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
            ////return ParseJsonMessage(response);
            return GetCurrentCart(response);
        }
        public Stream SendReminder(string queryId)
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
            ////return ParseJsonMessage(response);
            return GetCurrentCart(response);
        }

        #region NewRequirement

        /// <summary>
        /// Updates the query.
        /// </summary>
        /// <param name="updatingValues">The updating values.</param>
        /// <returns> retruns string</returns>
        public Stream UpdateQuery(SHCUniversalModel updatingValues)
        {
            WriteToLog(" In UpdateQuery", "L2");
            if (updatingValues != null)
            {
                if (updatingValues.newhonorarium != null && updatingValues.newhonorarium.ToLower().Equals('a') || updatingValues.newhonorarium.ToLower().Equals('b') || updatingValues.newhonorarium.ToLower().Equals('c') || updatingValues.newhonorarium.ToLower().Equals('d'))
                {
                    return GetCurrentCart(new { success = false, error = "Invalid honorarium level" });
                }

                dynamic response;
                int logId = 0;
                logId = SaveRequestResponseLog("0", JsonConvert.SerializeObject(updatingValues));
                response = UpdateRequiredNForQueryId(updatingValues);
                if (response.success.Equals(true))
                {
                    SaveRequestResponseLog(logId.ToString(), GenerateSuccessResponse(response));
                    WriteToLog("Succesfully updated", "L2");
                    return GetCurrentCart(response);
                }

                return GetCurrentCart(new { success = false, error = response.error });
            }

            return GetCurrentCart(new { success = false, error = "Failed to update" });
        }

        /// <summary>
        /// Gets the project status.
        /// </summary>
        /// <param name="projectId">The project identifier.</param>
        /// <returns> returns Stream</returns>
        public Stream GetProjectStatus(string projectId)
        {
            WriteToLog(" In Get Project Status", "L2");
            int logId = 0;
            dynamic response;
            if (!string.IsNullOrEmpty(projectId))
            {
                response = GetProjectStatusById(projectId);
                if (response.success.Equals(true))
                {
                    return GetCurrentCart(response);
                }

                return GetCurrentCart(new { success = false, error = response.error });
            }

            return GetCurrentCart(new { success = false, error = "Invalid projectId" });
        }

        /// <summary>
        /// Gets the project status by identifier.
        /// </summary>
        /// <param name="projectId">The project identifier.</param>
        /// <returns> returns dynamic</returns>
        private dynamic GetProjectStatusById(string projectId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conUniversal"].ToString());
            DataSet dsProject = new DataSet();
            try
            {
                WriteToLog("Entered Get Project Status By ProjectId", "L1");
                con.Open();
                SqlCommand cmd = new SqlCommand("GetProjectStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@projectId", projectId));
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dsProject);
                if (dsProject.Tables.Count > 0)
                {
                    var projectStatusResponse = new ProjectStatusResponse();
                    projectStatusResponse = new ProjectStatusResponse() { success = true, projectstatus = new List<ProjectStatusRequest>() };
                    for (int i = 0; i < dsProject.Tables.Count; i++)
                    {
                        projectStatusResponse.projectstatus.Add(new ProjectStatusRequest
                        {
                            queryid = Convert.ToInt32(dsProject.Tables[i].Rows[0][0]),
                            invitationsent = Convert.ToInt32(dsProject.Tables[i].Rows[0][1]),
                            remaindersent = Convert.ToInt32(dsProject.Tables[i].Rows[0][2]),
                            numberofcompletes = Convert.ToInt32(dsProject.Tables[i].Rows[0][3]),
                            honorarium = Convert.ToString(dsProject.Tables[i].Rows[0][4]),
                        });
                    }

                    return projectStatusResponse;
                }

                return new { success = false, error = "Error while retreiving values from database" };

            }
            catch (Exception ex)
            {
                WriteToLog("Error in Get Project Status By ProjectId : " + ex.Message, "L1");
                return new { success = false, error = ex.Message };
            }
            finally
            {
                con.Close();
            }
        }

        /// <summary>
        /// Updates the required n for query identifier.
        /// </summary>
        /// <param name="updatingValues">The updating values.</param>
        /// <returns> returns object</returns>
        public object UpdateRequiredNForQueryId(SHCUniversalModel updatingValues)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["conUniversal"].ToString());
            try
            {
                WriteToLog("Entered Update Required N Method", "L1");
                con.Open();
                SqlCommand cmd = new SqlCommand("UpdateQuery", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@QueryId", updatingValues.queryid));
                cmd.Parameters.Add(new SqlParameter("@NewHonorium", updatingValues.newhonorarium ?? updatingValues.newhonorarium.ToLower()));
                cmd.Parameters.Add(new SqlParameter("@NewIncidence", updatingValues.newincidence));
                int result = cmd.ExecuteNonQuery();
                if (result > 0)
                {
                    return new { success = true };
                }

                return new { success = false, error = "Failed to update" };
            }
            catch (Exception ex)
            {
                WriteToLog("Error in Updating Required N : " + ex.Message, "L1");
                return new { success = false, error = ex.Message };
            }
            finally
            {
                con.Close();
            }
        }

        /// <summary>
        /// Generates the success response.
        /// </summary>
        /// <param name="response">The response.</param>
        /// <returns> returns string</returns>
        private string GenerateSuccessResponse(object response)
        {
            return JsonConvert.SerializeObject(response);
        }

        #endregion


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
                int exclusionCount = 0;

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

                // New Requirement
                //Include NPI
                if (queryData.inclusionnpi != null && queryData.inclusionnpi.Count > 0)
                {
                    string inclusionnpi = string.Empty;
                    foreach (var excl in queryData.inclusionnpi)
                    {
                        inclusionnpi = inclusionnpi + "'" + excl + "',";
                    }

                    inclusionnpi = inclusionnpi.Remove(inclusionnpi.Length - 1);
                    if (queryCondition != string.Empty)
                    {
                        queryCondition = queryCondition + "AND EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = " + ConfigurationManager.AppSettings["ExclusionId"] + " AND OptionId IN(" + inclusionnpi + ")) ";
                    }
                    else
                    {
                        queryCondition = " (DataPointId = " + ConfigurationManager.AppSettings["ExclusionId"] + " AND OptionId NOT IN(" + inclusionnpi + ") ) ";
                    }
                }

                // New Requirement
                //Include Identifier
                if (queryData.inclusionidentifiers != null && queryData.inclusionidentifiers.Count > 0)
                {
                    string inclusionidentifiers = string.Empty;
                    foreach (var excl in queryData.inclusionidentifiers)
                    {
                        inclusionidentifiers = inclusionidentifiers + "'" + excl + "',";
                    }

                    inclusionidentifiers = inclusionidentifiers.Remove(inclusionidentifiers.Length - 1);
                    if (queryCondition != string.Empty)
                    {
                        queryCondition = queryCondition + "AND EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = " + ConfigurationManager.AppSettings["IdentifierId"] + " AND OptionId IN(" + inclusionidentifiers + ")) ";
                    }
                    else
                    {
                        queryCondition = " (DataPointId = " + ConfigurationManager.AppSettings["IdentifierId"] + " AND OptionId NOT IN(" + inclusionidentifiers + ") ) ";
                    }
                }


                // New Requirement
                // Exclude identifiers
                if (queryData.exclusionidentifiers != null && queryData.exclusionidentifiers.Count > 0)
                {
                    exclusionCount += queryData.exclusions.Count;
                    string exclusionidentifiers = string.Empty;
                    foreach (var excl in queryData.exclusionidentifiers)
                    {
                        exclusionidentifiers = exclusionidentifiers + "'" + excl + "',";
                    }

                    exclusionidentifiers = exclusionidentifiers.Remove(exclusionidentifiers.Length - 1);
                    if (queryCondition != string.Empty)
                    {
                        queryCondition = queryCondition + "AND NOT EXISTS (SELECT * FROM PanelistMaster EX WHERE P.Identifier=EX.Identifier AND DataPointId = " + ConfigurationManager.AppSettings["IdentifierId"] + " AND OptionId IN(" + exclusionidentifiers + ")) ";
                    }
                    else
                    {
                        queryCondition = " (DataPointId != " + ConfigurationManager.AppSettings["IdentifierId"] + " AND OptionId NOT IN(" + exclusionidentifiers + ") ) ";
                    }
                }
                else
                {
                    exclusionCount = 0;
                }

                //Exclude NPI
                if (queryData.exclusions != null && queryData.exclusions.Count > 0)
                {
                    exclusionCount += queryData.exclusions.Count;
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
                            //new requirement ( Convert.ToString(dsQuery.Tables[0].Rows[0][2])  (second parameter))
                            response = SaveRespondents(dsQuery.Tables[0].Rows[0][0].ToString(), Convert.ToString(dsQuery.Tables[0].Rows[0][2]), queryData.projectid, queryData.reqn, queryCondition);
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
            string status = string.Empty;
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
            string response = string.Empty;
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
        public string SaveRespondents(string queryId, string MaxAddressable, string projectId, string reqN, string queryCondition)
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
                        //new requirement
                        responseJson = GenerateQueryResponseJson(projectId, queryId, dsFeasibility.Tables[0].Rows[0][0].ToString(), MaxAddressable);
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
        public string GenerateQueryResponseJson(string projectId, string queryId, string feasibility, string MaxAddressable)
        {
            QueryResponse queryResponse = new QueryResponse();
            queryResponse.success = true;
            queryResponse.projectid = Convert.ToInt32(projectId);
            queryResponse.queryid = Convert.ToInt32(queryId);
            queryResponse.feasibility = Convert.ToInt32(feasibility);

            //New requirement
            queryResponse.MaxAddressable = Convert.ToInt32(MaxAddressable);
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
        public int SaveRequestResponseLog(string LogId, string JsonText)
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

        public Stream GetCurrentCart(dynamic updatingValues)
        {
            var serializer = new JavaScriptSerializer();
            string jsonClient = serializer.Serialize(updatingValues);
            WebOperationContext.Current.OutgoingResponse.ContentType = "application/json; charset=utf-8";
            return new MemoryStream(Encoding.UTF8.GetBytes(jsonClient));
        }
    }
}
