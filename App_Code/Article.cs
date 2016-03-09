using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

/// <summary>
/// Article 的摘要说明
/// </summary>
public class Article
{
	public Article()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}

    public static int Add(string title, string content, string dt, int integral)
    {
        int result = 0;
        string sql = "INSERT INTO m_article(article_title, article_content, article_date, article_integral) VALUES " +
             "('" + title + "', '" + content + "', '" + dt + "', " + integral + ")";
        result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql, null);
        return result;
    }

    public static int AddPv(int articleid)
    {
        int result = 0;
        string sql = "update m_article set article_pv = article_pv + 1 where article_id = " + articleid;
        result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql, null);
        return result;
    }
    public static int AddPv_manual(int articleid, int count)
    {
        int result = 0;
        string sql = "update m_article set article_pv_manual = article_pv_manual + " + count + " where article_id = " + articleid;
        result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql, null);
        return result;
    }

    public static DataTable Get(int articleid)
    {
        DataTable dt = null;
        string sql = "select * from m_article where article_id = " + articleid;
        dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        return dt;
    }

    public static DataTable GetDate()
    {
        DataTable dt = null;
        string sql = "select article_date from dbo.m_article where article_date<>'' group by article_date order by article_date desc";
        dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        return dt;
    }

    public static DataTable GetAll()
    {
        DataTable dt = null;
        string sql = "select * from m_article where article_date<>'' order by article_date desc, article_id ";
        dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        return dt;
    }

}