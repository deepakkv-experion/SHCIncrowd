using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SCHUniversalTashSchedularForAutomations
{
    public class SCHUniversalAutomationShedular
    {
        static void Main(string[] args)
        {
            GetAllSamplesNotAchievedRequiredN();
        }

        public static void GetAllSamplesNotAchievedRequiredN()
        {
            try
            {
                DataSet dsProject = new DataSet();
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
                try
                {
                    WriteToLog("GetNewProjectDetails: ", "L2");
                    con.Open();
                    SqlCommand cmd = new SqlCommand("GetAllLatestQuery", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(dsProject);
                    ////var test = dsProject.Tables[0].Rows[0]["MaxPanelistCount"];                  
                }
                catch (Exception ex)
                {
                    WriteToLog("Error in GetNewProjectDetails: " + ex.Message, "L1");
                }
                finally
                {
                    con.Close();
                }
            }
            catch (Exception ex)
            {

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
    }
}
