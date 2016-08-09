using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Data.OleDb;
using System.IO;
using System.Web.Script.Serialization;

namespace SCHUniversalReportAndImport
{
    public partial class ImportExcel : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Rtname"] == null)
            {
                Session.Clear();
                Response.Redirect("login.aspx");
            }

        }
        protected void btnFileUpload_Click(object sender, EventArgs e)
        {
            try
            {
                if (flUpload.HasFile)
                {
                    string path = Server.MapPath("~/Import");
                    DirectoryInfo directory = new DirectoryInfo(path);
                    if (directory.Exists == false)
                    {
                        directory.Create();
                    }
                    string filename = Path.Combine(path, flUpload.FileName);
                    string extension = System.IO.Path.GetExtension(flUpload.FileName);
                    flUpload.SaveAs(filename);

                    if (ddlImportType.SelectedValue != "1")
                    {
                        string connectionString = "";
                        if (extension == ".xls")
                        {
                            connectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filename + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"";
                        }
                        else if (extension == ".xlsx")
                        {
                            connectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filename + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"";
                        }

                        //Create OleDB Connection and OleDb Command
                        OleDbConnection con = new OleDbConnection(connectionString);
                        OleDbCommand cmd = new OleDbCommand();
                        cmd.CommandType = System.Data.CommandType.Text;
                        cmd.Connection = con;
                        OleDbDataAdapter dAdapter = new OleDbDataAdapter(cmd);
                        DataTable dtExcelRecords = new DataTable();
                        con.Open();
                        DataTable dtExcelSheetName = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                        cmd.CommandText = "SELECT * FROM  [Sheet1$] ";
                        dAdapter.SelectCommand = cmd;
                        dAdapter.Fill(dtExcelRecords);
                        //con.ConnectionTimeout = 15;
                        con.Close();
                        if (ddlImportType.SelectedValue == "5")
                        {
                            UpdateProjectStatus(dtExcelRecords);
                        }
                        else
                        {
                            UpdatePanelist(dtExcelRecords);
                        }
                    }
                    else
                    {
                        InsertPanelist(filename);
                    }
                  
                  
                }
                else
                {
                    lblResult.Text = "Please select Excel file";
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        private void InsertPanelist(string Path)
        {
            lblResult.Text = "";
            lblMessage.Text = "";
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
            DataSet ds = new DataSet();
            try
            {
                con.Open();

                SqlCommand command = new SqlCommand("ImportPanelistToDB", con);
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 500000;
                command.Parameters.Add(new SqlParameter("@Path", Path));
                command.Parameters.Add(new SqlParameter("@PanelId", ConfigurationManager.AppSettings["panelid"]));
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                adapter.Fill(ds);
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = ddlImportType.SelectedItem + " Successfully.";
                        if (ddlImportType.SelectedValue == "1")
                        {
                            lblResult.Text = "Total Import Count : " + ds.Tables[0].Rows[0][0].ToString() + " <br/><br/> Total Insert Count : " + ds.Tables[0].Rows[0][1].ToString();
                        }
                    }
                }
                else
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "Failed to " + ddlImportType.SelectedItem;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                con.Close();
            }

        }
        private void UpdatePanelist(DataTable dtPanelist)
        {
            lblResult.Text = "";
            lblMessage.Text = "";
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
            DataSet ds = new DataSet();
            try
            {
                con.Open();

                SqlCommand command = new SqlCommand("UpdatePanelistMasterStatus", con);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@ImportType", ddlImportType.SelectedValue));
                command.Parameters.Add(new SqlParameter("@IdentifierList", dtPanelist));

                SqlDataAdapter adapter = new SqlDataAdapter(command);
                adapter.Fill(ds);
                if (ds.Tables.Count > 0)
                {
                    if (Convert.ToInt32(ds.Tables[0].Rows[0][0]) > 0)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = ddlImportType.SelectedItem + " Successfully.";
                        if (ddlImportType.SelectedValue == "1")
                        {
                            lblResult.Text = "Total Import Count : " + dtPanelist.Rows.Count + " <br/><br/> Total Insert Count : " + ds.Tables[0].Rows[0][1].ToString();
                        }
                    }
                }
                else
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "Failed to " + ddlImportType.SelectedItem;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                con.Close();
            }

        }

        private void UpdateProjectStatus(DataTable dtProject)
        {
            lblResult.Text = "";
            lblMessage.Text = "";
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
            DataSet ds = new DataSet();
            try
            {
                con.Open();

                SqlCommand command = new SqlCommand("UpdateProjectStatusToClose", con);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@ProjectList", dtProject));

                SqlDataAdapter adapter = new SqlDataAdapter(command);
                adapter.Fill(ds);
                if (ds.Tables.Count > 0)
                {
                    if (Convert.ToInt32(ds.Tables[0].Rows[0][0]) > 0)
                    {
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        lblMessage.Text = "Project status changed successfully.";
                    }
                }
                else
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    lblMessage.Text = "Failed to update the status";
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                con.Close();
            }

        }
        
        protected void lnkBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("reports.aspx");
        }

        protected void logOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("login.aspx");
        }

    }


    
}