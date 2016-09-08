using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for Course
/// </summary>
public class Course
{
    public DataRow _fields;

	public Course()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static int AddNew(string backGroundImageUrl, string title, string lecturer, string lecturerSummary, DateTime courseDate)
    {
        string[,] insertParameters = new string[5, 3];
        insertParameters[0, 0] = "course_headimg";
        insertParameters[0, 1] = "varchar";
        insertParameters[0, 2] = backGroundImageUrl.Trim();

        insertParameters[1, 0] = "course_title";
        insertParameters[1, 1] = "varchar";
        insertParameters[1, 2] = title.Trim();

        insertParameters[2, 0] = "course_lecturer";
        insertParameters[2, 1] = "varchar";
        insertParameters[2, 2] = lecturer.Trim();

        insertParameters[3, 0] = "course_lecturer_summary";
        insertParameters[3, 1] = "varchar";
        insertParameters[3, 2] = lecturerSummary.Trim();

        insertParameters[4, 0] = "course_time";
        insertParameters[4, 1] = "varchar";
        insertParameters[4, 2] = GetChinsesDate(courseDate);

        int i = DBHelper.InsertData("m_course", insertParameters, Util.ConnectionStringMall);
        if (i == 1)
        {
            DataTable dt = DBHelper.GetDataTable(" select max(course_id) from m_course ", Util.ConnectionStringMall);
            if (dt.Rows.Count == 1)
            {
                i = int.Parse(dt.Rows[0][0].ToString());
            }
        }
        return i;
    }

    public static string GetChinsesDate(DateTime date)
    {
        
        string dayOfWeekString = "";
        switch (date.DayOfWeek)
        { 
            case DayOfWeek.Sunday:
                dayOfWeekString = "日";
                break;
            case DayOfWeek.Monday:
                dayOfWeekString = "一";
                break;
            case DayOfWeek.Tuesday:
                dayOfWeekString = "二";
                break;
            case DayOfWeek.Wednesday:
                dayOfWeekString = "三";
                break;
            case DayOfWeek.Thursday:
                dayOfWeekString = "四";
                break;
            case DayOfWeek.Friday:
                dayOfWeekString = "五";
                break;
            case DayOfWeek.Saturday:
                dayOfWeekString = "六";
                break;
            default:
                break;
        }
        string dateString = date.Month.ToString() + "月" + date.Day.ToString().Trim()+"（周"+dayOfWeekString.Trim()+"）";

        return dateString;
    }


}