using System;
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

    public static int add(int userid, string name, string course, int price, string remark)
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


}