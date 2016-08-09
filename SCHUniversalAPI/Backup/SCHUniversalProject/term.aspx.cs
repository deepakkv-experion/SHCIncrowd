using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.IO;

namespace SCHUniversalProject
{
    public partial class term : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                int surveyLogId = SaveSurveyLog();

                if (Request.QueryString["sourceData"] != null)
                {
                    string sessKey = UpdateSurveyStatus(Request.QueryString["sourceData"], surveyLogId);

                    //Call Kinesis Completion URL
                    if (!string.IsNullOrEmpty(sessKey))
                    {
                        string kinesisCompleteUrl = string.Format(ConfigurationManager.AppSettings["KinesisProfileUrl"], sessKey);
                        Response.Redirect(kinesisCompleteUrl);
                    }
                }
            }
            catch (Exception ex)
            {
                WriteToLog("Error in Page_Load:" + ex.Message, "L1");
            }
        }

        private string UpdateSurveyStatus(string sourceData, int surveyLogId)
        {
            string sessKey = "";
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());

            try
            {
                SqlCommand cmd = new SqlCommand("UpdateSurveyStatus", con);
                cmd.CommandType = CommandType.StoredProcedure;

                string ipAddress = Request.ServerVariables["REMOTE_ADDR"];

                cmd.Parameters.Add(new SqlParameter("@UniqueId", sourceData));
                cmd.Parameters.Add(new SqlParameter("@status", 2));
                cmd.Parameters.Add(new SqlParameter("@SurveyCompletionIP", ipAddress));
                cmd.Parameters.Add(new SqlParameter("@SurveyLogId", surveyLogId));

                con.Open();

                sessKey = Convert.ToString(cmd.ExecuteScalar() ?? "");

            }
            catch (Exception ex)
            {
                WriteToLog("Error in UpdateSurveyStatus:" + ex.Message, "L1");
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                    con.Close();
            }

            return sessKey;
        }

        private int SaveSurveyLog()
        {
            int surveyLogId = 0;
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());

            try
            {
                SqlCommand cmd = new SqlCommand("SaveSurveyLog", con);
                cmd.CommandType = CommandType.StoredProcedure;

                string ipAddress = Request.ServerVariables["REMOTE_ADDR"];
                string incomingUrl = Request.Url.AbsoluteUri;

                cmd.Parameters.Add(new SqlParameter("@Url", incomingUrl));
                cmd.Parameters.Add(new SqlParameter("@IPAddress", ipAddress));
                cmd.Parameters.Add(new SqlParameter("@LogType", 2));

                SqlParameter returnParameter = cmd.Parameters.Add("RetVal", SqlDbType.Int);
                returnParameter.Direction = ParameterDirection.ReturnValue;

                con.Open();
                cmd.ExecuteNonQuery();

                surveyLogId = (int)returnParameter.Value;

            }
            catch (Exception ex)
            {
                WriteToLog("Error in SaveSurveyLog:" + ex.Message, "L1");
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                    con.Close();
            }

            return surveyLogId;
        }

        private void WriteToLog(string contents, string logLevel)
        {
            try
            {
                string configLogLevel = Convert.ToString(ConfigurationManager.AppSettings["SurveyCompleteLogLevel"] ?? "L1");

                if ((configLogLevel == "L1" && logLevel == "L1") || (configLogLevel == "L2"))
                {
                    string folder = Path.GetFullPath(Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "Log"));
                    string filePath = folder + "\\SurveyCompleteLog.txt";

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
            catch (Exception)
            {
            }
        }
    }
}
