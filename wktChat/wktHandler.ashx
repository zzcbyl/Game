<%@ WebHandler Language="C#" Class="wktHandler" %>

using System;
using System.Web;
using System.Data;
using System.Collections.Generic;

public class wktHandler : IHttpHandler {
    private HttpRequest Request;
    private HttpResponse Response;
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        Request = context.Request;
        Response = context.Response;
        
        if (context.Request["type"] != null)
        {
            switch (context.Request["type"].ToString())
            {
                case "getlist":
                    getList(context);
                    break;
                case "insert":
                    insertData();
                    break;
                default:
                    break;
            }
        }
    }

    
    private void getList(HttpContext context)
    {
        string roomid = Request["roomid"].ToString();
        DataTable dt = DBHelper.GetDataTable("select * from ChatList where room_id=" + roomid, Util.ConnectionString);
        string jsonStr = "";
        foreach (DataRow row in dt.Rows)
        {
            string fieldStr = "";
            foreach (DataColumn column in dt.Columns)
            {
                fieldStr = fieldStr + ",\"" + column.Caption.ToString() + "\":\"" + row[column].ToString() + "\"";
            }
            if (fieldStr.StartsWith(","))
                fieldStr = fieldStr.Remove(0, 1);
            jsonStr = jsonStr + ",{" + fieldStr + "}";
        }
        if (jsonStr.StartsWith(","))
            jsonStr = jsonStr.Remove(0, 1);
        Response.Write("{\"status\":0 , \"count\": " + dt.Rows.Count.ToString() + " , \"chat_data\" : [" + jsonStr.Trim() + "] }");
    }

    private void insertData()
    {
        if (Request["voiceid"] != null)
        {
            int roomid = 1;
            int userid = 1;
            string voiceid = Request["voiceid"].ToString();
            KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] parameters = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[]{ 
                new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("room_id", new KeyValuePair<SqlDbType, object>(SqlDbType.Int,(object)roomid)),
                new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("from_userid", new KeyValuePair<SqlDbType, object>(SqlDbType.Int,(object)userid)),
                new KeyValuePair<string, KeyValuePair<SqlDbType, object>>("chat_voice", new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar,(object)voiceid))
            };

            int result = DBHelper.InsertData("ChatList", parameters, Util.ConnectionString);
            Response.Write("{\"status\":0 , \"result\":\"" + result + "\"}");
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}