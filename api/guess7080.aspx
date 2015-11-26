<%@ Page Language="C#" %>
<%@ Import Namespace="System.Runtime.Serialization" %>
<%@ Import Namespace="System.Runtime.Serialization.Json" %>
<%@ Import Namespace="System.IO" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        //GuessFistQuestion.GetQuestionsRandomly(15);
        int season = 1;
        
        if (Request["season"]!=null)
            try
            {
                if (Request["season"].Trim().ToLower().Equals("all"))
                {
                    season = 0;
                }
                else
                    season = int.Parse(Request["season"].Trim());
            }
            catch
            {
                season = 1;
            }
        
        GuessFirst gf = GuessFirst.NewGame(season);
        
        DataContractJsonSerializer dcjs = new DataContractJsonSerializer(typeof(GuessFirst));
        MemoryStream ms = new MemoryStream();
        dcjs.WriteObject(ms, gf);
        Response.Write("{\"status\":0,\"version\":1.0,\"game\":" + Encoding.UTF8.GetString(ms.ToArray())+ "}");
    }
</script>