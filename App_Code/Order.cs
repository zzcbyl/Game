using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Order
/// </summary>
public class Order
{

    public DataRow _fields;

    public int _orderId;

    public Order()
    {
        //_orderId = int.Parse(_fields["oid"].ToString().Trim());
    }

	public Order(int orderId)
	{
        _orderId = orderId;
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_order where oid = " + orderId.ToString(), Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        _fields = dt.Rows[0];
        da.Dispose();

	}

    public DataTable GetOrderDetails()
    {
        SqlDataAdapter da = new SqlDataAdapter(" select * from m_order_detail where order_id = " + int.Parse(_fields["oid"].ToString().Trim()), Util.ConnectionString);
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        return dt;
    }

    public int SyncPaymentStatus()
    {
        string res = Util.GetWebContent("http://yeepay.luqinwenda.com/api/get_payment_status.aspx?mallorderid=" 
            + _fields["oid"].ToString(), "get", "", "html/text");
        if (int.Parse(Util.GetSimpleJsonValueByKey(res, "status")) == 0)
        {
            int status = int.Parse(Util.GetSimpleJsonValueByKey(res, "is_paid"));

            return status;
        }
        else
        {
            return -1;
        }
    }

    public int UpdatePaymentState()
    {
        if (DateTime.Now - this.OrderDate <= new TimeSpan(3, 0, 0, 0) && this.PayState == 0 )
        {
            int status = this.SyncPaymentStatus();
            if (status == 2)
            {
                this._fields["paystate"] = (object)1;
                this.PayState = 1;
                this._fields["paymethod"] = "yeepay_sync";
                this.PayMethod = "yeepay_sync";
            }
            return status;
        }
        else
        {
            return -1;
        }
    }

    public int Amount
    {
        get
        {
            return int.Parse(_fields["orderprice"].ToString());
        }
    }

    public int UserId
    {
        get
        {
            return int.Parse(_fields["uid"].ToString());
        }
    }

    public DateTime OrderDate
    {
        get
        {
            return DateTime.Parse(_fields["ctime"].ToString().Trim());
        }
    }

    public int PayState
    {
        get
        {
            return int.Parse(_fields["paystate"].ToString());
        }
        set
        {
            string sql = " update m_order set paystate = " + value.ToString() 
                +   ((value==1)? "  , paysuccesstime = getdate() " : "   ")
                + " where oid = " + _fields["oid"].ToString().Trim();
            SqlConnection conn = new SqlConnection(Util.ConnectionString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            cmd.Dispose();
            conn.Dispose();

        }
    }

    public string PayMethod
    {
        get
        {
            return _fields["paymethod"].ToString();
        }
        set
        {
            string sql = " update m_order set paymethod = '" + value.Trim().Replace("'","") + "' " 
                + " where oid = " + _fields["oid"].ToString().Trim();
            SqlConnection conn = new SqlConnection(Util.ConnectionString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
            cmd.Dispose();
            conn.Dispose();
        }
    }

    public DateTime PaySuccessTime
    {
        get
        {
            try
            {
                return DateTime.Parse(_fields["paysuccesstime"].ToString().Trim());
            }
            catch
            {
                return DateTime.Parse("2000-1-1");
            }
        }
    }

    public static Order[] GetOrders(int userId, DateTime startDate, DateTime endDate)
    {
        string sql = " select * from m_order where ctime > '" + startDate.ToString() + "' and ctime < '"
            + endDate.AddDays(1).ToString() + "'  " + ((userId == 0) ? "" : " and uid = " + userId.ToString())
            + "  order by oid desc ";
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.ConnectionString.Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        Order[] orderArray = new Order[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            orderArray[i] = new Order();
            orderArray[i]._fields = dt.Rows[i];
            orderArray[i].UpdatePaymentState();

            


        }
        return orderArray;
    }

    public static Order[] GetOrdersByPages(int userId, DateTime startDate, DateTime endDate, int currentPage, int pageSize, string where)
    {
        int intop = pageSize * (currentPage - 1);
        string sql = "SELECT TOP " + pageSize + " * FROM m_order WHERE oid NOT IN (SELECT TOP " + intop + " oid FROM m_order where ctime > '" + startDate.ToString() + "' and ctime < '" + endDate.AddDays(1).ToString() + "'  " + ((userId == 0) ? "" : " and uid = " + userId.ToString()) + where + " ORDER BY oid desc) and ctime > '" + startDate.ToString() + "' and ctime < '" + endDate.AddDays(1).ToString() + "'  " + ((userId == 0) ? "" : " and uid = " + userId.ToString()) + where + " ORDER BY oid desc";
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.ConnectionString.Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        Order[] orderArray = new Order[dt.Rows.Count];
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            orderArray[i] = new Order();
            orderArray[i]._fields = dt.Rows[i];
            orderArray[i].UpdatePaymentState();
        }
        return orderArray;
    }

    public static int GetOrdersCount(int userId, DateTime startDate, DateTime endDate, string where)
    {
        string sql = " select * from m_order where ctime > '" + startDate.ToString() + "' and ctime < '"
            + endDate.AddDays(1).ToString() + "'  " + ((userId == 0) ? "" : " and uid = " + userId.ToString())
            + where + "  order by oid desc ";
        SqlDataAdapter da = new SqlDataAdapter(sql, Util.ConnectionString.Trim());
        DataTable dt = new DataTable();
        da.Fill(dt);
        da.Dispose();
        return dt.Rows.Count;
    }

    public int updPayState(int orderid, string paymethod)
    {
        string sqlUpdPay = "update m_order set paystate = 1, paysuccesstime = '" + DateTime.Now.ToString() + "', paymethod='" + paymethod + "' where oid = " + orderid;
        SqlConnection conn = new SqlConnection(Util.ConnectionString.Trim());
        SqlCommand cmdUpdPayOrder = new SqlCommand(sqlUpdPay, conn);
        conn.Open();
        int result = cmdUpdPayOrder.ExecuteNonQuery();
        return result;
    }

    public int updPayState(int orderid, int paystate, string shipNumber)
    {
        string sqlUpdPay = "update m_order set paystate = " + paystate + ", paysuccesstime = '" + DateTime.Now.ToString() + "', shipNumber='" + shipNumber + "' where oid = " + orderid;
        SqlConnection conn = new SqlConnection(Util.ConnectionString.Trim());
        SqlCommand cmdUpdPayOrder = new SqlCommand(sqlUpdPay, conn);
        conn.Open();
        int result = cmdUpdPayOrder.ExecuteNonQuery();
        return result;
    }

    public int Discount(int amount)
    {
        SqlConnection conn = new SqlConnection(Util.ConnectionString.Trim());
        SqlCommand cmd = new SqlCommand(" update m_order set ajustfee = ajustfee - " + amount.ToString()
            + "  where oid = " + _fields["oid"].ToString(),conn);
        conn.Open();
        int i = cmd.ExecuteNonQuery();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return i;

    }

    public int OrderPriceToPay
    {
        get
        {
            return int.Parse(_fields["orderprice"].ToString().Trim())
                + int.Parse(_fields["shipfee"].ToString().Trim())
                + int.Parse(_fields["ajustfee"].ToString().Trim());

        }
    }
}