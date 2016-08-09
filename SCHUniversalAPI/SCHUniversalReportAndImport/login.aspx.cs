using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
namespace SCHUniversalReportAndImport
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (ConfigurationManager.AppSettings["username"].ToString() == txtUserName.Text && ConfigurationManager.AppSettings["password"].ToString() == txtPassword.Text)
            {
                Session["Rtname"] = txtUserName.Text;
                Response.Redirect("reports.aspx");
            }
            else
            {
                lblMessage.Text = "Invalid UserName/Password";
            }
        }
    }
}