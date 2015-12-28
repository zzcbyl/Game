<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "d4a893f6c7bba58696e2039051873f758882b979a6ef1ea2810b99d4fad911e0c025b5d2");
        Users user = new Users(Users.CheckToken(token));
        int id = int.Parse(Util.GetSafeRequestValue(Request, "id", "0"));
        int actId = int.Parse(Util.GetSafeRequestValue(Request, "actid", "1"));
        NewYearBox newYearBox;
        if (id == 0)
        {
            newYearBox = new NewYearBox(user.OpenId.Trim(), actId);

        }
        else
        {
            newYearBox = new NewYearBox(id);
        }

        string openBoxJson = "";
        foreach (KeyValuePair<int, DateTime> box in newYearBox.GetOpenedBox())
        {
            openBoxJson = openBoxJson + ",{\"box_id\":" + box.Key.ToString() + " , \"open_date\":\"" + box.Value.ToString() + "\" }";
        }

        if (openBoxJson.StartsWith(","))
            openBoxJson = openBoxJson.Remove(0, 1);

        string supportListJson = "";
        foreach (KeyValuePair<string, DateTime> support in newYearBox.GetSupportList())
        {
            supportListJson = supportListJson + ",{\"open_id\" : \"" + support.Key.Trim()
                + "\" , \"support_date\" : \"" + support.Value.ToString() + "\" }";
        }
        if (supportListJson.StartsWith(","))
            supportListJson = supportListJson.Remove(0, 1);

        string mainJson = "";
        foreach (DataColumn c in newYearBox._field.Table.Columns)
        {
            if (c.Caption.Trim().Equals("award_list_json"))
            {
                mainJson = mainJson + ",\"award_list\" : [" + newYearBox._field[c].ToString().Trim() + "] ";
            }
            else
            {
                mainJson = mainJson + ",\"" + c.Caption.Trim() + "\" : \"" + newYearBox._field[c].ToString().Trim() + "\" ";
            }
        }

        mainJson = "\"status\" : 0 " + mainJson;

        Response.Write("{" + mainJson + " , \"opened_box\" : [" + openBoxJson + "] , \"support_list\" : ["
            + supportListJson + "]  }");
        
        
        
    }
</script>