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

    public static int addCrowd(int userid, string name, string course, int price, int courseid, string remark = "")
    {
        string sql = "INSERT INTO m_crowd(crowd_userid,crowd_name,crowd_course,crowd_minprice,crowd_remark,crowd_courseid) VALUES" +
            "(@crowd_userid,@crowd_name,@crowd_course,@crowd_minprice,@crowd_remark,@crowd_courseid) ";

        SqlParameter[] parm = new SqlParameter[] { 
            new SqlParameter("@crowd_userid",userid),
            new SqlParameter("@crowd_name",name),
            new SqlParameter("@crowd_course",course),
            new SqlParameter("@crowd_minprice",price),
            new SqlParameter("@crowd_remark",remark),
            new SqlParameter("@crowd_courseid",courseid)
        };

        int result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql, parm);

        return result;
    }

    public static void updCrowd(int crowid, string name, int price, string remark)
    {
        string sql = "update m_crowd set crowd_name=@crowd_name, crowd_minprice=@crowd_minprice, crowd_remark=@crowd_remark where crowd_id="+crowid;

        SqlParameter[] parm = new SqlParameter[] { 
            new SqlParameter("@crowd_name",name),
            new SqlParameter("@crowd_minprice",price),
            new SqlParameter("@crowd_remark",remark)
        };

        DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql, parm);
    }

    public static DataTable getCrowdByUserid(int userid, int courseId)
    {
        string sql = "select * from m_crowd where crowd_userid=" + userid + " and crowd_courseid=" + courseId;
        return DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
    }



    public static int addDonate(int crowdid, int userid, int price, int state, string remark = "")
    {
        string sql = "INSERT INTO m_donate(donate_crowdid, donate_userid, donate_price, donate_remark, donate_state) VALUES" +
            "(@donate_crowdid, @donate_userid, @donate_price, @donate_remark, @donate_state)";

        SqlParameter[] parm = new SqlParameter[] { 
            new SqlParameter("@donate_crowdid", crowdid),
            new SqlParameter("@donate_userid", userid),
            new SqlParameter("@donate_price", price),
            new SqlParameter("@donate_remark", remark),
            new SqlParameter("@donate_state", state)
        };

        int result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql, parm);

        sql = "select top 1 donate_id from m_donate order by donate_id desc";
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

    public static int setTotal(int donateid)
    {
        int result = 0;
        string sql = "select * from m_donate where donate_id=" + donateid;
        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        if (dt != null && dt.Rows.Count > 0)
        {
            int amount = int.Parse(dt.Rows[0]["donate_price"].ToString());
            int crowdid = int.Parse(dt.Rows[0]["donate_crowdid"].ToString());

            sql = "update m_crowd set crowd_balance=crowd_balance+" + amount + " where crowd_id=" + crowdid;
            result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql);
        }
        return result;
    }

    public static DataTable getCourse(int courseId)
    {
        DataTable dt = null;
        string sql = "select * from m_course where course_id=" + courseId;
        dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        return dt;
    }

    public static DataTable getNewCourseId()
    {
        DataTable dt = null;
        string sql = "select top 1 course_id from m_course order by course_id desc";
        dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        return dt;
    }

    public static DataTable getDonateByCrowdid(int crowdid, int state)
    {
        DataTable dt = null;
        string sql = "select * from m_donate where donate_crowdid=" + crowdid + " and donate_state=" + state;
        dt = DBHelper.GetDataTable(sql, Util.ConnectionStringMall);
        return dt;
    }
}