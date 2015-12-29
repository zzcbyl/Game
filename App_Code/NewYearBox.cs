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

    /*
    public static KeyValuePair<int, int>[] specialBoxSupportNumArray 
        = new KeyValuePair<int, int>[] { new KeyValuePair<int, int>(0, 10),
        new KeyValuePair<int, int>(1, 20),
        new KeyValuePair<int, int>(2, 20),
        new KeyValuePair<int, int>(8, 100)};
    */
    //public static int defaultSupportNum = 30;

    //public static int totalBoxNumber = 7;

    /*
    public static string[][] awardArray = { new string[]{"10元卢勤书城抵用券"}, 
                                   new string[]{"卢勤著作：《和烦恼说再见》图书1本"},
                                   new string[]{"《知心姐姐杂志》2016年1月季度刊3本"},
                                   new string[]{"5元卢勤书城抵用券1张"},
                                   new string[]{"卢勤著作：《长大不容易》图书1本"},
                                   new string[]{"卢勤著作：《告诉孩子，你真棒》图书1本"},
                                   new string[]{"卢勤著作：《把孩子培养成财富》图书1本"},
                                   new string[]{"《家庭教育专题讲座》典藏光盘一套"},
                                   new string[]{"星空侠儿童安全电话智能手表"}};
    */
    public static KeyValuePair<int, KeyValuePair<string, int>[]>[] awardTotalList
        = new KeyValuePair<int, KeyValuePair<string, int>[]>[] {
            new KeyValuePair<int, KeyValuePair<string, int>[]>(5, new KeyValuePair<string,int>[1] { new KeyValuePair<string, int> ("10元卢勤书城抵用券1张", 20000) }),
            new KeyValuePair<int, KeyValuePair<string, int>[]>(15, new KeyValuePair<string,int>[2] { new KeyValuePair<string, int> ("《家庭教育专题讲座》典藏光盘一套", 300), new KeyValuePair<string, int>("2016夏令营100元抵用券",20000) }),
            new KeyValuePair<int, KeyValuePair<string, int>[]>(20, new KeyValuePair<string,int>[1] { new KeyValuePair<string, int> ("5元卢勤书城抵用券1张", 20000) }),
            new KeyValuePair<int, KeyValuePair<string, int>[]>(25, new KeyValuePair<string,int>[1] { new KeyValuePair<string, int> ("卢勤著作：《和烦恼说再见》图书1本", 20000) }),
            new KeyValuePair<int, KeyValuePair<string, int>[]>(40, new KeyValuePair<string,int>[2] { new KeyValuePair<string, int> ("卢勤著作：《长大不容易》图书1本", 500), new KeyValuePair<string, int>("2016夏令营500元抵用券",20000) }),
            new KeyValuePair<int, KeyValuePair<string, int>[]>(100, new KeyValuePair<string,int>[2] { new KeyValuePair<string, int> ("星空侠儿童安全电话智能手表（价值586元）", 70), new KeyValuePair<string, int>("2016夏令营1000元抵用券",20000)}),
            new KeyValuePair<int, KeyValuePair<string, int>[]>(200, new KeyValuePair<string,int>[2] { new KeyValuePair<string, int> ("微鲸43吋4K高清晰智能电视小钢炮", 10), new KeyValuePair<string, int>("2016夏令营3000元抵用券",10)})
        };

    public NewYearBox()
    { 
    
    }

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
            DataTable dtMax = DBHelper.GetDataTable(" select max([id]) from new_year_box_master ", Util.ConnectionString.Trim());
            if (dtMax.Rows.Count > 0)
            {
                int maxId = 0;
                try
                {
                    maxId = int.Parse(dtMax.Rows[0][0].ToString().Trim());
                }
                catch
                { 
                
                }
                dtMax.Dispose();
                if (maxId > 9999)
                {
                    throw new Exception("Box id is overflow");
                }
            }
            string[,] insertParameter = { { "open_id", "varchar", openId.Trim() }, { "act_id", "varchar", actId.ToString().Trim() }};
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


    public int GetNeededSupportNum()
    {
        string[] aquiredAwardList = AquiredAwardList;
        try
        {
            return awardTotalList[aquiredAwardList.Length].Key;
        }
        catch
        {
            return int.MaxValue;
        }
    }

    public bool OpenABox(int id)
    {

        if (id >= awardTotalList.Length)
            return false;

        int neededSupportNumber = GetNeededSupportNum();

        if (CurrentSupportNumber >= neededSupportNumber)
        {
            string[,] insertParameters = { { "master_id", "int", ID.ToString() }, 
                                         { "box_id", "int", id.ToString().Trim() },
                                         { "award_name", "varchar", NextAwardName.Trim()}};
            int i = DBHelper.InsertData("new_year_box_detail", insertParameters, Util.ConnectionString);
            if (i == 1)
            {
                CurrentSupportNumber = CurrentSupportNumber - neededSupportNumber;
                return true;
            }
        }
        return false;

    }
    /*
    public static int GetNeededSupportNum(int id)
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
    }*/

    


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

    public KeyValuePair<int, string>[] GetOpenedBoxWithGift()
    {
        DataTable dt = DBHelper.GetDataTable(" select * from new_year_box_detail where master_id = " 
            + ID.ToString() + "  order by  create_date_time desc ", Util.ConnectionString);
        KeyValuePair<int, string>[] openedBoxList = new KeyValuePair<int, string>[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            openedBoxList[i] = new KeyValuePair<int, string>(int.Parse(dt.Rows[i]["box_id"].ToString().Trim()), dt.Rows[i]["award_name"].ToString().Trim());

        }
        return openedBoxList;
    }



    public bool Support(string openId, string source)
    {
        if (openId.Trim().Equals(_field["open_id"].ToString().Trim()))
            return false;
        DataTable dt = DBHelper.GetDataTable(" select * from new_year_box_support_list where master_id = " + ID.ToString()
            + " and open_id = '" + openId.Trim() + "'  ", Util.ConnectionString);
        if (dt.Rows.Count == 0)
        {
            string[,] insertParameters = { { "master_id", "int", ID.ToString() }, 
                                         { "open_id", "varchar", openId.Trim() },
                                         { "source", "varchar", source.Trim() }};

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

    public string[] AquiredAwardList
    {
        get
        {
            DataTable dt = DBHelper.GetDataTable(" select * from new_year_box_detail  where master_id = " + ID.ToString(), Util.ConnectionString);
            string[] listArray = new string[dt.Rows.Count];
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                listArray[i] = dt.Rows[i]["award_name"].ToString().Trim();
            }
            dt.Dispose();
            return listArray;
        }
    }

    public string NextAwardName
    {
        get
        {
            string[] aquiredAwardArray = AquiredAwardList;
            if (aquiredAwardArray.Length == awardTotalList.Length)
            {
                return "";
            }
            else
            {
                string name = awardTotalList[aquiredAwardArray.Length].Value[0].Key;
                int totalNum = awardTotalList[aquiredAwardArray.Length].Value[0].Value;
                int sendNum = GetAwardGivenTimes(name);
                if (sendNum >= totalNum)
                {
                    if (awardTotalList[aquiredAwardArray.Length].Value.Length > 1)
                    {
                        return awardTotalList[aquiredAwardArray.Length].Value[1].Key;
                    }
                    else
                    {
                        return "";
                    }
                }
                else
                {
                    return name;
                }
            }
        }
    }
    /*
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
    */
    public static int GetAwardGivenTimes(string awardName)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from new_year_box_detail where award_name = '" + awardName.Replace("'", "").Trim() + "' ", Util.ConnectionString);
        int num = dt.Rows.Count;
        dt.Dispose();
        return num;
    }
}