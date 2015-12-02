<%@ Page Language="C#" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        int amount = ((Request["amount"] == null) ? 200 : int.Parse(Request["amount"]));
        if (amount > 0)
        {
            Coupon coupon = Coupon.AddCoupon(amount);
            Response.Write("{\"status\":0, \"amount\": " + amount.ToString() + ", \"code\": \"" + coupon._fields["code"].ToString().Trim() + "\" }");
            
        }
    }
</script>