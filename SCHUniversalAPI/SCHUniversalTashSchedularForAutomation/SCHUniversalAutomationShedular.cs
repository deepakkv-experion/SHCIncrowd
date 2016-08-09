using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SCHUniversalTashSchedularForAutomation
{
    class SCHUniversalAutomationShedular
    {
        static void Main(string[] args)
        {
            try
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
            catch (Exception ex)
            {

            }
        }
    }
}
