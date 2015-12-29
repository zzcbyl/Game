<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        string token = Util.GetSafeRequestValue(Request, "token", "527a1ff733375f8074217c73129182ef4be8397b0c398e339c4b2b36bbcdec3fe5782569");
        Users user = new Users(Users.CheckToken(token));
        int id = int.Parse(Util.GetSafeRequestValue(Request, "id", "0"));
        int actId = int.Parse(Util.GetSafeRequestValue(Request, "actid", "1"));
        NewYearBox newYearBox = new NewYearBox();
        if (id == 0)
        {
            try
            {
                newYearBox = new NewYearBox(user.OpenId.Trim(), actId);
            }
            catch(Exception err)
            {
                Response.Write("{\"status\": 1 , \"error_message\":\"" + err.ToString().Trim() + "\"  }");
            }

        }
        else
        {
            newYearBox = new NewYearBox(id);
        }

        string openBoxJson = "";
        KeyValuePair<int, string>[] openedBoxList = newYearBox.GetOpenedBoxWithGift();
        foreach (KeyValuePair<int, string> box in openedBoxList)
        {
            openBoxJson = openBoxJson + ",{\"box_id\":" + box.Key.ToString() + " , \"award_name\":\"" + box.Value.ToString() + "\" }";
        }

        if (openBoxJson.StartsWith(","))
            openBoxJson = openBoxJson.Remove(0, 1);
        /*
        string supportListJson = "";
        foreach (KeyValuePair<string, DateTime> support in newYearBox.GetSupportList())
        {
            supportListJson = supportListJson + ",{\"open_id\" : \"" + support.Key.Trim()
                + "\" , \"support_date\" : \"" + support.Value.ToString() + "\" }";
        }
        if (supportListJson.StartsWith(","))
            supportListJson = supportListJson.Remove(0, 1);
        */
        
        string mainJson = "";
        foreach (DataColumn c in newYearBox._field.Table.Columns)
        {
            mainJson = mainJson + ",\"" + c.Caption.Trim() + "\" : \"" + newYearBox._field[c].ToString().Trim() + "\" ";
        }

        mainJson = "\"status\" : 0 " + mainJson;

        string unAwardJson = "";
        for (int i = openedBoxList.Length; i < NewYearBox.awardTotalList.Length; i++)
        {
            string unAwardSubJson = "";
            foreach (KeyValuePair<string, int> awardSet in NewYearBox.awardTotalList[i].Value)
            {
                unAwardSubJson = unAwardSubJson + ",{\"award_name\":\"" + awardSet.Key.Trim() + "\" }";
            }
            if (unAwardSubJson.StartsWith(","))
                unAwardSubJson = unAwardSubJson.Remove(0, 1);
            unAwardJson = unAwardJson + ",{\"award_list\" : [" + unAwardSubJson.Trim() + "]}";
        }
        if (unAwardJson.Trim().StartsWith(","))
            unAwardJson = unAwardJson.Remove(0, 1);
        
        Response.Write("{" + mainJson + " , \"opened_box\" : [" + openBoxJson + "] , \"un_aquire_awards\" : [" + unAwardJson + "]  }");
        
        
        
    }
</script>