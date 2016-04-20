using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Summary description for ChatRoom
/// </summary>
public class ChatRoom
{
    public DataRow _fields;
	public ChatRoom()
	{
		
	}

    public ChatRoom(int roomid)
    {
        string sql = "select * from chat_room where [id] = " + roomid;
        DataTable dt = DBHelper.GetDataTable(sql, Util.ConnectionString);
        if (dt != null && dt.Rows.Count > 0)
            this._fields = dt.Rows[0];
        else
            this._fields = null;
    }
}