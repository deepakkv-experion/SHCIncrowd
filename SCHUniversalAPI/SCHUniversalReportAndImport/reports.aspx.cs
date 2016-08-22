using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Text;
using System.Data.OleDb;
using System.IO;

namespace SCHUniversalReportAndImport
{
    public partial class reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Rtname"] != null)
            {
                logOut.Visible = true;
                if (!IsPostBack)
                {
                    txtDateFrom.Text = System.DateTime.Now.AddHours(-24).ToString("MM/dd/yyyy");
                    txtDateTo.Text = System.DateTime.Now.ToString("MM/dd/yyyy");
                    GetSearchResult(txtDateFrom.Text, txtDateTo.Text, ddlProjectStatus.SelectedValue);
                }
                else
                {
                    lblLastDataMsg.Visible = false;
                }
            }
            else
            {
                Session.Clear();
                Response.Redirect("login.aspx");
            }

        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string dateFrom = txtDateFrom.Text;
            string dateTo = txtDateTo.Text;
            GetSearchResult(dateFrom, dateTo, ddlProjectStatus.SelectedValue);
            lblMessage.Text = string.Empty;
        }

        private void GetSearchResult(string dateFrom, string dateTo, string status)
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
            try
            {
                lblTotRespondent.Text = "";
                lblTotComplete.Text = "";
                lblTotProject.Text = "";
                grdSearch.DataSource = null;
                grdSearch.DataBind();
                btnClose.Visible = false;

                con.Open();
                SqlCommand command = new SqlCommand("GetProjectSearchDetails", con);
                command.CommandType = CommandType.StoredProcedure;
                if (!string.IsNullOrEmpty(dateFrom))
                {
                    ////dateFrom
                    command.Parameters.Add(new SqlParameter("@DateFrom", dateFrom));

                }
                if (!string.IsNullOrEmpty(dateTo))
                {
                    ////dateTo
                    command.Parameters.Add(new SqlParameter("@DateTo", dateTo));
                }
                if (ddlProjectStatus.SelectedValue != "0")
                {
                    ////status
                    command.Parameters.Add(new SqlParameter("@StatusId", status));
                }

                SqlDataAdapter adapter = new SqlDataAdapter(command);
                DataSet dsSearchResult = new DataSet();
                adapter.Fill(dsSearchResult);
                if (dsSearchResult.Tables.Count > 0)
                {

                    if (dsSearchResult.Tables[0].Rows.Count > 0)
                    {
                        lblTotRespondent.Text = dsSearchResult.Tables[0].Rows[0]["RespondentsCount"].ToString();
                        lblTotComplete.Text = dsSearchResult.Tables[0].Rows[0]["CompletesCount"].ToString();
                    }

                    ////if (dsSearchResult.Tables[2].Rows.Count > 0)
                    ////{
                    ////    ViewState["QueryData"] = dsSearchResult.Tables[2];
                    ////}

                    // New Requirement
                    ////if (dsSearchResult.Tables[3].Rows.Count > 0)
                    ////{
                    ////    ViewState["QueryDataForHono"] = dsSearchResult.Tables[3];
                    ////}

                    if (dsSearchResult.Tables[1].Rows.Count > 0)
                    {
                        grdSearch.DataSource = dsSearchResult.Tables[1];
                        grdSearch.DataBind();
                        lblTotProject.Text = dsSearchResult.Tables[1].Rows.Count.ToString();
                        btnClose.Visible = true;
                    }



                }

            }
            catch (Exception ex)
            {
            }
            finally
            {
                con.Close();
            }
        }

        protected void grdSearch_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    string projectId = grdSearch.DataKeys[e.Row.RowIndex].Values[0].ToString();
                    //string queryId = grdSearch.DataKeys[e.Row.RowIndex].Values[1].ToString();
                    GridView grdQuery = (GridView)e.Row.FindControl("grdQuery");
                    if (!string.IsNullOrEmpty(projectId))
                    {
                        //// if (ViewState["QueryData"] != null)
                        // New Requirement
                        if (ViewState["QueryDataForHono"] != null)
                        {
                            /////ViewState["QueryData"] as DataTable
                            // New Requirement
                            DataTable dt = ViewState["QueryDataForHono"] as DataTable;
                            DataRow[] drArray = dt.Select("projectId = " + projectId);
                            if (drArray.Length > 0)
                            {
                                DataTable dtQuery = drArray.CopyToDataTable();
                                grdQuery.DataSource = dtQuery;
                                grdQuery.DataBind();
                            }
                            else
                            {
                                grdQueryInit(grdQuery);
                            }

                        }
                        else
                        {
                            grdQueryInit(grdQuery);
                        }
                    }
                    else
                    {
                        grdQueryInit(grdQuery);
                    }


                }

            }
            catch (Exception ex)
            {

                throw;
            }


        }

        private void grdQueryInit(GridView grdQuery)
        {
            //DataSet ds = new DataSet();
            //DataTable dt = new DataTable();
            //DataRow dr = dt.NewRow();
            //dt.Columns.Add("QueryId");
            //dt.Columns.Add("Total Respondents");
            //dt.Columns.Add("Completes Count");
            //dt.Columns.Add("Quota Count");
            //dt.Columns.Add("Terminate Count");
            //dt.Columns.Add("Total Clicks");
            //dt.Columns.Add("Create Date");
            //dt.Columns.Add("SpecialityId");
            //dt.Columns.Add("SpecialityOptionName");
            //dt.Columns.Add("SampleRatio");
            //dt.Columns.Add("CompleteGroup");
            //dt.Columns.Add("ReqN");
            //dr["QueryId"] = string.Empty;
            //dr["Total Respondents"] = string.Empty;
            //dr["Completes Count"] = string.Empty;
            //dr["Quota Count"] = string.Empty;
            //dr["Terminate Count"] = string.Empty;
            //dr["Total Clicks"] = string.Empty;
            //dr["Create Date"] = string.Empty;
            //dr["SpecialityId"] = string.Empty;
            //dr["SpecialityOptionName"] = string.Empty;
            //dr["SampleRatio"] = string.Empty;
            //dr["CompleteGroup"] = string.Empty;
            //dr["ReqN"] = string.Empty;

            // New Requirement
            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            DataRow dr = dt.NewRow();
            dt.Columns.Add("HonorariumRateLevel");
            dt.Columns.Add("Completes Count");
            dr["HonorariumRateLevel"] = string.Empty;
            dr["Completes Count"] = string.Empty;
            dt.Rows.Add(dr);
            ds.Tables.Add(dt);
            grdQuery.DataSource = ds;
            grdQuery.DataBind();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {

            lblTotComplete.Text = "0";
            lblTotProject.Text = "0";
            lblTotRespondent.Text = "0";
            grdSearch.DataSource = null;
            grdSearch.DataBind();

        }


        protected void logOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("login.aspx");
        }

        protected void lnkUpload_Click(object sender, EventArgs e)
        {
            Response.Redirect("importExcel.aspx");
        }

        protected void grdSearch_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Close")
            {
                string projectId = e.CommandArgument.ToString();
                // UpdateProjectStatus(projectId);
            }
        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            StringBuilder projectIds = new StringBuilder();

            for (int i = 0; i < grdSearch.Rows.Count; i++)
            {
                GridViewRow row = grdSearch.Rows[i];
                bool isChecked = ((CheckBox)row.FindControl("chkClose")).Checked;

                if (isChecked)
                {
                    HiddenField hdnProjectId = (HiddenField)row.FindControl("hdnProjectId");
                    projectIds.Append(hdnProjectId.Value);
                    projectIds.Append(",");
                }
            }
            string ids = string.Empty;
            ids = projectIds.ToString();
            if (!string.IsNullOrEmpty(ids))
            {
                UpdateProjectStatus(ids);
            }
        }

        private void UpdateProjectStatus(string projectIds)
        {

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["SCHUniversal"].ToString());
            DataSet ds = new DataSet();
            try
            {
                con.Open();

                SqlCommand command = new SqlCommand("UpdateProjectToClose", con);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add(new SqlParameter("@ProjectId", projectIds));

                int result = command.ExecuteNonQuery();
                if (result > 0)
                {
                    string dateFrom = txtDateFrom.Text;
                    string dateTo = txtDateTo.Text;
                    GetSearchResult(dateFrom, dateTo, ddlProjectStatus.SelectedValue);
                    lblMessage.Text = "Project closed successfully.";
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
    }
}