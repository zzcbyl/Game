using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for NewYearBox
/// </summary>
public class NewYearBox
{

    public DataRow _field;

    public KeyValuePair<int, int>[] specialBoxSupportNumArray = new KeyValuePair<int, int>[1] { new KeyValuePair<int, int>(4, 100) };

    public int defaultSupportNum = 10;

    public int totalBoxNumber = 9;

    public static string[][] awardArray = { new string[]{"礼品1"}, 
                                   new string[]{"礼品2"},
                                   new string[]{"礼品31","礼品32"},
                                   new string[]{"礼品4"},
                                   new string[]{"礼品5"},
                                   new string[]{"礼品6"},
                                   new string[]{"礼品7"},
                                   new string[]{"礼品8"},
                                   new string[]{"礼品9"}};

    public NewYearBox(int id)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from new_year_box_master where [id] = " + id.ToString().Trim(), Util.ConnectionString);
        if (dt.Rows.Count == 1)
            _field = dt.Rows[0];
        else
            throw new Exception("New year box with id : " + id.ToString() + " is not exists.");
    }

	public NewYearBox(string openId, int actId)
	{
        DataTable dt = DBHelper.GetDataTable(" select * from new_year_box_master where open_id = '" + openId.Trim() + "' and act_id = " + actId.ToString().Trim(), Util.ConnectionString);
        if (dt.Rows.Count == 0)
        {
            string[] currentAwardList = GetRamdomAwardList();
            string currentAwardListJsonStr = "";
            foreach (string awardName in currentAwardList)
            {
                currentAwardListJsonStr = currentAwardListJsonStr + ",{\"award_name\":\"" + awardName.Trim() + "\"}";
            }
            if (currentAwardListJsonStr.StartsWith(","))
                currentAwardListJsonStr = currentAwardListJsonStr.Remove(0, 1);

            string[,] insertParameter = { { "open_id", "varchar", openId.Trim() }, { "act_id", "varchar", actId.ToString().Trim() }, { "award_list_json", "varchar", currentAwardListJsonStr } };
            int i = DBHelper.InsertData("new_year_box_master", insertParameter, Util.ConnectionString.Trim());
            if (i == 1)
            {
                dt = DBHelper.GetDataTable(" select * from new_year_box_master where open_id = '" + openId.Trim() + "' and act_id =  " + actId.ToString().Trim(), Util.ConnectionString);
                _field = dt.Rows[0];
            }
        }
        else
        {
            _field = dt.Rows[0];
        }
	}

    public bool OpenABox(int id)
    {

        if (id >= totalBoxNumber)
            return false;

        int neededSupportNumber = GetNeededSupportNum(id);

        if (CurrentSupportNumber >= neededSupportNumber)
        {
            string[,] insertParameters = { { "master_id", "int", ID.ToString() }, { "box_id", "int", id.ToString().Trim() } };
            int i = DBHelper.InsertData("new_year_box_detail", insertParameters, Util.ConnectionString);
            if (i == 1)
            {
                CurrentSupportNumber = CurrentSupportNumber - neededSupportNumber;
                return true;
            }
        }
        return false;

    }

    public int GetNeededSupportNum(int id)
    {
        if (id >= totalBoxNumber)
            return int.MaxValue;

        int neededSupportNum = defaultSupportNum;

        foreach (KeyValuePair<int, int> specialBox in specialBoxSupportNumArray)
        {
            if (specialBox.Key == id)
            {
                neededSupportNum = specialBox.Value;
                break;
            }
        }

        return neededSupportNum;
    }


/*
    public bool OpenABox(int id)
    {
        if (id > 8)
            return false;
        if (id == 4)
        {
            if (CurrentSupportNumber >= 100)
            {
                string[,] insertParameters = { { "master_id", "int", ID.ToString() }, { "box_id", "int", id.ToString().Trim() } };
                int i = DBHelper.InsertData("new_year_box_detail", insertParameters, Util.ConnectionString);
                if (i == 1)
                {
                    CurrentSupportNumber = CurrentSupportNumber - 100;
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        else
        {
            if (CurrentSupportNumber >= 10)
            {
                string[,] insertParameters = { { "master_id", "int", ID.ToString() }, { "box_id", "int", id.ToString().Trim() } };
                int i = DBHelper.InsertData("new_year_box_detail", insertParameters, Util.ConnectionString);
                if (i == 1)
                {
                    CurrentSupportNumber = CurrentSupportNumber - 10;
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }
        
    }
    */
    public KeyValuePair<int, DateTime>[] GetOpenedBox()
    {
        DataTable dt = DBHelper.GetDataTable(" select * from new_year_box_detail where master_id = " + ID.ToString(), Util.ConnectionString);
        KeyValuePair<int, DateTime>[] openedBoxList = new KeyValuePair<int, DateTime>[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            openedBoxList[i] = new KeyValuePair<int, DateTime>(int.Parse(dt.Rows[i]["box_id"].ToString()), 
                DateTime.Parse(dt.Rows[0]["create_date_time"].ToString().Trim()));
        }
        return openedBoxList;
    }

    public bool Support(string openId)
    {
        if (openId.Trim().Equals(_field["open_id"].ToString().Trim()))
            return false;
        DataTable dt = DBHelper.GetDataTable(" select * from new_year_box_support_list where master_id = " + ID.ToString()
            + " and open_id = '" + openId.Trim() + "'  ", Util.ConnectionString);
        if (dt.Rows.Count == 0)
        {
            string[,] insertParameters = { { "master_id", "int", ID.ToString() }, { "open_id", "varchar", openId.Trim() } };
            int i = DBHelper.InsertData("new_year_box_support_list", insertParameters, Util.ConnectionString);
            if (i == 1)
            {
                CurrentSupportNumber++;
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
        }
    }

    public KeyValuePair<string, DateTime>[] GetSupportList()
    {
        DataTable dt = DBHelper.GetDataTable(" select * from new_year_box_support_list  where master_id = " + ID.ToString(), Util.ConnectionString);
        KeyValuePair<string, DateTime>[] supportList = new KeyValuePair<string,DateTime>[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            supportList[i] = new KeyValuePair<string, DateTime>(dt.Rows[i]["open_id"].ToString().Trim(),
                DateTime.Parse(dt.Rows[i]["create_date_time"].ToString().Trim()));
        }
        return supportList;

    }

    public int ID
    {
        get
        {
            return int.Parse(_field["id"].ToString().Trim());
        }
    }

    public int CurrentSupportNumber
    {
        get
        {
            return int.Parse(_field["current_support_num"].ToString().Trim());
        }
        set
        {
            string[,] updateParameter = { { "current_support_num", "int", value.ToString() } };
            string[,] keyParameter = { { "id", "int", ID.ToString() } };
            DBHelper.UpdateData("new_year_box_master", updateParameter, keyParameter, Util.ConnectionString);
        }
    }

    public static string[] GetRamdomAwardList()
    {
        string[] awardListArray = new string[awardArray.Length];
        for (int i = 0; i < awardListArray.Length; i++)
        {
            int seed = (new Random()).Next(awardArray[i].Length);
            awardListArray[i] = awardArray[i][seed];
        }
        return awardListArray;
    }
}