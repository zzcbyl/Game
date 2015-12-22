<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int actId = int.Parse(Util.GetSafeRequestValue(Request, "actid", "2"));
        DataTable dtCamp = DBHelper.GetDataTable("select * from random_awards where award = '“我要学演说”冬令营免费参营券' "
            + " and act_id = " + actId.ToString() + " and create_date_time < getdate() order by create_date_time desc ", Util.ConnectionString);
        DataTable dtBook = DBHelper.GetDataTable("select * from random_awards where (award like '%烦恼%' or award like '%长大%' ) "
            + " and act_id = " + actId.ToString() + " 1 and create_date_time < getdate() order by create_date_time desc ", Util.ConnectionString);
        DataTable dtCoupon = DBHelper.GetDataTable("select * from random_awards where award like '%优惠券%'  "
            + " and act_id = " + actId.ToString() + " and create_date_time < getdate() order by create_date_time desc ", Util.ConnectionString);
        DataTable dt = dtCamp.Clone();

        foreach (DataRow drCamp in dtCamp.Rows)
        {
            DataRow dr = dt.NewRow();
            foreach (DataColumn dc in dt.Columns)
            {
                dr[dc] = drCamp[dc.Caption];   
            }
            dt.Rows.Add(dr);
        }

        foreach (DataRow drBook in dtBook.Rows)
        {
            DataRow dr = dt.NewRow();
            foreach (DataColumn dc in dt.Columns)
            {
                dr[dc] = drBook[dc.Caption];   
            }
            dt.Rows.Add(dr);
        }

        foreach (DataRow drCoupon in dtCoupon.Rows)
        {
            DataRow dr = dt.NewRow();
            foreach (DataColumn dc in dt.Columns)
            {
                dr[dc] = drCoupon[dc.Caption];
            }
            dt.Rows.Add(dr);
        }
        string awardedOpenId = "";
        int i = 0;
        foreach (DataRow dr in dt.Rows)
        {
            
            string fieldsJson = "";
            foreach (DataColumn c in dt.Columns)
            {
                fieldsJson = fieldsJson + ",\"" + c.Caption.Trim() + "\":\"" + dr[c].ToString().Trim() + "\"";
                
            }
            if (fieldsJson.StartsWith(","))
                fieldsJson = fieldsJson.Remove(0, 1);
            awardedOpenId = awardedOpenId + ",{" + fieldsJson + " }";
            i++;
            if (i > 60)
                break;
        }
        if (awardedOpenId.StartsWith(","))
            awardedOpenId = awardedOpenId.Remove(0, 1);
        Response.Write("{\"status\":0 , \"count\": " + dt.Rows.Count.ToString() + " , \"awarded_users\" : [" + awardedOpenId.Trim() + "] }");
        /*
        DataTable dt = DBHelper.GetDataTable(" select * from random_awards where is_win = 1 and act_id = 1 ", Util.ConnectionString);
        string awardedOpenId = "";
        foreach (DataRow dr in dt.Rows)
        {
            string fieldsJson = "";
            foreach (DataColumn c in dt.Columns)
            {
                fieldsJson = fieldsJson + ",\"" + c.Caption.Trim() + "\":\"" + dr[c].ToString().Trim() + "\""; 
            }
            if (fieldsJson.StartsWith(","))
                fieldsJson = fieldsJson.Remove(0,1);
            awardedOpenId = awardedOpenId + ",{" + fieldsJson  + " }";
        }
        if (awardedOpenId.StartsWith(","))
            awardedOpenId = awardedOpenId.Remove(0, 1);
        Response.Write("{\"status\":0 , \"count\": " + dt.Rows.Count.ToString() + " , \"awarded_users\" : [" + awardedOpenId.Trim() + "] }");
        */
    }
</script>
