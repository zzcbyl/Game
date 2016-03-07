<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Data;

public class Handler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string token = "";
        int userid = 0;
        int articleid = 0;
        int fatherid = 0;
        if (context.Request["token"] != null && context.Request["token"].ToString() != "")
        {
            token = context.Request["token"].ToString();
            userid = Users.CheckToken(token);
            if (userid > 0)
            {
                if (context.Request["articleid"] != null && context.Request["articleid"].ToString() != "")
                {
                    articleid = int.Parse(context.Request["articleid"].ToString());
                    DataTable dt = Article.Get(articleid);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        int.TryParse(context.Request["fatheruserid"].ToString(), out fatherid);

                        Util.GetWebContent("http://" + Util.DomainName + "/api/timeline_forward.aspx?token=" + token + "&fatheruserid=" + fatherid + "&actid=" + articleid + "", "get", "", "text/html");
                        Util.GetWebContent("http://" + Util.DomainName + "/api/integral_modify.aspx?token=" + token + "&fatheruserid=" + fatherid + "&articleid=" + articleid, "get", "", "text/html");
                    }
                }
            }
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}