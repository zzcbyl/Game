<%@ WebHandler Language="C#" Class="delayHandler" %>

using System;
using System.Web;

public class delayHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        System.Threading.Thread.Sleep(5000);
        context.Response.Write("1");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}