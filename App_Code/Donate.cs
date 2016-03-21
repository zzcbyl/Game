﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Donate 的摘要说明
/// </summary>
public class Donate
{
	public Donate()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}

    public static int addCrowd(int userid, string name, string course, int price, string remark = "")
    {
        string sql = "INSERT INTO m_crowd(crowd_userid,crowd_name,crowd_course,crowd_minprice,crowd_remark) VALUES" +
            "(@crowd_userid,@crowd_name,@crowd_course,@crowd_minprice,@crowd_remark) ";

        SqlParameter[] parm = new SqlParameter[] { 
            new SqlParameter("@crowd_userid",userid),
            new SqlParameter("@crowd_name",name),
            new SqlParameter("@crowd_course",course),
            new SqlParameter("@crowd_minprice",price),
            new SqlParameter("@crowd_remark",remark)
        };

        int result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql, parm);

        return result;
    }

    public static DataTable getCrowdByUserid(int userid)
    {
        string sql = "select * from m_crowd where crowd_userid=" + userid;
        return DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
    }



    public static int addDonate(int crowdid, int userid, int price, string remark = "")
    {
        string sql = "INSERT INTO m_donate(donate_crowdid, donate_userid, donate_price, donate_remark) VALUES" +
            "(@donate_crowdid, @donate_userid, @donate_price, @donate_remark)";

        SqlParameter[] parm = new SqlParameter[] { 
            new SqlParameter("@donate_crowdid", crowdid),
            new SqlParameter("@donate_userid", userid),
            new SqlParameter("@donate_price", price),
            new SqlParameter("@donate_remark", remark)
        };

        int result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql, parm);

        sql = "select top 1 donate_id from m_donate ordre by donate_id desc";
        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        if (dt != null && dt.Rows.Count > 0)
        {
            result = int.Parse(dt.Rows[0][0].ToString());
        }

        return result;
    }

    public static int updPayState(int donateid)
    {
        string sql = "update m_donate set donate_paystate = 1, donate_paysuccesstime='" + DateTime.Now.ToString()
            + "' where donate_id=" + donateid + " and donate_paystate = 0";
        int result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql);
        return result;
    }

}