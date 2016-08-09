using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.IO;

namespace SCHUniversalProject
{
    public partial class Survey : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                int surveyLogId = SaveSurveyLog();

                if (Request.QueryString["prid"] != null && Request.QueryString["identifier"] != null && Request.QueryString["sesskey"] != null)
                {
                    DataTable dtSurveyDetails = UpdateDataGetSSISurveyURL(Request.QueryString["prId"], Request.QueryString["identifier"], Request.QueryString["sesskey"], surveyLogId);

                    if (dtSurveyDetails.Rows.Count > 0)
                    {
                        int surveyStatus = Convert.ToInt32(dtSurveyDetails.Rows[0]["SurveyStatus"]);
                        string surveyUrl =  Convert.ToString(dtSurveyDetails.Rows[0]["SurveyURL"]);
                        int projectStatus = Convert.ToInt32(dtSurveyDetails.Rows[0]["ProjectStatus"]);
                        if (projectStatus != 3 && projectStatus != 4)
                        {
                            switch (surveyStatus)
                            {
                                case 0:
                                    Response.Redirect(surveyUrl);
                                    break;
                                case 1:
                                    lblMessage.Text = "We're sorry but it appears you have already taken this survey. Thank you for your time.";
                                    break;
                                case 2:
                                    lblMessage.Text = "We're sorry but it appears you have already taken this survey. Thank you for your time.";
                                    break;
                                case 3:
                                    lblMessage.Text = "We're sorry but it appears you have already taken this survey. Thank you for your time.";
                                    break;
                                case 4:
                                    Response.Redirect(surveyUrl);
                                    break;
                            }
                        }
                        else
                        {
                            lblMessage.Text = "We're sorry, but this project has closed. Thank you for your time.";
                        }
                    }
                }
                else
                {
                    lblMessage.Text = "Incorrect Survey.";
                }
            }
            catch (Exception ex)
            {
                WriteToLog("Error in Page_Load:" + ex.Message, "L1");
            }
        }

        private DataTable UpdateDataGetSSISurveyURL(string projectId, string identifier, string sesskey, int surveyLogId)
        {
            DataTable dtSurveyDetails = new DataTable();
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());

            try
            {
                SqlCommand cmd = new SqlCommand("UpdateDataGetSCHSurveyURL", con);
                cmd.CommandType = CommandType.StoredProcedure;
                string ipAddress = Request.ServerVariables["REMOTE_ADDR"];
                cmd.Parameters.Add(new SqlParameter("@ProjectId", projectId));
                cmd.Parameters.Add(new SqlParameter("@Identifier", identifier));
                cmd.Parameters.Add(new SqlParameter("@Sesskey", sesskey));
                cmd.Parameters.Add(new SqlParameter("@SurveyRequestIP", ipAddress));
                cmd.Parameters.Add(new SqlParameter("@SurveyLogId", surveyLogId));
                con.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(dtSurveyDetails);
                
            }
            catch (Exception ex)
            {
                WriteToLog("Error in UpdateDataGetSSISurveyURL:" + ex.Message, "L1");
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                    con.Close();
            }

            return dtSurveyDetails;
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
                cmd.Parameters.Add(new SqlParameter("@LogType", 1));

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
                string configLogLevel = Convert.ToString(ConfigurationManager.AppSettings["SurveyLogLevel"] ?? "L1");

                if ((configLogLevel == "L1" && logLevel == "L1") || (configLogLevel == "L2"))
                {
                    string folder = Path.GetFullPath(Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "Log"));
                    string filePath = folder + "\\SurveyLog.txt";

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