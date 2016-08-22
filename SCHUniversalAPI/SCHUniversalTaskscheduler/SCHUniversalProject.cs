using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Web.Script.Serialization;
using System.Net.Mail;

namespace SCHUniversalTaskscheduler
{
    class SCHUniversalProject
    {
        static void Main(string[] args)
        {
            try
            {
                ProcessSCHRequest();
            }
            catch (Exception ex)
            {
            }
        }
        private static void ProcessSCHRequest()
        {
            try
            {
                WriteToLog("ProcessSCHRequest:", "L2");
                DataSet dsProject = GetNewProjectDetails();

                if (dsProject != null && dsProject.Tables.Count > 0)
                {
                    DataTable dtProject = new DataTable();
                    DataTable dtProjectClose = new DataTable();
                    DataTable dtReminder = new DataTable();
                    // New Requirement
                    DataTable dtIdentifiersHavingrewardUpdate = new DataTable();

                    dtProject = dsProject.Tables[0];
                    dtProjectClose = dsProject.Tables[1];
                    dtReminder = dsProject.Tables[2];
                    // New Requirement
                    dtIdentifiersHavingrewardUpdate = dsProject.Tables[3];

                    if (dtProject.Rows.Count > 0)
                    {
                        KinesisAPIProjectManagement(dtProject);
                    }
                    if (dtProjectClose.Rows.Count > 0)
                    {
                        KinesisAPIProjectClose(dtProjectClose);
                    }
                    if (dtReminder.Rows.Count > 0)
                    {
                        KinesisAPIReminder(dtReminder);
                    }

                    // new requirement
                    if (dtIdentifiersHavingrewardUpdate.Rows.Count > 0)
                    {
                        KinesisAPIRewardManagement(dtIdentifiersHavingrewardUpdate);
                    }
                }

            }
            catch (Exception ex)
            {
                WriteToLog("ProcessSCHRequest: " + ex.Message, "L1");
            }
            finally
            {

            }
        }

        // New Rquirement
        private static void KinesisAPIRewardManagement(DataTable dtReward)
        {
            try
            {
                WriteToLog("KinesisAPIRewardManagement: ", "L2");
                string successList = string.Empty;
                string failedList = string.Empty;
                //Call Kinesis Login API
                KinesisAPIResponse apiResponse = KinesisLogin(dtReward);//Call Kinesis Login API

                if (apiResponse.success == "True")
                {
                    string kinesisSesKey = apiResponse.data["sesKey"];
                    foreach (DataRow row in dtReward.Rows)
                    {
                        apiResponse = AddRewardPoint(row["Identifier"].ToString(), kinesisSesKey, Convert.ToInt32(row["RewardPoints"]), row["RewardDesciption"].ToString());

                        if (apiResponse.success == "True")
                        {
                            if (successList != string.Empty)
                            {
                                successList = successList + ",";
                            }

                            successList = successList + row["RespondentListId"].ToString();
                        }
                        else
                        {
                            if (failedList != string.Empty)
                            {
                                failedList = failedList + ",";
                            }
                            failedList = failedList + row["RespondentListId"].ToString();
                            WriteToLog("Kinesis API Error while adding rewards " + apiResponse.error, "L2");
                        }
                    }

                    UpdateRewardPointStatus(successList, failedList);
                }

            }
            catch (Exception ex)
            {
                WriteToLog("Error in KinesisAPIRewardManagement: " + ex.Message, "L1");
            }
        }

        private static void UpdateRewardPointStatus(string successList, string failedList)
        {
            WriteToLog("Entered UpdateRewardPointStatus method", "L2");
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
            try
            {
                SqlCommand cmd = new SqlCommand("UpdateRewardStatusOnSucccess", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@successRepondentList", successList));
                cmd.Parameters.Add(new SqlParameter("@failureRespondentList", failedList));
                con.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                WriteToLog("Error in UpdateRewardPointStatus: " + ex.Message, "L1");
            }
            finally
            {
                con.Close();
            }
        }

        private static void KinesisAPIProjectClose(DataTable dtProjectClose)
        {
            try
            {
                WriteToLog("KinesisAPIProjectClose: ", "L2");
                int prevPanelId = 0;
                string panelId = ConfigurationManager.AppSettings["panelId"];
                string successList = string.Empty;
                string failedList = string.Empty;
                //Call Kinesis Login API
                KinesisAPIResponse apiResponse = KinesisLogin(dtProjectClose);//Call Kinesis Login API
                if (apiResponse.success == "True")
                {
                    string kinesisSesKey = apiResponse.data["sesKey"];
                    foreach (DataRow row in dtProjectClose.Rows)
                    {

                        if (prevPanelId != 0 && prevPanelId != Convert.ToInt32(panelId))
                        {
                            apiResponse = SwitchKinesisPanel(Convert.ToInt32(panelId), kinesisSesKey);
                        }
                        if (apiResponse.success == "True")
                        {
                            apiResponse = CloseKinesisProject(row["KinesisProjectId"].ToString(), kinesisSesKey);
                        }

                        prevPanelId = Convert.ToInt32(panelId);

                        if (apiResponse.success == "True")
                        {
                            if (successList != string.Empty)
                            {
                                successList = successList + ",";
                            }
                            successList = successList + row["ProjectId"].ToString();

                        }
                    }
                    UpdateKinesisProjectClosedStatus(successList);
                }

            }
            catch (Exception)
            {

                throw;
            }

        }

        private static void KinesisAPIReminder(DataTable dtReminder)
        {
            try
            {
                WriteToLog("KinesisAPIReminder: ", "L2");
                int prevPanelId = 0;
                string panelId = ConfigurationManager.AppSettings["panelId"];
                string successList = string.Empty;
                /// New Requirement - start
                string successListofQuerysampleMapping = string.Empty;
                string failedListofQuerysampleMapping = string.Empty;
                /// New Requirement - end
                string failedList = string.Empty;
                //Call Kinesis Login API
                KinesisAPIResponse apiResponse = KinesisLogin(dtReminder);//Call Kinesis Login API
                if (apiResponse.success == "True")
                {
                    string kinesisSesKey = apiResponse.data["sesKey"];
                    foreach (DataRow row in dtReminder.Rows)
                    {

                        if (prevPanelId != 0 && prevPanelId != Convert.ToInt32(panelId))
                        {
                            apiResponse = SwitchKinesisPanel(Convert.ToInt32(panelId), kinesisSesKey);
                        }
                        if (apiResponse.success == "True")
                        {
                            apiResponse = OpenKinesisProject(dtReminder, kinesisSesKey);
                            if (apiResponse.success == "True")
                            {
                                apiResponse = CreateKinesisReminder(kinesisSesKey, dtReminder);
                            }
                        }

                        prevPanelId = Convert.ToInt32(panelId);

                        if (apiResponse.success == "True")
                        {
                            if (successList != string.Empty)
                            {
                                successList = successList + ",";
                            }
                            successList = successList + row["QueryId"].ToString();

                            /// New Requirement - start
                            if (successListofQuerysampleMapping != string.Empty)
                            {
                                successListofQuerysampleMapping = successListofQuerysampleMapping + ",";
                            }

                            successListofQuerysampleMapping = successListofQuerysampleMapping + row["QuerySampleMappingId"].ToString();
                            /// New Requirement - end                 
                        }
                        else
                        {
                            if (failedList != string.Empty)
                            {
                                failedList = failedList + ",";
                            }
                            failedList = failedList + row["QueryId"].ToString();

                            /// New Requirement - start
                            if (failedListofQuerysampleMapping != string.Empty)
                            {
                                failedListofQuerysampleMapping = failedListofQuerysampleMapping + ",";
                            }
                            failedListofQuerysampleMapping = failedListofQuerysampleMapping + row["QuerySampleMappingId"].ToString();
                            /// New Requirement - end            
                        }
                    }
                    UpdateKinesisReminderStatus(successList, failedList, failedListofQuerysampleMapping, successListofQuerysampleMapping);
                }

            }
            catch (Exception ex)
            {

                WriteToLog("KinesisAPIReminder: " + ex.ToString(), "L1");
            }

        }

        private static void UpdateKinesisReminderStatus(string successList, string failedList, string failedListofQuerysampleMapping, string successListofQuerysampleMapping)
        {

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
            try
            {

                SqlCommand cmd = new SqlCommand("UpdateKinesisReminderStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@QueryIds", successList));
                cmd.Parameters.Add(new SqlParameter("@FailedQueryIds", failedList));

                /// New Requirement - start
                cmd.Parameters.Add(new SqlParameter("@QuerySampleMappingIds", successListofQuerysampleMapping));
                cmd.Parameters.Add(new SqlParameter("@FailedQuerySampleMappingIds", failedListofQuerysampleMapping));
                /// New Requirement - end

                con.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                WriteToLog("Error in UpdateKinesisReminderStatus: " + ex.Message, "L1");
            }
            finally
            {
                con.Close();
            }
        }

        private static void UpdateKinesisProjectClosedStatus(string successList)
        {

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
            try
            {

                SqlCommand cmd = new SqlCommand("UpdateKinesisProjectClosedStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("@ProjectIds", successList));
                con.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                WriteToLog("Error in UpdateKinesisProjectStatus: " + ex.Message, "L1");
            }
            finally
            {
                con.Close();
            }
        }

        private static DataSet GetNewProjectDetails()
        {
            DataSet dsProject = new DataSet();
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
            try
            {
                WriteToLog("GetNewProjectDetails: ", "L2");
                con.Open();
                SqlCommand cmd = new SqlCommand("GetNewProjectRequests", con);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dsProject);
            }
            catch (Exception ex)
            {
                WriteToLog("Error in GetNewProjectDetails: " + ex.Message, "L1");
            }
            finally
            {
                con.Close();
            }
            return dsProject;
        }
        private static void UpdateKinesisProjectStatus(DataTable dtProject, int kinesisProjectId, int kinesisStatus, string KinesisAPIError, int campaignId, int sampleId)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
            try
            {
                /// New Requirement
                int QuerysampleMappingId = Convert.ToInt32(dtProject.Rows[0]["FK_QuerySampleMappingId"]);
                /// New Requirement

                int projectId = Convert.ToInt32(dtProject.Rows[0]["ProjectId"]);
                int kinesisPanelId = Convert.ToInt32(dtProject.Rows[0]["PanelId"]);
                int queryId = Convert.ToInt32(dtProject.Rows[0]["QueryId"]);

                string respondantIds = string.Empty;

                foreach (DataRow row in dtProject.Rows)
                {
                    if (respondantIds != string.Empty)
                    {
                        respondantIds += ",";
                    }
                    respondantIds += row["RespondentListId"];
                }

                SqlCommand cmd = new SqlCommand("UpdateKinesisProjectStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;

                /// New Requirement
                cmd.Parameters.Add(new SqlParameter("@QuerysampleMappingId", QuerysampleMappingId));
                /// New Requirement

                cmd.Parameters.Add(new SqlParameter("@ProjectId", projectId));
                cmd.Parameters.Add(new SqlParameter("@KinesisProjectId", kinesisProjectId));
                cmd.Parameters.Add(new SqlParameter("@KinesisStatus", kinesisStatus));
                cmd.Parameters.Add(new SqlParameter("@KinesisAPIError", KinesisAPIError));
                cmd.Parameters.Add(new SqlParameter("@RespondentListId", respondantIds));
                cmd.Parameters.Add(new SqlParameter("@PanelId", kinesisPanelId));
                cmd.Parameters.Add(new SqlParameter("@QueryId", queryId));
                cmd.Parameters.Add(new SqlParameter("@CampaignId", campaignId));
                cmd.Parameters.Add(new SqlParameter("@SampleId", sampleId));
                con.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                WriteToLog("Error in UpdateKinesisProjectStatus: " + ex.Message, "L1");
            }
            finally
            {
                con.Close();
            }
        }
        private static void KinesisAPIProjectManagement(DataTable dtProject)
        {
            try
            {
                int kinesisProjectId = 0;
                int KinesisStatus = -1;
                int kinesisSampleId = 0;
                int kinesisCampaignId = 0;

                string KinesisAPIError = string.Empty;
                WriteToLog("In KinesisAPIProjectManagement: ", "L2");
                //Call Kinesis Login API
                KinesisAPIResponse apiResponse = KinesisLogin(dtProject);

                if (apiResponse.success == "True")
                {
                    string kinesisSesKey = apiResponse.data["sesKey"];
                    KinesisStatus = 0;

                    //Call Kinesis Create Project API
                    if (dtProject.Rows[0]["KinesisProjectId"].ToString() == "0" || ConfigurationManager.AppSettings["CreateNewProject"] == "1")
                    {
                        apiResponse = CreateKinesisProject(dtProject, kinesisSesKey);

                        if (apiResponse.success == "True")
                        {
                            kinesisProjectId = Convert.ToInt32(apiResponse.data["projectid"] ?? "0");
                        }
                    }
                    else
                    {
                        apiResponse = OpenKinesisProject(dtProject, kinesisSesKey);
                        kinesisProjectId = Convert.ToInt32(dtProject.Rows[0]["KinesisProjectId"]);
                    }

                    if (apiResponse.success == "True") //Project Created
                    {

                        KinesisStatus = 1;

                        //Call Kinesis Create Sample API
                        apiResponse = CreateKinesisSample(dtProject, kinesisSesKey);

                        if (apiResponse.success == "True") // Sample Created
                        {
                            kinesisSampleId = Convert.ToInt32(apiResponse.data["sampleid"] ?? "0");
                            KinesisStatus = 2;

                            //Call Kinesis Create Sample API
                            apiResponse = CreateKinesisCampaign(kinesisSampleId, kinesisSesKey, dtProject); //Campaign Created

                            if (apiResponse.success == "True")
                            {
                                kinesisCampaignId = Convert.ToInt32(apiResponse.data["campainid"] ?? "0");
                                KinesisStatus = 3;
                            }
                        }
                    }
                }

                if (apiResponse.success != "True" && apiResponse.error != null)
                {
                    KinesisAPIError = apiResponse.error;

                    if (ConfigurationManager.AppSettings["SendKinesisAPIErrorEmail"] == "1")
                    {
                        //Kinesis API error. Send email
                        SendKinesisAPIErrorEmail(KinesisAPIError, dtProject.Rows[0]["KinesisProjectName"].ToString(), KinesisStatus);
                    }
                }

                //Update Kinesis API status
                UpdateKinesisProjectStatus(dtProject, kinesisProjectId, KinesisStatus, KinesisAPIError, kinesisCampaignId, kinesisSampleId);


            }
            catch (Exception ex)
            {
                WriteToLog("Error in KinesisAPICalls: " + ex.Message, "L1");
            }
        }

        #region Kinesis API Calls

        private static KinesisAPIResponse KinesisLogin(DataTable dtProject)
        {
            ////KinesisAPIResponse result = new KinesisAPIResponse();

            ////try
            ////{
            ////    WriteToLog("In KinesisLogin: ", "L2");

            ////    string datapointsJsonString;
            ////    string postData;
            ////    string kinesisUserName = ConfigurationManager.AppSettings["KinesisPanelUserName"];
            ////    string kinesisPassword = ConfigurationManager.AppSettings["KinesisPanelPassword"];
            ////    string panelId = ConfigurationManager.AppSettings["panelId"];

            ////    datapointsJsonString = "{ \"username\": \"" + kinesisUserName + "\", \"password\": \"" + kinesisPassword + "\", \"panelid\": " + panelId + " }";
            ////    postData = string.Format("method=integration.auth.login&data={0}", datapointsJsonString);

            ////    result = RunKinesisPanelAPI(postData);
            ////}
            ////catch (Exception ex)
            ////{
            ////    WriteToLog("Error in KinesisLogin: " + ex.Message, "L1");
            ////}

            KinesisAPIResponse result = new KinesisAPIResponse();
            result.success = "True";
            result.data["sesKey"] = Guid.NewGuid().ToString();
            return result;
        }

        private static KinesisAPIResponse CreateKinesisProject(DataTable dtProject, string kinesisSesKey)
        {
            KinesisAPIResponse result = new KinesisAPIResponse();

            try
            {
                ////WriteToLog("In CreateKinesisProject: ", "L2");
                ////string projectName = dtProject.Rows[0]["KinesisProjectName"].ToString();
                ////string surveyURL = dtProject.Rows[0]["SurveyURL"].ToString() + ConfigurationManager.AppSettings["KinesisSurveyParameters"];
                ////string datapointsJsonString = "{\"sesKey\":\"" + kinesisSesKey + "\",\"settings\":{\"name\":\"" + projectName + "\",\"url\":\"" + surveyURL + "\",\"defaultMaxParticipation\":\"1\"}}";
                ////string postData = string.Format("method=integration.project.create&data={0}", datapointsJsonString);

                ////result = RunKinesisPanelAPI(postData);

                result.success = "True";
                result.data["projectid"] = Guid.NewGuid().ToString();
            }
            catch (Exception ex)
            {
                WriteToLog("Error in CreateKinesisProject: " + ex.Message, "L1");
            }

            return result;
        }

        private static KinesisAPIResponse OpenKinesisProject(DataTable dtProject, string kinesisSesKey)
        {
            KinesisAPIResponse result = new KinesisAPIResponse();

            try
            {

                ////string projectId = dtProject.Rows[0]["KinesisProjectId"].ToString();


                //////Add a new column for points in DB for each projects. Calculate this based on LOI. take points from DB

                ////string datapointsJsonString = "{\"sesKey\":\"" + kinesisSesKey + "\",\"projectid\":" + projectId + "}";
                ////string postData = string.Format("method=integration.project.select&data={0}", datapointsJsonString);

                ////result = RunKinesisPanelAPI(postData);

                result.success = "True";
                result.data["projectid"] = Guid.NewGuid().ToString();
            }
            catch (Exception ex)
            {
                WriteToLog("Error in OpenKinesisProject: " + ex.Message, "L1");
            }

            return result;
        }

        private static KinesisAPIResponse CreateKinesisSample(DataTable dtProject, string kinesisSesKey)
        {
            KinesisAPIResponse result = new KinesisAPIResponse();

            try
            {
                ////WriteToLog("In CreateKinesisSample: ", "L2");
                ////StringBuilder sampleIds = new StringBuilder();
                ////string sampleName = "SCH Universal Sample " + dtProject.Rows[0]["QueryBatch"].ToString();
                ////foreach (DataRow row in dtProject.Rows)
                ////{
                ////    sampleIds.Append(string.Format("\"{0}\",", row["KinesisIdentifier"]));
                ////}

                ////string datapointsJsonString = "{\"sesKey\":\"" + kinesisSesKey + "\",\"name\":\"" + sampleName + "\",\"description\":\"SCH Universal Survey\",\"identifiers\":[" + sampleIds.ToString().TrimEnd(',') + "]}";
                ////string postData = string.Format("method=integration.sample.create&data={0}", datapointsJsonString);

                ////result = RunKinesisPanelAPI(postData);

                result.success = "True";
                result.data["sampleid"] = Guid.NewGuid().ToString();
            }
            catch (Exception ex)
            {
                WriteToLog("Error in CreateKinesisSample: " + ex.Message, "L1");
            }

            return result;
        }

        private static KinesisAPIResponse CreateKinesisCampaign(int kinesisSampleId, string kinesisSesKey, DataTable dtProject)
        {
            KinesisAPIResponse result = new KinesisAPIResponse();
            try
            {
                ////    WriteToLog("In CreateKinesisCampaign: ", "L2");
                ////    DateTime eastern = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(DateTime.UtcNow, "Eastern Standard Time");
                ////    string campaignSenderNameKey = "CampaignSenderName" + dtProject.Rows[0]["PanelId"].ToString();
                ////    string campaignSenderEmailKey = "CampaignSenderEmail" + dtProject.Rows[0]["PanelId"].ToString();
                ////    string campaignSenderName = ConfigurationManager.AppSettings[campaignSenderNameKey];
                ////    string campaignSenderEmail = ConfigurationManager.AppSettings[campaignSenderEmailKey];
                ////    string campaignEmailSubject = dtProject.Rows[0]["EmailSubject"].ToString();
                ////    string invitationTemplate = dtProject.Rows[0]["EmailTemplate"].ToString();
                ////    string loi = dtProject.Rows[0]["LOI"].ToString();
                ////    string reward = dtProject.Rows[0]["Reward"].ToString();
                ////    string rewardPoints = dtProject.Rows[0]["RewardPoints"].ToString();
                ////    string referenceCode = dtProject.Rows[0]["ReferenceCode"].ToString();
                ////    string surveyTopic = dtProject.Rows[0]["SurveyTopic"].ToString();
                ////    string rewardPoint = (Convert.ToDecimal(reward) * 10).ToString();
                ////    string templatePath = Path.GetFullPath(System.AppDomain.CurrentDomain.BaseDirectory);
                ////    TextReader tr = new StreamReader(templatePath + @"\" + invitationTemplate);

                ////    string content = tr.ReadToEnd();
                ////    content = content.Replace("\r", string.Empty).Replace("\n", string.Empty).Replace("{LOI}", loi).Replace("{REWARD}", reward).Replace("{REWARD POINT}", rewardPoint).Replace("{REFCODE}", referenceCode).Replace("{TOPIC}", surveyTopic);

                ////    string datapointsJsonString = "{\"sesKey\": \"" + kinesisSesKey + "\",\"settings\": {\"name\": \"SCH Campaign\",\"startTime\": \"" + eastern + "\",\"pointsCompleted\":\"" + rewardPoints + "\",\"type\": \"html\",\"senderName\": \"" + campaignSenderName + "\",\"senderEmailAddress\": \"" + campaignSenderEmail + "\"},\"messages\": [{\"subject\": \"" + campaignEmailSubject + "\",\"content\": \"" + content + "\",\"surveyLinkText\": \"Click Here\",\"optoutLinkText\": \"Click Here\",\"locale\":" + ConfigurationManager.AppSettings["Locale"] + ",\"replyToEmailAddress\": \"" + campaignSenderEmail + "\"}],\"sampleids\": [" + kinesisSampleId.ToString() + "]}";
                ////    string postData = string.Format("method=integration.campaign.create&data={0}", datapointsJsonString);

                ////    result = RunKinesisPanelAPI(postData);

                result.success = "True";
                result.data["campainid"] = Guid.NewGuid().ToString();

            }
            catch (Exception ex)
            {
                WriteToLog("Error in CreateKinesisCampaign: " + ex.Message, "L1");
            }

            return result;
        }

        private static KinesisAPIResponse SwitchKinesisPanel(int panelId, string kinesisSesKey)
        {
            KinesisAPIResponse result = new KinesisAPIResponse();

            try
            {
                ////string datapointsJsonString = "{\"sesKey\":\"" + kinesisSesKey + "\",\"panelid\":" + panelId + "}";
                ////string postData = string.Format("method=integration.panel.select&data={0}", datapointsJsonString);

                ////result = RunKinesisPanelAPI(postData);

                result.success = "True";
            }
            catch (Exception ex)
            {
                WriteToLog("Error in CreateKinesisProject: " + ex.Message, "L1");
            }

            return result;
        }
        private static KinesisAPIResponse CloseKinesisProject(string projectId, string kinesisSesKey)
        {
            KinesisAPIResponse result = new KinesisAPIResponse();

            try
            {

                //Add a new column for points in DB for each projects. Calculate this based on LOI. take points from DB

                ////string datapointsJsonString = "{\"sesKey\":\"" + kinesisSesKey + "\",\"projectid\":" + projectId + "}";
                ////string postData = string.Format("method=integration.project.close&data={0}", datapointsJsonString);

                ////result = RunKinesisPanelAPI(postData);

                result.success = "True";
            }
            catch (Exception ex)
            {
                WriteToLog("Error in CreateKinesisProject: " + ex.Message, "L1");
            }

            return result;

        }
        private static KinesisAPIResponse CreateKinesisReminder(string kinesisSesKey, DataTable dtReminder)
        {
            KinesisAPIResponse result = new KinesisAPIResponse();
            try
            {
                WriteToLog("In CreateKinesisReminder: ", "L2");
                ////DateTime eastern = TimeZoneInfo.ConvertTimeBySystemTimeZoneId(DateTime.UtcNow, "Eastern Standard Time");
                ////string campaignSenderNameKey = "CampaignSenderName" + ConfigurationManager.AppSettings["panelId"];
                ////string campaignSenderEmailKey = "CampaignSenderEmail" + ConfigurationManager.AppSettings["panelId"];
                ////string campaignSenderName = ConfigurationManager.AppSettings[campaignSenderNameKey];
                ////string campaignSenderEmail = ConfigurationManager.AppSettings[campaignSenderEmailKey];
                ////string campaignEmailSubject = dtReminder.Rows[0]["EmailSubject"].ToString();
                ////string invitationTemplate = "Reminder-" + ConfigurationManager.AppSettings["panelId"] + ".htm";
                ////string loi = dtReminder.Rows[0]["LOI"].ToString();
                ////string reward = dtReminder.Rows[0]["Reward"].ToString();
                ////string rewardPoints = dtReminder.Rows[0]["RewardPoints"].ToString();
                ////string referenceCode = dtReminder.Rows[0]["ReferenceCode"].ToString();
                ////string surveyTopic = dtReminder.Rows[0]["SurveyTopic"].ToString();
                ////string campaignId = dtReminder.Rows[0]["CampaignId"].ToString();
                ////string sampleId = dtReminder.Rows[0]["SampleId"].ToString();
                ////string rewardPoint = (Convert.ToDecimal(reward) * 10).ToString();
                ////string templatePath = Path.GetFullPath(System.AppDomain.CurrentDomain.BaseDirectory);
                ////TextReader tr = new StreamReader(templatePath + @"\" + invitationTemplate);

                ////string local = ConfigurationManager.AppSettings["LocaleRem"];
                ////string[] locale = local.Split(',');
                ////string messageArray = string.Empty;

                ////string content = tr.ReadToEnd();
                ////content = content.Replace("\r", string.Empty).Replace("\n", string.Empty).Replace("{LOI}", loi).Replace("{REWARD}", reward).Replace("{REWARD POINT}", rewardPoint).Replace("{REFCODE}", referenceCode).Replace("{TOPIC}", surveyTopic);

                ////foreach (string loc in locale)
                ////{
                ////    if (messageArray != string.Empty)
                ////    {
                ////        messageArray = messageArray + ",";
                ////    }
                ////    messageArray = messageArray + " {\"subject\": \"" + campaignEmailSubject + "\",\"content\": \"" + content + "\",\"locale\":" + loc + "}";
                ////}

                ////string datapointsJsonString = "{\"sesKey\": \"" + kinesisSesKey + "\",\"campaignid\":" + campaignId + ",\"messages\": [" + messageArray + "], \"startDate\":  \"" + eastern + "\",\"sampleids\": [" + sampleId + "]}";
                ////string postData = string.Format("method=integration.reminder.create&data={0}", datapointsJsonString);

                ////WriteToLog(" CreateKinesisReminder: Request" + postData, "L2");
                ////result = RunKinesisPanelAPI(postData);
                result.success = "True";
                WriteToLog("CreateKinesisReminder: Response" + result, "L2");

            }
            catch (Exception ex)
            {
                WriteToLog("Error in CreateKinesisReminder: " + ex.Message, "L1");
            }

            return result;
        }
        private static KinesisAPIResponse RunKinesisPanelAPI(string postData)
        {
            KinesisAPIResponse list = new KinesisAPIResponse();

            try
            {
                WriteToLog("RunKinesisPanelAPI: ", "L2");
                string api = ConfigurationManager.AppSettings["KinesisAPI"];
                ASCIIEncoding encoding = new ASCIIEncoding();
                byte[] data = encoding.GetBytes(postData);

                // Prepare web request...
                HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(api);
                myRequest.Method = "POST";
                myRequest.ContentType = "application/x-www-form-urlencoded";
                myRequest.ContentLength = data.Length;
                Stream newStream = myRequest.GetRequestStream();
                // Send the data.
                newStream.Write(data, 0, data.Length);
                newStream.Close();
                WriteToLog(" RunKinesisPanelAPI:-Before http call " + postData, "L2");
                //Get the response 
                HttpWebResponse response = (HttpWebResponse)myRequest.GetResponse();
                StreamReader reader = new StreamReader(response.GetResponseStream());
                StringBuilder output = new StringBuilder();
                output.Append(reader.ReadToEnd());
                response.Close();
                string result = output.ToString();
                WriteToLog(" RunKinesisPanelAPI:-After http call " + result, "L2");

                JavaScriptSerializer jvserailizer = new JavaScriptSerializer();
                list = jvserailizer.Deserialize<KinesisAPIResponse>(result);
            }
            catch (Exception ex)
            {
                WriteToLog("Error in RunKinesisPanelAPI: " + ex.Message, "L1");
            }

            return list;
        }


        // New Requirement
        private static KinesisAPIResponse AddRewardPoint(string identifier, string kinesisSesKey, int rewardPoint, string description)
        {
            KinesisAPIResponse result = new KinesisAPIResponse();
            try
            {
                WriteToLog("AddRewardPoint: ", "L2");
                ////string datapointsJsonString = "{\"sesKey\":\"" + kinesisSesKey + "\",\"index\":\"" + identifier + "\",\"points\":\"" + rewardPoint + "\",\"note\":\"" + description + "\"}";
                ////string postData = string.Format("method=integration.panelist.rewardPointsAdd&data={0}", datapointsJsonString);

                ////result = RunKinesisPanelAPI(postData);

                result.success = "True";
            }
            catch (Exception ex)
            {
                WriteToLog("Error in AddRewardPoint: " + ex.Message, "L1");
            }

            return result;
        }


        #endregion

        private static void SendKinesisAPIErrorEmail(string errorMessage, string kinesisProjectName, int KinesisStatus)
        {
            try
            {
                MailMessage message = new MailMessage();
                message.IsBodyHtml = true;
                message.Subject = ConfigurationManager.AppSettings["KinesisAPIErrorEmailSubject"];
                message.From = new MailAddress(ConfigurationManager.AppSettings["KinesisAPIErrorEmailFrom"]);
                message.ReplyTo = new MailAddress(ConfigurationManager.AppSettings["KinesisAPIErrorEmailFrom"]);

                string[] toEMailIds = ConfigurationManager.AppSettings["KinesisAPIErrorEmailIds"].Split(',');
                foreach (var item in toEMailIds)
                {
                    message.To.Add(item);
                }

                StringBuilder emailBody = new StringBuilder();
                emailBody.Append("Hi All,<br/> Error while creating SSI Project in Kinesis.<br/><br/> ");
                emailBody.Append("<strong>Project:</strong>");
                emailBody.Append(kinesisProjectName);

                string errorLocation = "";
                switch (KinesisStatus)
                {
                    case -1:
                        errorLocation = "Kinesis Login";
                        break;
                    case 0:
                        errorLocation = "Kinesis Project Create";
                        break;
                    case 1:
                        errorLocation = "Kinesis Sample Create";
                        break;
                    case 2:
                        errorLocation = "Kinesis Campaign Create";
                        break;
                }

                emailBody.Append("<br/><strong>Error At:</strong>");
                emailBody.Append(errorLocation);
                emailBody.Append("<br/><strong>Error Message:</strong>");
                emailBody.Append(errorMessage);
                message.Body = emailBody.ToString();

                SmtpClient client = new SmtpClient();
                client.EnableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["KinesisAPIErrorEmailEnableSsl"]);
                client.Timeout = 600000;
                client.Send(message);
            }
            catch (Exception ex)
            {
                WriteToLog("Error in SendKinesisAPIErrorEmail: " + ex.Message, "L1");
            }
        }
        private static void WriteToLog(string contents, string logLevel)
        {
            string s = ConfigurationSettings.AppSettings["LogLevel"];
            string configLogLevel = Convert.ToString(ConfigurationSettings.AppSettings["LogLevel"] ?? "L1");

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

        public class KinesisAPIResponse
        {
            public string success;
            public string error;
            public Dictionary<string, string> data;
        }
    }
}
