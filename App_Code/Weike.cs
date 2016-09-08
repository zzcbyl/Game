using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for Weike
/// </summary>
public class Weike
{

    public DataRow _fields;

	public Weike()
	{
		
	}

    public static int AddNew(DateTime startTime, DateTime endTime, string backgroundImageUrl, string title, string courseIntro, string lecturer,
        string lecturerSummary, string lecturerIntro)
    {
        int courseId = Course.AddNew(backgroundImageUrl.Trim(), title, lecturer, lecturerSummary, startTime);
        return AddNewClassroom(courseId, startTime, endTime, courseIntro, lecturerIntro, backgroundImageUrl);
    }

    public static int AddNewClassroom(int courseId, DateTime startTime, DateTime endTime, string courseIntro, string lecturerIntro, string backgroundImageUrl)
    {
        string[,] insertParameters = new string[6, 3];
        insertParameters[0, 0] = "courseid";
        insertParameters[0, 1] = "int";
        insertParameters[0, 2] = courseId.ToString().Trim();

        insertParameters[1, 0] = "start_date";
        insertParameters[1, 1] = "datetime";
        insertParameters[1, 2] = startTime.ToString();

        insertParameters[2, 0] = "end_date";
        insertParameters[2, 1] = "datetime";
        insertParameters[2, 2] = endTime.ToString();

        insertParameters[3, 0] = "course_intro";
        insertParameters[3, 1] = "varchar";
        insertParameters[3, 2] = courseIntro.Trim();

        insertParameters[4, 0] = "lecturer_intro";
        insertParameters[4, 1] = "varchar";
        insertParameters[4, 2] = lecturerIntro.Trim();

        insertParameters[5, 0] = "audio_bg";
        insertParameters[5, 1] = "varchar";
        insertParameters[5, 2] = backgroundImageUrl.Trim();

        int i = DBHelper.InsertData("chat_room", insertParameters, Util.ConnectionString.Trim());

        if (i == 1)
        {
            i = DBHelper.GetMaxValue("chat_room", "id", Util.ConnectionString.Trim());
        }

        return i;
    }
}