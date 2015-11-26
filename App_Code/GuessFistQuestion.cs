using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Threading;

/// <summary>
/// Summary description for GuessFistQuestion
/// </summary>
public class GuessFistQuestion
{
    public int id = 0;
    public string[] prompt;
    public string promptimg;
    public int answercount = 0;
    public string question = "";
    public string answer = "";
    public char[] options ;


	public GuessFistQuestion()
	{
		

	}

    public static GuessFistQuestion[] GetQuestionsRandomly(int questionCount, int season)
    {
        string sql = " select * from QuickGuessList where  ";// QuickGuessList_season = " + season.ToString();
        if (season == 0)
        {
            sql = sql + "  QuickGuessList_season >1  and  QuickGuessList_season < 7 ";
        }
        else
        {
            sql = sql + " QuickGuessList_season = " + season.ToString();
        }
        SqlDataAdapter da = new SqlDataAdapter(sql, System.Configuration.ConfigurationManager.AppSettings["constr"].Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        Random rnd = new Random(DateTime.Now.Millisecond);
        GuessFistQuestion[] gfqArr = new GuessFistQuestion[questionCount];
        for (int i = 0; i < questionCount && i < dt.Rows.Count ; i++)
        {
            int curIndex = rnd.Next(0, dt.Rows.Count);
            try
            {
                gfqArr[i] = new GuessFistQuestion();
                DataRow dr = dt.Rows[curIndex];
                gfqArr[i].id = int.Parse(dr["QuickGuessList_id"].ToString());
                gfqArr[i].answer = dr["QuickGuessList_answer"].ToString().Trim();
                gfqArr[i].answercount = dr["QuickGuessList_answer"].ToString().Trim().Length;
                gfqArr[i].prompt = new string[4];
                gfqArr[i].prompt[0] = dr["QuickGuessList_memo1"].ToString().Trim();
                gfqArr[i].prompt[1] = dr["QuickGuessList_memo2"].ToString().Trim();
                gfqArr[i].prompt[2] = dr["QuickGuessList_memo3"].ToString().Trim();
                gfqArr[i].prompt[3] = dr["QuickGuessList_memo4"].ToString().Trim();
                gfqArr[i].promptimg = dr["QuickGuessList_memoimg"].ToString().Trim();
                gfqArr[i].question = dr["QuickGuessList_question"].ToString().Trim();

                string optionStr = dr["QuickGuessList_options"].ToString().Trim();
                if (optionStr.Trim().Equals(""))
                {
                    optionStr = dr["QuickGuessList_answer"].ToString().Trim();



                    gfqArr[i].options = new char[24];

                    for (int j = 0; j < optionStr.Length; j++)
                    {
                        gfqArr[i].options[j] = optionStr.Substring(j, 1).ToCharArray()[0];
                    }

                    for (int j = 0; j < 24 - optionStr.Trim().Length; j++)
                    {
                        gfqArr[i].options[j + optionStr.Length] = '测';
                    }
                }
                else
                {

                    gfqArr[i].options = GetOptions(gfqArr[i].answer,
                        ((dr["QuickGuessList_options"].ToString().Trim().Length >= 22) ? dr["QuickGuessList_options"].ToString().Trim() : dr["QuickGuessList_options"].ToString().Trim() + dr["QuickGuessList_memo4"].ToString().Trim()), 
                        24).ToCharArray();
                }
                dt.Rows.RemoveAt(curIndex);
            }
            catch
            {
                i--;
                Thread.Sleep(1000);
            }

        }
        return gfqArr;
    }

    public static GuessFistQuestion[] GetQuestionsRandomly(int questionCount)
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from QuickGuessList  ", System.Configuration.ConfigurationSettings.AppSettings["constr"].Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        Random rnd = new Random(DateTime.Now.Millisecond);
        GuessFistQuestion[] gfqArr = new GuessFistQuestion[questionCount];
        for (int i = 0; i < questionCount; i++)
        {
            int curIndex = rnd.Next(0, dt.Rows.Count);
            try
            {
                gfqArr[i] = new GuessFistQuestion();
                DataRow dr = dt.Rows[curIndex];
                gfqArr[i].id = int.Parse(dr["QuickGuessList_id"].ToString());
                gfqArr[i].answer = dr["QuickGuessList_answer"].ToString().Trim();
                gfqArr[i].answercount = dr["QuickGuessList_answer"].ToString().Trim().Length;
                gfqArr[i].prompt = new string[4];
                gfqArr[i].prompt[0] = dr["QuickGuessList_memo1"].ToString().Trim();
                gfqArr[i].prompt[1] = dr["QuickGuessList_memo2"].ToString().Trim();
                gfqArr[i].prompt[2] = dr["QuickGuessList_memo3"].ToString().Trim();
                gfqArr[i].prompt[3] = dr["QuickGuessList_memo4"].ToString().Trim();
                gfqArr[i].promptimg = dr["QuickGuessList_memoimg"].ToString().Trim();
                gfqArr[i].question = dr["QuickGuessList_question"].ToString().Trim();

                string optionStr = dr["QuickGuessList_options"].ToString().Trim();
                if (optionStr.Trim().Equals(""))
                {
                    optionStr = dr["QuickGuessList_answer"].ToString().Trim();



                    gfqArr[i].options = new char[24];

                    for (int j = 0; j < optionStr.Length; j++)
                    {
                        gfqArr[i].options[j] = optionStr.Substring(j, 1).ToCharArray()[0];
                    }

                    for (int j = 0; j < 24 - optionStr.Trim().Length; j++)
                    {
                        gfqArr[i].options[j + optionStr.Length] = '测';
                    }
                }
                else
                {

                    gfqArr[i].options = GetOptions(gfqArr[i].answer, dr["QuickGuessList_options"].ToString().Trim(), 24).ToCharArray();
                }
                dt.Rows.RemoveAt(curIndex);
            }
            catch
            {
                i--;
                Thread.Sleep(1000);
            }

        }
        return gfqArr;
    }


   
    public static string GetOptions(string answer, string oriOptions, int count)
    {
        Random rnd = new Random(DateTime.Now.Millisecond);
        char[] oriOptionsArr = (answer + oriOptions).ToCharArray();
        /*
        string answerAndOptionString = answer+oriOptions;

        if (answerAndOptionString.Length > count)
            oriOptionsArr = (answer + oriOptions).Substring(0, count).ToCharArray();
        else
            oriOptionsArr = (answer + oriOptions).ToCharArray();
         */ 

        string avoidDuplicateCharString = "";
        
        foreach (char c in oriOptionsArr)
        {
            avoidDuplicateCharString = avoidDuplicateCharString + c.ToString();
        }
        

        avoidDuplicateCharString = ((avoidDuplicateCharString.Length > 24) ?
            avoidDuplicateCharString.Substring(0, 24) : avoidDuplicateCharString);

        oriOptionsArr = avoidDuplicateCharString.ToCharArray();
        char[] curOptionsArr = (char[])oriOptionsArr.Clone();
        string ret = "";
        for (int i = 0; i < oriOptionsArr.Length; i++)
        {
            int num = rnd.Next(0, curOptionsArr.Length - 1);
            ret = ret + curOptionsArr[num].ToString();
            string newOptionString = "";
            for (int j = 0; j < curOptionsArr.Length; j++)
            {
                if (j != num)
                {
                    newOptionString = newOptionString+curOptionsArr[j].ToString().Trim();
                }
            }
            curOptionsArr = newOptionString.ToCharArray();
        }

        return ret;
    }



}