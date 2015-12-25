using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for Drawing
/// </summary>
public class Drawing
{
	public Drawing()
	{
		//
		// TODO: Add constructor logic here
		//
	}


    public static int DrawingPlay(string opneId, int actId)
    {
        DataTable dt = DBHelper.GetDataTable(" select * from random_awards where open_id = '" + opneId.Trim() + "'  and act_id = " + actId.ToString(), Util.ConnectionString);
        int i = 0;
        if (dt.Rows.Count > 0)
        {
            i = int.Parse(dt.Rows[0]["id"].ToString());
        }
        else
        {
            i = NewDrawing(opneId, actId);
        }
        dt.Dispose();
        return i;
    }



    public static int NewDrawing(string opneId, int actId)
    {
        int numZhangda = 0;
        int numFannao = 0;

        DataTable dt = DBHelper.GetDataTable(" select * from random_awards where award = '长大不容易' and act_id = " + numZhangda.ToString().Trim(), Util.ConnectionString);
        numZhangda = dt.Rows.Count;
        dt.Dispose();

        dt = DBHelper.GetDataTable(" select * from random_awards where award = '和烦恼说再见' and act_id = " + numZhangda.ToString().Trim(), Util.ConnectionString);
        numFannao = dt.Rows.Count;
        dt.Dispose();

        int seed = (new Random()).Next(0, 100);

        string award = "";

        if (seed == 1 && numZhangda < 5)
        {
            award = "长大不容易";
        }
        else
        {
            if (seed == 51 && numFannao < 30)
            {
                award = "和烦恼说再见";
            }
            else
            {
                if (seed < 51)
                {
                    Coupon coupon = Coupon.AddCoupon(500);
                    award = "5元优惠券:" + coupon._fields["code"].ToString().Trim();

                }
                else
                {
                    Coupon coupon = Coupon.AddCoupon(200);
                    award = "2元优惠券:" + coupon._fields["code"].ToString().Trim();
                }
            }
        }

        string[,] insertParameter = {{"act_id", "int", actId.ToString()},
                                    {"open_id", "varchar", opneId.Trim()},
                                    {"seed", "int", seed.ToString()},
                                    {"award", "varchar", award.Trim()}};

        int i = DBHelper.InsertData("random_awards", insertParameter, Util.ConnectionString);

        if (i == 1)
        {
            dt = DBHelper.GetDataTable(" select top 1 * from random_awards order by [id] desc ", Util.ConnectionString);
            if (dt.Rows.Count == 1)
            { 
                i = int.Parse(dt.Rows[0]["id"].ToString());
            }
            dt.Dispose();
        }

        return i;
    }


}