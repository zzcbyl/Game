<%@ WebHandler Language="C#" Class="Handler_Article" %>

using System;
using System.Web;
using System.Data;
using System.Web.Script.Serialization;
using System.Collections;

public class Handler_Article : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        int userId = int.Parse(Util.GetSafeRequestValue(context.Request, "userid", "0"));
        int pageSize = int.Parse(Util.GetSafeRequestValue(context.Request, "pagesize", "20"));
        string maxDate = Util.GetSafeRequestValue(context.Request, "maxdate", DateTime.Now.AddDays(1).ToString("yyyy-MM-dd"));

        DataTable dateDt = Article.GetDate(pageSize, Convert.ToDateTime(maxDate));
        DataTable articleDt = Article.GetAll(pageSize, Convert.ToDateTime(maxDate));
        
        ArrayList IDList = new ArrayList();
        DataTable MyDt = Integral.GetList(userId, 0, "article");
        foreach (DataRow item in MyDt.Rows)
        {
            if (!IDList.Contains(item["integral_type_id"].ToString()))
                IDList.Add(item["integral_type_id"].ToString());
        }

        if (dateDt != null && dateDt.Rows.Count > 0)
        {
            maxDate = dateDt.Rows[dateDt.Rows.Count - 1][0].ToString();
            string dataJson = "";
            foreach (DataRow dr in dateDt.Rows)
            {
                string fieldsJson = "\"article_date\":\"" + Convert.ToDateTime(dr["article_date"].ToString().Trim()).ToString("MM月dd日") + "\"";
                string articleJson = "";
                DataRow[] drowArr = articleDt.Select("article_date='" + dr["article_date"].ToString().Trim() + "'");
                foreach (DataRow row in drowArr)
                {
                    string rowJson = "";
                    foreach (DataColumn c in articleDt.Columns)
                    {
                        if (c.Caption.Trim().Equals("article_content"))
                            continue;
                        rowJson = rowJson + ",\"" + c.Caption.Trim() + "\":\"" + row[c].ToString().Trim() + "\"";
                    }
                    if (rowJson.StartsWith(","))
                        rowJson = rowJson.Remove(0, 1);
                    if (IDList.Contains(row["article_id"].ToString()))
                        rowJson += ",\"forward\": 1";
                    else
                        rowJson += ",\"forward\": 0";
                    articleJson = articleJson + ",{" + rowJson + " }";
                }
                if (articleJson.StartsWith(","))
                    articleJson = articleJson.Remove(0, 1);
                fieldsJson = fieldsJson + ",\"date_article_list\":[" + articleJson + "]";
                
                dataJson = dataJson + ",{" + fieldsJson + " }";
            }
            if (dataJson.StartsWith(","))
                dataJson = dataJson.Remove(0, 1);
            context.Response.Write("{\"status\":0 , \"count\": " + dateDt.Rows.Count + " ,\"maxdate\":\"" + maxDate + "\", \"article_list\" : [" + dataJson.Trim() + "] }");
        }
        else
            context.Response.Write("{\"status\":1 , \"count\":0, \"maxdate\":\"" + maxDate + "\" }");
        
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}