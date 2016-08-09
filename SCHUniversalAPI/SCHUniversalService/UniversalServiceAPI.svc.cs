using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Channels;
using System.ServiceModel.Web;
using System.Text;
using System.Web.Script.Serialization;

namespace SCHUniversalService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "UniversalServiceAPI" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select UniversalServiceAPI.svc or UniversalServiceAPI.svc.cs at the Solution Explorer and start debugging.
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class UniversalServiceAPI : IUniversalService
    {
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
                    projectStatusResponse = new ProjectStatusResponse() { success = true, projectstatus = new List<ProjectStatus>() };
                    for (int i = 0; i < dsProject.Tables.Count; i++)
                    {
                        projectStatusResponse.projectstatus.Add(new ProjectStatus
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

        #region Log

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

        public Stream GetCurrentCart(dynamic updatingValues)
        {
            var serializer = new JavaScriptSerializer();
            string jsonClient = serializer.Serialize(updatingValues);
            WebOperationContext.Current.OutgoingResponse.ContentType = "application/json; charset=utf-8";
            return new MemoryStream(Encoding.UTF8.GetBytes(jsonClient));
        }
        #endregion
    }
}
