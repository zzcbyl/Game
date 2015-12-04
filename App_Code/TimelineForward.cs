﻿using System;
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

    public TimelineForward(int userId, int actId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from timeline_forward where uid = " + userId.ToString()
            + " and act_id = " + actId.ToString() , Util.ConnectionStringMall);
        if (dt.Rows.Count == 1)
        {
            _fields = dt.Rows[0];
        }
    }

    public TimelineForward[] GetSubForward()
    {
        DataTable dt = DBHelper.GetDataTable(" select * from timeline_forward where fatherid = " + ID.ToString(),
            Util.ConnectionStringMall.Trim());
        TimelineForward[] timelineForwardArr = new TimelineForward[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            timelineForwardArr[i] = new TimelineForward();
            timelineForwardArr[i]._fields = dt.Rows[i];
        }
        return timelineForwardArr;
    }


    public int GetSubForwardNum()
    {
        TimelineForward[] timelineForwardArr = GetSubForward();
        int num = timelineForwardArr.Length;
        foreach (TimelineForward timelineForward in timelineForwardArr)
        {
            num = num + timelineForward.GetSubForwardNum();
        }
        return num;
    }

    public int ID
    {
        get
        {
            return int.Parse(_fields["id"].ToString().Trim());
        }
    }

    public static TimelineForward CreateForward(int userId, int actId, int fatherId)
    {
        string[,] insertParameters =  { {"uid", "int", userId.ToString()}, {"act_id", "int", actId.ToString()}, {"from_id", "int", fatherId.ToString()}};

        TimelineForward timeLineForward; 

        int i = DBHelper.InsertData("timeline_forward", insertParameters, Util.ConnectionStringMall);
        if (i == 1)
        {
            timeLineForward = new TimelineForward(userId, actId);
        }
        else
        {
            timeLineForward = new TimelineForward();
        }
        return timeLineForward;
    }

    
}