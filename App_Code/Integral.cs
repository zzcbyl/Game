using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.Sql;

/// <summary>
/// Integral 的摘要说明
/// </summary>
public class Integral
{
	public Integral()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}

    public static int AddIntegral(int userid, int integralVal, string remark, int act_id, int from_userid)
    {
        int result = 0;
        Users user = new Users(userid);
        int integralv = user.Integral + integralVal;
        if (integralv >= 0)
        {
            string sql = "insert into m_integral (integral_userid, integral_cost, integral_remark, act_id, from_userid) VALUES (" + userid + "," + integralVal + ",'" + remark + "'," + act_id + "," + from_userid + ")";
            result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql, null);

            user.Integral = integralv;
        }
        return result;
    }

    //public static int GetBalance(int userid)
    //{
    //    int balance = 0;
    //    string sql = "select top 1 integral_balance from m_integral where integral_userid=" + userid + " order by integral_id desc";
    //    DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionString);
    //    if (dt != null && dt.Rows.Count > 0)
    //        int.TryParse(dt.Rows[0][0].ToString(), out balance);

    //    return balance;
    //}

    public static DataTable GetList(int userid, int fatheruserid, int act_id = 0, string date = null)
    {
        DataTable dt = new DataTable();
        string sql = "select * from m_integral where integral_userid=" + userid;
        if (fatheruserid > 0)
            sql += " and from_userid = " + fatheruserid;
        if (act_id > 0)
            sql += " and act_id=" + act_id;
        if (date != null)
            sql += " and integral_time>=" + Convert.ToDateTime(date).ToString("yyyy-MM-dd") + " and integral_time<" + Convert.ToDateTime(date).AddDays(1).ToString("yyyy-MM-dd");
        sql += " order by integral_id desc";
        dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        return dt;
    }
    
}