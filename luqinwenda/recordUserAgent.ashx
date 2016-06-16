<%@ WebHandler Language="C#" Class="recordUserAgent" %>

using System;
using System.Web;

public class recordUserAgent : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string userid = context.Request["userid"].ToString();
        string roomid = context.Request["roomid"].ToString();
        string useragent = context.Request["useragent"].ToString();

        string sql = "insert into m_userAgent(userId,roomId,userAgent) values (" + userid + "," + roomid + ",'" + useragent + "')";
        DBHelper.ExecteNonQuery(Util.ConnectionStringMall, System.Data.CommandType.Text, sql);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
}