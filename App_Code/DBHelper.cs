using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;

/// <summary>
/// Summary description for DBHelper
/// </summary>
public class DBHelper
{
	public DBHelper()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static int GetMaxValue(string tableName, string fieldName, string connectionString)
    {
        int maxId = 0;
        SqlConnection conn = new SqlConnection(connectionString);
        SqlCommand cmd = new SqlCommand("  select max( " + fieldName.Trim() + " ) from " + tableName.Trim(), conn);
        conn.Open();
        SqlDataReader dr = cmd.ExecuteReader();
        if (dr.Read())
        {
            maxId = dr.GetInt32(0);
        }
        dr.Close();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return maxId;
    }

    public static KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] ConvertStringArryToKeyValuePairArray(string[,] parameters)
    {
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] parametersKeyValuePairArr
            = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>[parameters.Length/3];
        for (int i = 0; i < parameters.Length/3; i++)
        {
            parametersKeyValuePairArr[i] = new KeyValuePair<string, KeyValuePair<SqlDbType, object>>(parameters[i, 0].Trim(),
                new KeyValuePair<SqlDbType, object>(GetSqlDbType(parameters[i, 1].Trim()), (object)parameters[i, 2].Trim()));
        }
        return parametersKeyValuePairArr;
    }


    public static int UpdateData(string tableName, string[,] updateParameters, string[,] keyParameters, string connectionString)
    {
        return UpdateData(tableName, ConvertStringArryToKeyValuePairArray(updateParameters),
            ConvertStringArryToKeyValuePairArray(keyParameters), connectionString);
    }

    public static int UpdateData(string tableName, 
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] updateParameters,
        KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] keyParameters, string connectionString)
    {
        SqlCommand cmd = new SqlCommand();

        string setClause = "";
        foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> parameter in updateParameters)
        {
            setClause = setClause + ", " + parameter.Key.Trim() + "  = @" + parameter.Key.Trim() + "  ";
            cmd.Parameters.Add("@" + parameter.Key.Trim(), parameter.Value.Key);
            cmd.Parameters["@" + parameter.Key.Trim()].Value = parameter.Value.Value;
        }
        if (setClause.StartsWith(","))
            setClause = setClause.Remove(0, 1);

        string whereClause = "";
        foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> parameter in keyParameters)
        {
            whereClause = whereClause + "and " + parameter.Key.Trim() + "  = @" + parameter.Key.Trim() + "  ";
            cmd.Parameters.Add("@" + parameter.Key.Trim(), parameter.Value.Key);
            cmd.Parameters["@" + parameter.Key.Trim()].Value = parameter.Value.Value;
        }
        if (whereClause.StartsWith("and"))
            whereClause = whereClause.Remove(0, 3);

        cmd.CommandText = " update " + tableName.Trim() + "  set " + setClause.Trim() + "  where " + whereClause.Trim();

        SqlConnection conn = new SqlConnection(connectionString.Trim());
        cmd.Connection = conn;

        conn.Open();
        int i = cmd.ExecuteNonQuery();
        conn.Close();

        cmd.Parameters.Clear();
        cmd.Dispose();
        conn.Dispose();

        return i;
    }

    public static int DeleteData(string tableName, KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] parameters, string connectionString)
    {
        if (parameters.Length == 0)
            return 0;
        SqlConnection conn = new SqlConnection(connectionString.Trim());
        SqlCommand cmd = new SqlCommand();
        string whereClause = "";
        foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> parameter in parameters)
        {
            whereClause = whereClause + "and " + parameter.Key.Trim() + "  = @" + parameter.Key.Trim() + "  ";
            cmd.Parameters.Add("@" + parameter.Key.Trim(), parameter.Value.Key);
            cmd.Parameters["@" + parameter.Key.Trim()].Value = parameter.Value.Value;
        }
        if (whereClause.StartsWith("and"))
            whereClause = whereClause.Remove(0, 3);

        cmd.CommandText = " delete " + tableName.Trim() + " where  " + whereClause;
        cmd.Connection = conn;
        conn.Open();
        int i = cmd.ExecuteNonQuery();
        conn.Close();
        cmd.Dispose();
        conn.Dispose();
        return i;
    }

    public static int InsertData(string tableName, string[,] parameters, string connectionString)
    { 
        return InsertData(tableName, ConvertStringArryToKeyValuePairArray(parameters), connectionString);
    }


   
    public static int InsertData(string tableName, KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] parameters, string connectionString)
    {
        SqlConnection conn = new SqlConnection(connectionString.Trim());
        SqlCommand cmd = new SqlCommand();
        string fieldClause = "";
        string valuesClause = "";
        foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> param in parameters)
        {
            fieldClause = fieldClause + "," + param.Key.Trim();
            valuesClause = valuesClause + ",@" + param.Key.Trim();
            cmd.Parameters.Add("@" + param.Key.Trim(), param.Value.Key);
            cmd.Parameters["@" + param.Key.Trim()].Value = param.Value.Value;
        }
        fieldClause = fieldClause.Remove(0, 1);
        valuesClause = valuesClause.Remove(0, 1);
        string sql = " insert into " + tableName.Trim() + "  ( "
            + fieldClause + " )  values (" + valuesClause + " )  ";
        cmd.Connection = conn;
        cmd.CommandText = sql;
        conn.Open();
        int i = cmd.ExecuteNonQuery();
        conn.Close();
        cmd.Parameters.Clear();
        cmd.Dispose();
        conn.Dispose();
        return i;
    }


    public static DataTable GetDataTable(string sql, string connectionString)
    {
        DataTable dt = new DataTable();

        SqlDataAdapter da = new SqlDataAdapter(sql, connectionString.Trim());
        da.Fill(dt);
        da.Dispose();
        return dt;
    }

    public static DataTable GetDataTable(string sql, KeyValuePair<string, KeyValuePair<SqlDbType, object>>[] paramArr, string connectionString)
    {
        DataTable dt = new DataTable();
        
        SqlDataAdapter da = new SqlDataAdapter(sql, connectionString.Trim());
        foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> param in paramArr)
        {
            da.SelectCommand.Parameters.Add(param.Key.Trim(), param.Value.Key);
            da.SelectCommand.Parameters[param.Key.Trim()].Value = param.Value.Value;
        }
        da.Fill(dt);
        da.SelectCommand.Parameters.Clear();
        da.Dispose();
        return dt;
    }

    public static SqlDbType GetSqlDbType(string type)
    {
        SqlDbType sqlType;
        switch (type.ToLower())
        {
            case "int":
                sqlType = SqlDbType.Int;
                break;
            case "varchar":
                sqlType = SqlDbType.VarChar;
                break;
            case "datetime":
                sqlType = SqlDbType.DateTime;
                break;
            default:
                sqlType = SqlDbType.VarChar;
                break;
        }
        return sqlType;
    }


    /// <summary>
    ///执行一个不需要返回值的SqlCommand命令，通过指定专用的连接字符串。
    /// 使用参数数组形式提供参数列表 
    /// </summary>
    /// <param name="connectionString">一个有效的数据库连接字符串</param>
    /// <param name="cmdType">SqlCommand命令类型 (存储过程， T-SQL语句， 等等。)</param>
    /// <param name="cmdText">存储过程的名字或者 T-SQL 语句</param>
    /// <param name="commandParameters">以数组形式提供SqlCommand命令中用到的参数列表</param>
    /// <returns>返回一个数值表示此SqlCommand命令执行后影响的行数</returns>
    public static int ExecteNonQuery(string connectionString, CommandType cmdType, string cmdText, params SqlParameter[] commandParameters)
    {
        SqlCommand cmd = new SqlCommand();
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            //通过PrePareCommand方法将参数逐个加入到SqlCommand的参数集合中
            PrepareCommand(cmd, conn, null, cmdType, cmdText, commandParameters);
            int val = cmd.ExecuteNonQuery();
            //清空SqlCommand中的参数列表
            cmd.Parameters.Clear();
            return val;
        }
    }


    /// <summary>
    /// 为执行命令准备参数
    /// </summary>
    /// <param name="cmd">SqlCommand 命令</param>
    /// <param name="conn">已经存在的数据库连接</param>
    /// <param name="trans">数据库事物处理</param>
    /// <param name="cmdType">SqlCommand命令类型 (存储过程， T-SQL语句， 等等。)</param>
    /// <param name="cmdText">Command text，T-SQL语句 例如 Select * from Products</param>
    /// <param name="cmdParms">返回带参数的命令</param>
    private static void PrepareCommand(SqlCommand cmd, SqlConnection conn, SqlTransaction trans, CommandType cmdType, string cmdText, SqlParameter[] cmdParms)
    {
        //判断数据库连接状态
        if (conn.State != ConnectionState.Open)
            conn.Open();
        cmd.Connection = conn;
        cmd.CommandText = cmdText;
        //判断是否需要事物处理
        if (trans != null)
            cmd.Transaction = trans;
        cmd.CommandType = cmdType;
        if (cmdParms != null)
        {
            foreach (SqlParameter parm in cmdParms)
                cmd.Parameters.Add(parm);
        }
    }


}