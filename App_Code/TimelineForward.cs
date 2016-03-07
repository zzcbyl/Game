using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for TimelineForward
/// </summary>
public class TimelineForward
{

    public DataRow _fields;

    public TimelineForward()
    { 
    
    }

	public TimelineForward(int id)
	{
        DataTable dt = DBHelper.GetDataTable(" select * from timeline_forward where [id] = " + id.ToString(), Util.ConnectionStringMall);
        if (dt.Rows.Count == 1)
        {
            _fields = dt.Rows[0];
        }
	}

    public TimelineForward(int userId, int actId, int fatherid)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from timeline_forward where uid = " + userId.ToString()
            + " and act_id = " + actId.ToString() + " and from_uid = " + fatherid, Util.ConnectionStringMall);
        if (dt.Rows.Count == 1)
        {
            _fields = dt.Rows[0];
        }
        else
        {
            //CreateForward(userId, actId, 0);
        }
    }

    public TimelineForward[] GetSubForward(int userid, int actid)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from timeline_forward where from_uid = " + userid.ToString() + " and act_id =" + actid,
            Util.ConnectionStringMall.Trim());
        TimelineForward[] timelineForwardArr = new TimelineForward[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            timelineForwardArr[i] = new TimelineForward();
            timelineForwardArr[i]._fields = dt.Rows[i];
        }
        return timelineForwardArr;
    }


    public int GetSubForwardNum(int userid, int actid)
    {
        TimelineForward[] timelineForwardArr = GetSubForward(userid, actid);
        int num = timelineForwardArr.Length;
        //foreach (TimelineForward timelineForward in timelineForwardArr)
        //{
        //    num = num + timelineForward.GetSubForwardNum();
        //}
        //string[,] updateParameters = { { "forward_times", "int", num.ToString() } };
        //string[,] keyParameters = { { "id", "int", ID.ToString() } };
        //DBHelper.UpdateData("timeline_forward", updateParameters, keyParameters, Util.ConnectionStringMall);
        return num;
    }

    public int ID
    {
        get
        {
            return int.Parse(_fields["id"].ToString().Trim());
        }
    }

    public static TimelineForward CreateForward(int userId, int actId, int fatherUId)
    {
        string[,] insertParameters = { { "uid", "int", userId.ToString() }, { "act_id", "int", actId.ToString() }, { "from_uid", "int", fatherUId.ToString() } };

        TimelineForward timeLineForward;

        int i = DBHelper.InsertData("timeline_forward", insertParameters, Util.ConnectionStringMall);
        if (i == 1)
        {
            timeLineForward = new TimelineForward(userId, actId, fatherUId);
        }
        else
        {
            timeLineForward = new TimelineForward();
        }
        return timeLineForward;
    }

    public static void UpdateForwardCount(int userId, int actId, int fatherUId)
    {
        string sql = "update timeline_forward set forward_times = forward_times + 1 where uid = " + userId.ToString()
            + " and act_id = " + actId.ToString() + " and from_uid = " + fatherUId;
        int result = DBHelper.ExecteNonQuery(Util.ConnectionStringMall, CommandType.Text, sql, null);
    }

    //public static void ComputeForwardTimesForOriginUsers(int actId)
    //{
    //    DataTable dt = DBHelper.GetDataTable(" select * from timeline_forward where from_uid = 0 and act_id = " + actId.ToString(), Util.ConnectionStringMall);
    //    foreach (DataRow dr in dt.Rows)
    //    {
    //        if (int.Parse(dr["from_uid"].ToString().Trim()) == 0)
    //        {
    //            TimelineForward timelineForward = new TimelineForward();
    //            timelineForward._fields = dr;
    //            timelineForward.GetSubForwardNum();
    //        }
    //    }
    //}

    
}