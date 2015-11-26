var IE = navigator.appName == "Microsoft Internet Explorer";
var NS = navigator.appName == "Netscape";
var Opera = navigator.appName == "Opera";
var ie = IE;
var ns = NS;
var ff = ns;
var FF = ns;
var IsIE = ie;
var IsNs = ns;
var isSa = false;
if (NS && navigator.appVersion.toLowerCase().indexOf("safari") > 0) isSa = true;
var ie7 = IE && navigator.appVersion.toLowerCase().indexOf("ie 7") > 0;
var ie6 = IE && navigator.appVersion.toLowerCase().indexOf("ie 6") > 0;
var Sa = isSa;
var sa = Sa;
/*
window.alert=function(string)
{
if(string&&typeof(string)!="object")
FDMFrame.Alert("警告",string.toString(),{name:"确定",script:""});
else
FDMFrame.Alert("警告","[" + typeof(string) + "]",{name:"确定",script:""});
}
*/
if (window.isFocus == undefined) {
    window.isFocus = true;
}
window.focus = new Function("window.isFocus=true");
window.blur = new Function("window.isFocus=false");
Array.prototype.p = function(key, val) {
    if (val != null && key != null) this.push(key + "=" + val);
}

Array.prototype.toQueryString = function() {
    return this.join("&");
}

String.format = function() {
    if (arguments.length == 0) return "";
    if (arguments.length == 1) return arguments[0];
    var reg = /{(\d+)?}/g;
    var args = arguments;
    var result = arguments[0].replace(reg, function($0, $1) {
        return args[parseInt($1) + 1];
    })
    return result;
}
Array.prototype.getIndexByValue = function(value) {
    return this.find(value);
}
Array.prototype.find = function(value) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == value) return i;
    }
    return -1;

}
String.prototype.isPhone = function() {
    var p = /^0\d{10,11}$|^0\d{2}-\d{8}$|^0\d{3}-\d{7,8}$|^0\d{2}-\d{8}-\d{1,}$|^0\d{3}-\d{7,8}-\d{1,}$/;
    return p.test(this)
}
String.prototype.isJobNumber = function() {
    var p = /^([a-zA-Z0-9]){1,}(([a-zA-Z0-9])|-| ){0,}([a-zA-Z0-9]){1,}$/;
    return p.test(this)
}
String.prototype.toZip = function() {
    var PhoneCodeString = this.trim();
    PhoneCodeString = PhoneCodeString.replace(/　/g, "");
    PhoneCodeString = PhoneCodeString.replace(/ /g, "");
    if (PhoneCodeString.length != 6) return null;
    PhoneCodeString = PhoneCodeString.replace(/０/g, "0");
    PhoneCodeString = PhoneCodeString.replace(/１/g, "1");
    PhoneCodeString = PhoneCodeString.replace(/２/g, "2");
    PhoneCodeString = PhoneCodeString.replace(/３/g, "3");
    PhoneCodeString = PhoneCodeString.replace(/４/g, "4");
    PhoneCodeString = PhoneCodeString.replace(/５/g, "5");
    PhoneCodeString = PhoneCodeString.replace(/６/g, "6");
    PhoneCodeString = PhoneCodeString.replace(/７/g, "7");
    PhoneCodeString = PhoneCodeString.replace(/８/g, "8");
    PhoneCodeString = PhoneCodeString.replace(/９/g, "9");
    if (!PhoneCodeString.isInt()) return null;
    return PhoneCodeString;
}
String.prototype.toPhone = function() {
    var PhoneCodeString = this.replace(/\\/g, " ");
    PhoneCodeString = PhoneCodeString.replace(/\//g, " ");
    PhoneCodeString = PhoneCodeString.replace("转", "-");

    PhoneCodeString = PhoneCodeString.replace(/　/g, " ");
    PhoneCodeString = PhoneCodeString.replace(/－/g, "-");
    PhoneCodeString = PhoneCodeString.replace(/＋/g, "+");
    PhoneCodeString = PhoneCodeString.replace(/０/g, "0");
    PhoneCodeString = PhoneCodeString.replace(/１/g, "1");
    PhoneCodeString = PhoneCodeString.replace(/２/g, "2");
    PhoneCodeString = PhoneCodeString.replace(/３/g, "3");
    PhoneCodeString = PhoneCodeString.replace(/４/g, "4");
    PhoneCodeString = PhoneCodeString.replace(/５/g, "5");
    PhoneCodeString = PhoneCodeString.replace(/６/g, "6");
    PhoneCodeString = PhoneCodeString.replace(/７/g, "7");
    PhoneCodeString = PhoneCodeString.replace(/８/g, "8");
    PhoneCodeString = PhoneCodeString.replace(/９/g, "9");
    PhoneCodeString = PhoneCodeString.replace(/ \+/g, " ");
    PhoneCodeString = PhoneCodeString.replace(/- /g, "-");
    var result = PhoneCodeString.match(/\-?\d+/g);
    if (result == null) return null;
    switch (result.length) {
        case 0: return null;
        case 1:
            return FormatedPhoneCode(null, null, result[0], null);
        case 2:
            return result[0].length < result[1].length ? FormatedPhoneCode(null, result[0], result[1], null) : FormatedPhoneCode(null, null, result[0], result[1].replace(/-/g, ""));
        case 3:
            return result[1].length < result[2].length ? FormatedPhoneCode(result[0], result[1], result[2], null) : FormatedPhoneCode(null, result[0], result[1], result[2].replace(/-/g, ""));
        default:
            return FormatedPhoneCode(result[0], result[1], result[2], result[3]);
    }
    return null;
}

String.prototype.HtmlEncode = function() {
    var temp = document.createElement("div");
    (temp.textContent != null) ? (temp.textContent = this) : (temp.innerText = this);
    var output = temp.innerHTML;
    temp = null;
    return output;
}
String.prototype.HtmlDecode = function() {
    var temp = document.createElement("div");
    temp.innerHTML = this;
    var output = temp.innerText || temp.textContent;
    temp = null;
    return output;
}
function FormatedPhoneCode(countryCode, areaCode, phoneCode, extensionCode) {
    countryCode = countryCode != null ? countryCode.replace("-", "") : "";
    areaCode = areaCode != null ? areaCode.replace("-", "") : "";
    phoneCode = phoneCode != null ? phoneCode.replace("-", "") : "";
    extensionCode = extensionCode != null ? extensionCode.replace("-", "") : "";
    var code = countryCode + "-" + (phoneCode != null && phoneCode.length > 10 ? "" : areaCode) + "-" + phoneCode + "-" + extensionCode;
    code = code.trim();
    code = code.replace(" -", " ");
    code = code.trim('-');
    return code;
}
Number.prototype.format = function(decimalPoints, thousandsSep, decimalSep) {
    var val = this + '', re = /^(-?)(\d+)/, x, y;
    if (decimalPoints != null) val = this.toFixed(decimalPoints);
    if (thousandsSep && (x = re.exec(val))) {
        for (var a = x[2].split(''), i = a.length - 3; i > 0; i -= 3) a.splice(i, 0, thousandsSep);
        val = val.replace(re, x[1] + a.join(''));
    }
    if (decimalSep) val = val.replace(/\./, decimalSep);
    return val;
}
String.prototype.isTelCode = function() {
    //有问题
    var p = /^0\d{2,3}$/;
    return p.test(this)
}
String.prototype.isZip = function()
{
    var p = /^\d{6}$/;
    return p.test(this)
}
String.prototype.isPostCode = function()
{
    return this.isZip();
}
String.prototype.isMobile = function() {
    var p = /^1\d{10}$/;
    return p.test(this)
}
String.prototype.isPassword = function() {
    var p = /^(([^\s]| ){6,20})$/;
    return p.test(this);
}
String.prototype.ispassword = function() {
    return this.isPassword();
}
String.prototype.IsIPAddress = function() {
    var exp = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
    var reg = this.match(exp);
    return reg != null
}
String.prototype.isIPAddress = function() {
    return this.IsIPAddress();
}
String.prototype.isAccount = function() {
    var p = /^(([a-zA-Z])(\w|-){5,20})$/;
    return p.test(this);
}
String.prototype.isaccount = function() {
    return this.isAccount();
}
String.prototype.ispwd = function() {
    return this.isPassword();
}
String.prototype.isPwd = function() {
    return this.isPassword();
}
String.prototype.isDomainName = function() {
    var p = /(\.{2,})|(\.$)|(^\.)|([^A-Za-z0-9\-_\.])/;
    return !p.test(this)
}
String.prototype.IsDomainName = function() {
    return this.isDomainName();
}
String.prototype.trim = function() {
    if (arguments.length == 0)
        return this.replace(/(^[\s　]*)|([\s　]*$)/g, "");
    else {
        var s = arguments[0];
        var v = this;
        return eval("v.replace(/(^[\\s" + s + "]*)|([\\s" + s + "]*$)/g, '')");
    }
}
String.prototype.parseFloat = function() {
    return parseFloat(this);
}
String.prototype.ParseFloat = function() {
    return this.parseFloat();
}
String.prototype.Trim = function() {
    return this.trim.apply(this, arguments);
}
String.prototype.toLower = function() {
    return this.toLowerCase();
}
String.prototype.ToLower = function() {
    return this.toLower();
}
String.prototype.toUpper = function() {
    return this.toUpperCase();
}
String.prototype.ToUpper = function() {
    return this.toUpper();
}
String.prototype.parseInt = function() {
    return parseInt(this);
}
String.prototype.ParseInt = function() {
    return this.parseInt();
}
String.prototype.parseBool = function() {
    return this.toLower() == "true";
}
String.prototype.ParseBool = function() {
    return this.parseBool();
}
String.prototype.parseDateTime = function() {
    var s = this.replace("年", "-");
    s = s.replace("月", "-");
    s = s.replace("日", "");
    s = s.replace("点", ":");
    s = s.replace("分", ":");
    s = s.replace("秒", "");
    s = s.replace(/-/g, "/");
    return new Date(s);
}
String.prototype.isMail = function() {
    var re = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if (this.search(re) == 0)
        return true;
    else
        return false;
}
String.prototype.IsMail = function() {
    return this.isMail();
}
String.prototype.IsEmail = function() {
    return this.isMail();
}
String.prototype.isEmail = function() {
    return this.isMail();
}
String.prototype.isEmpty = function() {
    if (this.trim().length == 0)
        return true;
    else
        return false;
}
String.prototype.IsEmpty = function() {
    return this.isEmpty();
}
String.prototype.isNull = function() {
    return this == null;
}
String.prototype.IsNull = function() {
    return this.isNull();
}
String.prototype.isInt = function() {
    var re = /^-{0,1}\d{1,}$/;
    return re.test(this);
}
String.prototype.IsInt = function() {
    return this.isInt();
}
String.prototype.isNumeric = function() {
    var re = /^\d{1,}$|^\d{1,}.\d{1,}$/;
    return re.test(this);
}
String.prototype.IsNumeric = function() {
    return this.isNumeric();
}
String.prototype.isChinese = function() {
    var re = /^[\u4e00-\u9fa5]{0,}$/;
    return re.test(this);
}
String.prototype.IsChinese = function() {
    return this.isChinese(this);
}
String.prototype.withChinese = function() {
    var re = /[\u4e00-\u9fa5]{1,}/;
    return this.search(re) > -1;
}
String.prototype.WithChinese = function() {
    return this.withChinese();
}
String.prototype.len = function() {
    return this.replace(/[^\x00-\xff]/g, "aa").length;
}
String.prototype.Len = function() {
    return this.replace(/[^\x00-\xff]/g, "aa").length;
}
String.prototype.format = function() {
    var _Str_For_str = this;
    for (var i = 0; i < arguments.length; i++) {
        while (_Str_For_str.indexOf("{" + i + "}") >= 0)
            _Str_For_str = _Str_For_str.replace("{" + i + "}", arguments[i]);
    }
    return _Str_For_str;
}
String.prototype.Format = function() {
    return this.format();
}
String.prototype.HtmlDecode = function() {
    return this.replace(/&amp;/g, '&').replace(/&quot;/g, '\"').replace(/&lt;/g, '<').replace(/&gt;/g, '>');
}
String.prototype.HtmlEncode = function() {
    return this.replace(/&/g, '&amp').replace(/\"/g, '&quot;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}
//反转字符串
String.prototype.reverse = function() {
    var strArray = this.split('');
    strArray.reverse();
    return strArray.join('');
}

Date.prototype.isToday = function() {
    var now = Sales && Sales.Time && Sales.Time.Date() ? Sales.Time.Date() : new Date();
    return this.getFullYear() == now.getFullYear() && this.getMonth() == now.getMonth() && this.getDate() == now.getDate() ? true : false;
}
Date.prototype.monthDaysCount = function() {
    if (this.getMonth() == 0 || this.getMonth() == 2 || this.getMonth() == 4 || this.getMonth() == 6 || this.getMonth() == 7 || this.getMonth() == 9 || this.getMonth() == 11) return 31;
    if (this.getMonth() == 3 || this.getMonth() == 5 || this.getMonth() == 8 || this.getMonth() == 10) return 30;
    return this.isLeapYear() ? 29 : 28;
}
Date.prototype.isLeapYear = function() {
    var year = this.getYear() < 1000 ? this.getYear() + 1900 : this.getYear();
    if (year % 400 == 0) return true;
    if (year % 100 == 0) return false;
    if (year % 4 == 0) return true;
    return false;
}
Date.prototype.toLocaleDate = function() {
    var ls = this.toLocaleString();
    return ls.substring(0, ls.indexOf(" "));
}

Date.prototype.toString = function(format) {
    if (format && typeof (format) == "string") {
        var result = format.toString();
        result = result.replace(/y/g, "Y").replace(/d/g, "D").replace(/s/g, "S");
        result = result.replace(/YYYY/g, this.getFullYear());
        result = result.replace(/YYY/g, this.getFullYear().toString().substring(this.getFullYear().toString().length - 3, this.getFullYear().toString().length));
        result = result.replace(/YY/g, this.getFullYear().toString().substring(this.getFullYear().toString().length - 2, this.getFullYear().toString().length));
        result = result.replace(/Y/g, this.getFullYear().toString().substring(this.getFullYear().toString().length - 1, this.getFullYear().toString().length));
        result = result.replace(/MM/g, (this.getMonth() < 10 ? "0" : "") + this.getMonth());
        result = result.replace(/M/g, this.getMonth());
        result = result.replace(/DD/g, (this.getDate() < 10 ? "0" : "") + this.getDate());
        result = result.replace(/D/g, this.getDate());
        result = result.replace(/HH/g, (this.getHours() < 10 ? "0" : "") + this.getHours());
        result = result.replace(/H/g, this.getHours());
        result = result.replace(/hh/g, (this.getHours() % 12 < 10 && this.getHours() % 12 > 0 ? "0" : "") + (this.getHours() % 12 == 0 ? "12" : this.getHours() % 12));
        result = result.replace(/h/g, (this.getHours() % 12 == 0 ? "12" : this.getHours() % 12));
        result = result.replace(/mm/g, (this.getMinutes() < 10 ? "0" : "") + this.getMinutes());
        result = result.replace(/m/g, this.getMinutes());
        result = result.replace(/SS/g, (this.getSeconds() < 10 ? "0" : "") + this.getSeconds());
        result = result.replace(/S/g, this.getSeconds());
        return result;
    }
    else {
        return "" + this.getFullYear() + "-" + this.getMonth() + "-" + this.getDate() + " " + (this.getHours() < 10 ? "0" : "") + this.getHours() + ":" + (this.getMinutes() < 10 ? "0" : "") + this.getMinutes() + ":" + (this.getSeconds() < 10 ? "0" : "") + this.getSeconds();
    }
}
String.isNullOrEmpty = function(val) {
    return val == null || val == NaN || val == "";
}
/**
*判断身份证号码格式函数
*公民身份号码是特征组合码，
*排列顺序从左至右依次为：六位数字地址码，八位数字出生日期码，三位数字顺序码和一位数字校验码
*/
String.prototype.isChinaIDCard = function() {
    StrNo = this.toString();
    if (StrNo.length == 15) {
        if (!isValidDate("19" + StrNo.substr(6, 2), StrNo.substr(8, 2), StrNo.substr(10, 2))) {
            return false;
        }
    }
    else if (StrNo.length == 18) {
        if (!isValidDate(StrNo.substr(6, 4), StrNo.substr(10, 2), StrNo.substr(12, 2))) {
            return false;
        }
    }
    else {
        //alert("输入的身份证号码必须为15位或者18位！");
        return false;
    }

    if (StrNo.length == 18) {
        var a, b, c
        if (!(StrNo.substr(0, 17).isInt())) {
            //alert("身份证号码错误,前17位不能含有英文字母！");
            return false;
        }
        a = parseInt(StrNo.substr(0, 1)) * 7 + parseInt(StrNo.substr(1, 1)) * 9 + parseInt(StrNo.substr(2, 1)) * 10;
        a = a + parseInt(StrNo.substr(3, 1)) * 5 + parseInt(StrNo.substr(4, 1)) * 8 + parseInt(StrNo.substr(5, 1)) * 4;
        a = a + parseInt(StrNo.substr(6, 1)) * 2 + parseInt(StrNo.substr(7, 1)) * 1 + parseInt(StrNo.substr(8, 1)) * 6;
        a = a + parseInt(StrNo.substr(9, 1)) * 3 + parseInt(StrNo.substr(10, 1)) * 7 + parseInt(StrNo.substr(11, 1)) * 9;
        a = a + parseInt(StrNo.substr(12, 1)) * 10 + parseInt(StrNo.substr(13, 1)) * 5 + parseInt(StrNo.substr(14, 1)) * 8;
        a = a + parseInt(StrNo.substr(15, 1)) * 4 + parseInt(StrNo.substr(16, 1)) * 2;
        b = a % 11;
        if (b == 2) {//最后一位为校验位
            c = StrNo.substr(17, 1).toUpperCase(); //转为大写X
        }
        else {
            c = parseInt(StrNo.substr(17, 1));
        }

        switch (b) //旧代码
        {
            case 0:
                if (c != 1) {
                    //alert("身份证好号码校验位错:最后一位应该为:1");
                    return false;
                }
                break;
            case 1:
                if (c != 0) {
                    //alert("身份证好号码校验位错:最后一位应该为:0");
                    return false;
                }
                break;
            case 2:
                if (c != "X") {
                    //alert("身份证好号码校验位错:最后一位应该为:X");
                    return false;
                }
                break;
            case 3:
                if (c != 9) {
                    //alert("身份证好号码校验位错:最后一位应该为:9");
                    return false;
                }
                break;
            case 4:
                if (c != 8) {
                    //alert("身份证好号码校验位错:最后一位应该为:8");
                    return false;
                }
                break;
            case 5:
                if (c != 7) {
                    //alert("身份证好号码校验位错:最后一位应该为:7");
                    return false;
                }
                break;
            case 6:
                if (c != 6) {
                    //alert("身份证好号码校验位错:最后一位应该为:6");
                    return false;
                }
                break;
            case 7:
                if (c != 5) {
                    //alert("身份证好号码校验位错:最后一位应该为:5");
                    return false;
                }
                break;
            case 8:
                if (c != 4) {
                    //alert("身份证好号码校验位错:最后一位应该为:4");
                    return false;
                }
                break;
            case 9:
                if (c != 3) {
                    //alert("身份证好号码校验位错:最后一位应该为:3");
                    return false;
                }
                break;
            case 10:
                if (c != 2) {
                    //alert("身份证好号码校验位错:最后一位应该为:2");
                    return false;
                }
        }
    }
    else {//15位身份证号
        if (!StrNo.isNumeric()) {
            //alert("身份证号码错误,前15位不能含有英文字母！");
            return false;
        }
    }
    return true;
}

function isValidDate(iY, iM, iD) {
    if (iY > 2200 || iY < 1900 || !iY.isNumeric()) {
        return false;
    }
    if (iM > 12 || iM <= 0 || !iM.isNumeric()) {
        return false;
    }
    if (iD > 31 || iD <= 0 || !iD.isNumeric()) {
        return false;
    }
    if (iM == 2) {
        if (iD > 29) return false;
        if (iD == 29) {
            if (iY % 4 == 0) {
                if (iY % 400 == 0)
                    return true;
                else if (iY % 100 == 0)
                    return false;
                else
                    return true;
            }
            else
                return false;
        }
    }
    if (iM == 2 && iD > 29) return false;
    if (iM == 2 && iY % 4 > 0 && iD > 28) return false;
    if (iM == 2 && iY % 400 > 0 && iY % 100 == 0 && iD > 28) return false;
    return true;
}
function getOffset(Obj) {
    Obj = ge(Obj);
    var x = Obj.offsetLeft;
    var y = Obj.offsetTop;
    if (Obj.offsetParent != null) {
        var offset = getOffset(Obj.offsetParent);
        x += offset.x;
        y += offset.y;
    }
    var w = Obj.offsetWidth;
    var h = Obj.offsetHeight;
    return { x: x, y: y, w: w, h: h }
}
function addEvent(element, type, handler) {
    if (window.addEventListener) {
        try {
            element.removeEventListener(type, handler, false);
        }
        catch (e) { }
        element.addEventListener(type, handler, false);
    }
    else if (window.attachEvent) {
        try {
            element.detachEvent("on" + type, handler);
        }
        catch (e) { }
        element.attachEvent("on" + type, handler);
    }
}
function removeEvent(element, type, handler) {
    if (window.removeEventListener) {
        try {
            element.removeEventListener(type, handler, false);
        }
        catch (e) { }
    }
    else if (window.detachEvent) {
        try {
            element.detachEvent("on" + type, handler);
        }
        catch (e) { }
    }
}
//禁止事件冒泡
function stopPropagation(evt) {
    var e = (evt) ? evt : window.event;
    if (window.event) {
        e.cancelBubble = true;
    }
    else {
        e.stopPropagation();
    }
}
function ce(tagName, parentObjId) {
    if (parentObjId) {
        var _obj = ge(parentObjId);
        if (_obj == null) return null;
        var cobj = ce(tagName);
        _obj.appendChild(cobj);
        return cobj;
    }
    else
        return document.createElement(tagName);
}
function rc(node) {
    while (node.childNodes.length > 0) node.removeChild(node.childNodes[0]);
}
function ae(childObj, parentObj) {
    if (childObj != null && parentObj != null) parentObj.appendChild(childObj);
}
function setOut(inerNode, outerNode) {
    inerNode.parentNode.insertBefore(outerNode, inerNode);
    outerNode.appendChild(inerNode);
}
function aef(childObj, parentObj) {
    if (parentObj && childObj) {
        var fnode = parentObj.childNodes.length > 0 ? parentObj.childNodes[0] : null;
        if (fnode)
            parentObj.insertBefore(childObj, fnode);
        else
            ae(childObj, parentObj);
    }
}
function getNodeIndex(Obj) {
    var i = 0;
    var oc = Obj.previousSibling;
    while (oc) {
        oc = oc.previousSibling;
        i++;
    }
    return i;
}
function ge(ID) {
    if (typeof (ID) == "object") return ID;
    if (typeof (ID) == "string")
        return document.getElementById(ID);
}
function re(ID) {
    var _obj = typeof (ID) == "object" ? ID : ge(ID);
    if (_obj == null) return;
    if (_obj.parentNode) _obj.parentNode.removeChild(_obj);
}
function getParamValue(URL, ParamName) {
    var Opt = getParam(URL);
    for (i = 0; i < Opt[0].length; i++) {
        if (Opt[0][i].toLowerCase() == ParamName.toLowerCase()) return Opt[1][i];
    }
    return null;
}
function getParam(URL) {
    URL = URL.substring(URL.indexOf("?") + 1, URL.length);
    var opt = URL.split("&");
    var topt = new Array();
    topt[0] = opt[0];
    for (var i = 1; i < opt.length; i++) {
        if (opt[i].toLocaleString().indexOf("amp;") == 0) {
            topt[topt.length - 1] += "&" + opt[i];
        }
        else {
            topt[topt.length] = opt[i];
        }
    }
    opt = topt;
    var para = new Array();
    var value = new Array();
    for (i = 0; i < opt.length; i++) {
        para[i] = opt[i].substring(0, opt[i].indexOf("="));
        value[i] = opt[i].substring(opt[i].indexOf("=") + 1, opt[i].length);
    }
    var result = new Array(para, value);
    return result;
}
function QueryString(ParamName) {
    return getParamValue(window.location.href, ParamName);
}

function StrRegExp(str, patStr) {
    var pat = new RegExp(patStr);
    return (pat.test(str));
}
function GetScale(vle, allNumber) {
    var a = vle / allNumber;
    if (a.toString().indexOf('.') != -1) {
        var b = a.toString().substring(a.toString().indexOf('.') + 1, a.toString().length);
        if (b.length == 1) {
            return b + "0";
        }
        else if (b.length == 2) {
            return b;
        }
        else {
            return b.toString().substring(0, 2);
        }
    }
    else if (a == 0) {
        return "0";
    }
    else if (a == 1) {
        return "100";
    }
    else {
        return "0";
    }
}

function PostToPage(formID, url, method, disableButton, target) {
    var form = document.getElementById(formID);
    if (form != null) {
        RemoveViewState(formID);
        form.method = method;
        form.action = url;
        if (target != null) form.target = target;
        form.submit();
        if (disableButton != false) DisableButton();
    }
}
function RemoveViewState(formID) {
    var form = document.getElementById(formID);
    if (form == null) {
        FDMFrame.Info('提示信息', '指定的表单不存在!');
    }
    else {
        for (var i = 1; i < arguments.length; i++) {
            if (form.children[arguments[i]] != null) {
                RemoveNode(arguments[i]);
                //form.removeChild(form.children[arguments[i]]);
            }
        }
        RemoveNode("__VIEWSTATE");
        RemoveNode("__EVENTTARGET");
        RemoveNode("__EVENTARGUMENT");
    }
    return;
}
function RemoveNode(nodeID) {
    var ntype = GetNType()
    var target = document.getElementById(nodeID);
    if (target == null || target == undefined) return;
    if (ntype == "ie") {
        target.removeNode(true);
    }
    else {
        target.parentNode.removeChild(target);
    }
}
function GetNType() {
    return document.body.removeNode != undefined ? "ie" : "mf";
}
function DisableButton() {
    var inputs = document.all.tags("input");
    for (var i = 0; i < inputs.length; i++) {
        if (inputs[i].type == "button" || inputs[i].type == "submit" || inputs[i].type == "reset") {
            inputs[i].disabled = true;
        }
    }
}

$.fn.check = function(mode) {
    mode = mode || 'on'; // if mode is undefined, use 'on' as default
    return this.each(function() {
        switch (mode) {
            case 'on':
                this.checked = true;
                break;
            case 'off':
                this.checked = false;
                break;
            case 'toggle':
                this.checked = !this.checked;
                break;
        }
    });
};

function jump(queryString, page) {
    var qs = "?" + queryString.replace("{0}", page);
    location.href = qs;
}

//=================== Sandheart < ========================
var isIE = navigator.appName == "Microsoft Internet Explorer";

//根据下标移除Array中的值
Array.prototype.remove = function(dx) {
    if (isNaN(dx) || dx > this.length) { return false; }
    for (var i = 0, n = 0; i < this.length; i++) {
        if (i != dx) {
            this[n++] = this[i];
        }
    }
    this.length -= 1;
}


//----根据id或属性名称判断对象是否为空------
function objIsNull(id, isCheckContent) {
    var tObj = document.getElementById(id);
    if (!tObj) return true;
    if (isCheckContent) {
        try {
            if (!tObj.value && !tObj.innerText) return;
        }
        catch (e)
	    { }
    }
    return false;
}
//----根据id获取对象------
function getObj(id) {
    return document.getElementById(id);
}

//----根据name获取对象------
function getObjs(n) {
    return document.getElementsByName(n);
}
//----根据tagName获取对象------
function getOTags(n) {
    return document.getElementsByTagName(n);
}
//----根据id或对象与属性名称获取对象的属性值------
function getOAV(idOrObj, attributeName) {
    var tObj = (typeof (idOrObj) == 'object') ? idOrObj : getObj(idOrObj);
    if (!tObj) return null;
    try {
        return (tObj[attributeName]);
    }
    catch (e) {
        return null;
    }
}

//----判断字符串是否为空或null------
function isNullOrEmpty(obj) {
    if (obj == null || obj.replace(/[\s　]/g, '') == '')
        return true;
    else
        return false;
}

/*  
作者：Sandheart E-Mail:sxd.www@gmail.com 日期：2009-02-20
获取XML对象中某个节点的值，支持下标
例：GetNodeValue(xmlDoc, 'root/channel[1]/title[3]')；
参数：        
xmlObj：XML对象；
path：要获取值的节点路径，如:'root/channel[1]/title[3]'，不加下标时自动选择第一个，找不到节点时返回空；
*/
function GetNodeValue(xmlObj, path) {
    //debugger;
    var tempNodes = xmlObj;
    if (!tempNodes) return '';
    var tns = path.split('/');
    var reg = /.*(\[(\d+)\])/;
    var isGet = false; //判断是否获取到了值
    for (var i = 0, l = tns.length; i < l; i++) {
        //提出名字与下标值
        var tmp_name = tns[i];
        var tmp_sub = 0;
        var tmp_array = tmp_name.match(reg);
        if (tmp_array != null) {
            tmp_sub = tmp_array[2];
            tmp_name = tmp_name.replace(tmp_array[1], '');
        }
        isGet = false;
        try {
            if (tempNodes) tempNodes = tempNodes.getElementsByTagName(tmp_name)[tmp_sub];
            //tempNodes = tempNodes.selectNodes(tmp_name)[tmp_sub];
            isGet = true;
        }
        catch (e) {
            return '';
        }
    }
    if (isGet && tempNodes) {
        if (isIE)
            return tempNodes.text;
        else
            return tempNodes.textContent
    }
    else
        return '';
}


//对字符串进行HTML编码
function HTMLEncode(str) {
    var _div = document.createElement('div');
    _div.innerText = str;
    var reStr = _div.innerHTML;
    _div = null;
    return reStr
}
//对HTML进行字符串解码
function HTMLDecode(html) {
    var _div = document.createElement('div');
    _div.innerHTML = html;
    var reStr = _div.innerText;
    _div = null;
    return reStr;
}
//返回一个对象在页面中的位置
/*function getOffset(Obj)
{
var x = Obj.offsetLeft;
var y = Obj.offsetTop;
if (Obj.offsetParent != null)
{
var offset = getOffset(Obj.offsetParent);
x += offset.x;
y += offset.y;
}
var w = Obj.offsetWidth;
var h = Obj.offsetHeight;
return { x: x, y: y, w: w, h: h }
}*/
//对象设置焦点，传入的参数可为id或对象
function setFocus(idOrObj) {
    try {
        if (typeof (idOrObj) == 'object')
            idOrObj.focus();
        else
            getObj(idOrObj).focus();
    }
    catch (e) {
        //alert(e);
    }
}


//显示检测结果正确图片
function showOKImg(id, info) {
    var img = getObj(id);
    if (img) {
        img.className = 'ok';
        if (!info) info = '';
        img.title = info;
        displayObj(id, true);
    }
}

//显示检测结果错误图片
function showErrorImg(id, info) {
    var img = getObj(id);
    if (img) {
        img.className = 'error';
        if (!info) info = '';
        img.title = info;
        displayObj(id, true);
    }
}

//----设置对象是否显示------
function displayObj(idOrObj, isDisplay) {
    var tObj = (typeof (idOrObj) == 'object') ? idOrObj : getObj(idOrObj);
    if (!tObj) return;
    if (isDisplay)
        tObj.style.display = '';
    else
        tObj.style.display = 'none';
}

//清除input表单的值，checked表单置为未选中状态，select表单的值归0，
function clearBoxVlaue(name) {
    var boxs = getObjs(name);
    if (!boxs) return;
    for (var i = 0; i < boxs.length; i++) {
        var temp_Id = boxs[i].id;
        if (boxs[i].tagName == 'SELECT')
            setSelectValue(temp_Id, 0);
        else if (boxs[i].tagName == 'INPUT' && boxs[i].type == 'checkbox')
            boxs[i].checked = false;
        else
            boxs[i].value = '';
    }
}

//----根据id或对象与属性名称设置对象的属性值------
function setOAV(idOrObj, attributeName, value) {
    var tObj = (typeof (idOrObj) == 'object') ? idOrObj : getObj(idOrObj);
    if (!tObj) return null;
    try {
        tObj[attributeName] = value;
    }
    catch (e) {
        return null;
    }
}


//----设定Select表单的选定项------
function setSelectValue(idOrObj, v) {
    var tObj = (typeof (idOrObj) == 'object') ? idOrObj : getObj(idOrObj);
    if (!tObj) return;
    for (var i = 0; i < tObj.length; i++) {
        if (tObj.options[i].value == v) {
            tObj.options[i].selected = true;
            break;
        }
    }
}

//----设定一组单选框(radio)选择某个值------
function setRadioValue(rName, v) {
    var rs = document.getElementsByName(rName);
    if (!rs) return;
    for (var i = 0; i < rs.length; i++) {
        if (rs[i].value == v)

            rs[i].checked = true;
        else
            rs[i].checked = false;

    }
}

//----获取一组单选框(radio)所选的值------
function getRadioValue(rName) {
    var objs = document.getElementsByName(rName);
    if (!objs) return undefined;
    for (var i = 0; i < objs.length; i++) {
        if (objs[i].checked == true) return objs[i].value;
    }
}

//取消已选定的单选框
function dselectRadio(idOrObj) {
    //    var obj = (typeof (idOrObj) == 'object') ? idOrObj : getObj(idOrObj);
    //    if (!obj) return;
    //    if (obj.checked) obj.checked = false;
}

//----获取一组复选框(checkbox)所选的值的集合------
function getCheckboxValue(rName) {
    var objs = document.getElementsByName(rName);
    if (!objs) return undefined;
    var vArray = new Array();
    for (var i = 0; i < objs.length; i++) {
        if (objs[i].checked == true) vArray[vArray.length] = objs[i].value;
    }
    return vArray;
}

//数组对象remove方法，例：array.remove(1);
Array.prototype.remove = function(dx) {
    if (isNaN(dx) || typeof (dx) != 'number' || !this.length > 0 || dx > this.length) { return false; }
    for (var i = 0, n = 0; i < this.length; i++) {
        if (i != dx) {
            this[n++] = this[i];
        }
    }
    this.length -= 1;
}

//只允许输入数字(正)
function onlyInputNum(id) {
    var obj = (typeof (id) == "object") ? id : getObj(id);
    if (!obj) return;
    var tv = obj.value;
    var pattren = /^\d*/;
    var rL = tv.match(pattren);
    var v = (rL && rL[0].length > 0) ? parseInt(rL[0]) : '';
    obj.value = v;

    //    var obj  = (typeof(id) == "object")?id:getObj(id);
    //	if(!obj) return;
    //	var tv = obj.value;
    //	if(tv.isInt() || tv.isEmpty())return;
    //	tv = tv.substring(0,tv.length-1);
    //	while(tv && !tv.isInt() && tv.length > 0)
    //	{
    //		tv = tv.substring(0,tv.length-1);
    //	}
    //	obj.value = tv;
    //	//alert('Only input number!');
}

//只允许输入整数(正,负)
function onlyInputInt(id) {
    var obj = (typeof (id) == "object") ? id : getObj(id);
    if (!obj) return;
    var tv = obj.value;
    var pattren = /^-?\d*/;
    var rL = tv.match(pattren);
    var v = rL[0];
    v = (v.length > 0) ? parseInt(v) : '';
    obj.value = (rL) ? rL[0] : '';
    //alert('Only input number!');
}

//只允许输入数字与folat
function onlyInputFolat(id) {
    var obj = (typeof (id) == "object") ? id : getObj(id);
    if (!obj) return;
    var tv = obj.value;
    var pattren = /^\d+([\.]?)(\d*)/;
    var rL = tv.match(pattren);
    obj.value = (rL) ? rL[0] : '';
}

//替换对象
/*
newObj:新对象;
oldObj:要替换的旧对象
*/
function replaceObj(newObj, oldObj) {
    oldObj.parentNode.insertBefore(newObj, oldObj);
    oldObj.removeNode();
}

//利用name获取一组表单,为AJAX对象添加要传递的参数 (使用Rick's Ajax.js)
/*
ajaxObj:要添加参数的AJAX对象;
name:表单name;
idKey:表单id与AJAX对象参数名称的差异字符(表单id.replace(idKey) == AJAX对象参数名称)
*/
function ajaxAddItems(ajaxObj, name, idKey) {
    var boxs = getObjs(name);
    if (boxs) {
        for (var i = 0; i < boxs.length; i++) {
            ajaxObj.AddItem(boxs[i].id.replace(idKey, ''), boxs[i].value);
        }
    }
}

//把XML对象中的值填充到对应的一组表单中
/*
xmlObj:XML对象
name:要填充表单的name;
idKey:表单id与AJAX对象参数名称的差异字符(表单id.replace(idKey) == AJAX对象参数名称)
path:值在XML对象中的路径,如(Id的路径为：root/Data/Id，path就为：root/Data/);
*/
function setBoxsValue(xmlObj, name, idKey, path) {
    var boxs = getObjs(name);
    if (!boxs) return;
    for (var i = 0; i < boxs.length; i++) {
        var temp_Id = boxs[i].id;
        var v = GetNodeValue(xmlObj, path + temp_Id.replace(idKey, ''));
        if (boxs[i].tagName == 'SELECT')
            setSelectValue(temp_Id, v);
        else
            boxs[i].value = v;
    }
}


//获取返回的XML信息
function getReXmlInfo(xmlObj) {
    var rev;
    var info;
    if (typeof (xmlObj.childNodes) != 'undefined') {
        rev = GetNodeValue(xmlObj, 'Root/Value');
        info = GetNodeValue(xmlObj, 'Root/Info');
    }
    else {
        rev = xmlObj.Root.Value;
        info = xmlObj.Root.Info;
    }
    if (rev == -1)
        FDMFrame.Alert('警告', info);
    return { ReValue: rev, Info: info };
}

//获取自定义字段的示例
function GetFieidsExample(fType, width) {
    var example = '';
    var posWidth = 0;
    var checkFunction = '';
    switch (fType) {
        case 'datetime':
            example = ' (yyyy-MM-dd hh:mm ss)';
            posWidth = 140;
            break;
        case 'int':
            checkFunction = 'onlyInputNum(this);';
            break;
        case 'float':
            example = '￥';
            posWidth = 20;
            checkFunction = 'onlyInputFolat(this);';
            break;
        default:
            break;
    }
    width = width > posWidth ? width - posWidth : width;
    return { 'Example': example, 'Width': width, "CheckFunction": checkFunction };
}

//序列化对象
function Searial(obj) {
    var str = '';
    if (typeof (obj) == 'object') {
        for (node in obj) {
            str += escape(node) + ':' + escape(obj[node]) + ',';
        }
    }
    return str;
}

//反序列化对象
function UnSearial(str) {
    var obj = {};
    if (str) {
        var temp = str.split(',');
        if (temp && temp.length > 0) {
            for (var i = 0; i < temp.length; i++) {
                var tmp = temp[i].split(':');
                if (tmp.length = 2)
                    obj[unescape(tmp[0])] = unescape(tmp[1]);
            }
        }
    }
    return obj;
}

//解决IE6中Png类型图片的透明度问题
function enablePngImages() {
    var imgArr = document.getElementsByTagName("IMG");
    var version = parseFloat(navigator.appVersion.split("MSIE")[1]);

    if (version = 6.0 && (document.body.filters)) {
        for (var i = 0, j = imgArr.length; i < j; i++) {
            if (imgArr[i].src.toLowerCase().lastIndexOf(".png") != -1) {
                imgArr[i].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + imgArr[i].src + "', sizingMethod='auto')";
                imgArr[i].src = "/common/images/transparent.gif";
                imgArr[i].style.border = "none";
            }

            if (imgArr[i].currentStyle.backgroundImage.lastIndexOf(".png") != -1) {
                var img = imgArr[i].currentStyle.backgroundImage.substring(5, imgArr[i].currentStyle.backgroundImage.length - 2);
                imgArr[i].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + img + "', sizingMethod='crop')";
                imgArr[i].style.backgroundImage = "url(/common/images/transparent.gif)";
            }
        }
    }
}

//获取URL地址栏中请求的参数及值，并以数组的形式返回
function getURLParameters() {
    var url = location.href;
    var qs = url.substring(url.indexOf('?') + 1, url.length).split('&');
    var gs = {};
    for (var i = 0, l = qs.length; i < l; i++) {
        var p = qs[i];
        if (p)
            gs[p.substring(0, p.indexOf('='))] = p.substring(p.indexOf('=') + 1);
    }
    return gs;
}

//设置月份值
function setMonth(v) {
    return (v - 1);
}

//获取月份值
function getMonth(v) {
    return (v + 1);
}

//再新窗口中打开链接
function openNewWindow(path) {
    var na = document.all.openNewWindow;
    if (!na) {
        na = document.createElement('<a id="openNewWindow" style="display:none;"></a>');
        document.body.insertBefore(na);
    }
    document.all.openNewWindow.href = path;
    document.all.openNewWindow.target = "_blank";
    document.all.openNewWindow.click();
    return false;
}

/*
将数字字符串转为货币形式
str：要转换的数字字符串；
pre：精度；
moneyStr：货币符号；
    
例子： alert(parseMoney(135484342.7, 2, '￥'));
*/
function parseMoney(str, pre, moneyStr) {
    //数据是否符合货币格式
    if (/[^0-9\.\-]/.test(str)) str = 0;

    //判断是否为负值
    var isNegative = parseFloat(str) < 0;
    str = Math.abs(str).toString();

    //格式化小数点精度
    var preStr = '';
    var i = 0;
    while (i < pre) {
        preStr += 0;
        i++;
    }
    var idx = str.indexOf('.');
    if (idx == 0)
        return str;
    else if (idx == -1)
        str += '.' + preStr;
    else
        str += preStr;

    //分别取出整数与小数    
    var str1 = str.substr(0, str.indexOf('.'));
    var preStr = str.substr(str.indexOf('.'), pre + 1);

    //整数格式化
    str1 = str1.reverse().replace(/(\d{3})/g, "$1,").reverse();
    if (str1.indexOf(',') == 0) str1 = str1.substr(1);

    //重组
    if (isNegative) str1 = '-' + str1;
    str = moneyStr + str1 + preStr;
    return str;
}


//=================== > Sandheart ========================

//获得Cookie解码后的值

function GetCookieVal(offset) {
    var endstr = document.cookie.indexOf(";", offset);
    if (endstr == -1) {
        endstr = document.cookie.length;
    }
    return unescape(document.cookie.substring(offset, endstr));
}

//获得Cookie解码后的值
function GetCookieV(sName) {
    var aCookie = document.cookie.split("; ");
    for (var i = 0; i < aCookie.length; i++) {
        var aCrumb = aCookie[i].split("=");
        if (escape(sName) == aCrumb[0])
            return unescape(aCrumb[1]);
    }
    return null;
}
// 写 cookie
function setCookieT(sName, sValue, iTime) {
    if (ie) {
        setCookie(sName, sValue, iTime);
    }
    else {
        var date = new Date();
        if (iTime)
            date.setTime(date.getTime() + iTime * 1000);
        else
            date.setTime(date.getTime() + 3600 * 24 * 365 * 3 * 1000);
        //alert(date.getYear() + "," + date.getMonth() + "," + date.getDate());
        document.cookie = escape(sName) + "=" + escape(sValue) + "; Expires=" + date.toGMTString();
    }
}
// 读 cookie
function getCookieT(sName) {
    if (ie) {
        getCookie(sName);
    }
    else {
        var aCookie = document.cookie.split("; ");
        for (var i = 0; i < aCookie.length; i++) {
            var aCrumb = aCookie[i].split("=");
            if (escape(sName) == aCrumb[0])
                return unescape(aCrumb[1]);
        }
        return null;
    }
}
//设定Cookie值
function SetCookie(name, value) {
    var expdate = new Date();
    var argv = SetCookie.arguments;
    var argc = SetCookie.arguments.length;
    var expires = (argc > 2) ? argv[2] : null;
    var path = (argc > 3) ? argv[3] : null;
    var domain = (argc > 4) ? argv[4] : null;
    var secure = (argc > 5) ? argv[5] : false;
    if (expires != null) expdate.setTime(expdate.getTime() + (expires * 1000));
    //alert(expdate.getYear() + "," + expdate.getMonth() + "," + expdate.getDate());
    if (ie) {
        UserData.setValue(name, value, arguments.length > 2 ? arguments[2] : null);
    }
    else {
        var str = name + "=" + escape(value) + ";" + ((expires == null) ? "" : (" Expires=" + expdate.toGMTString() + ";")) + ((path == null) ? "" : (" path=" + path + ";")) + ((domain == null) ? "" : ("domain=" + domain + ";")) + ((secure == true) ? "secure;" : "");
        document.cookie = str;
    }
}
var setCookie = SetCookie;

//删除Cookie
function delCookie(name) { DelCookie(name); }
function removeCookie(name) { DelCookie(name); }
function RemoveCookie(name) { DelCookie(name); }
function DelCookie(name) {
    if (ie) {
        UserData.removeValue(name);
    }
    else {
        var exp = new Date();
        exp.setTime(exp.getTime() - 1);
        var cval = GetCookie(name);
        document.cookie = name + "=" + cval + "; Expires=" + exp.toGMTString();
    }
}
//获得Cookie的原始值
function getCookie(name) { return GetCookie(name) }
function GetCookie(name) {
    if (ie) {
        return UserData.getValue(name);
    }
    else {
        var arg = name + "=";
        var alen = arg.length;
        var clen = document.cookie.length;
        var i = 0;
        while (i < clen) {
            var j = i + alen;
            if (document.cookie.substring(i, j) == arg) {
                return GetCookieVal(j);
            }
            i = document.cookie.indexOf(" ", i) + 1;
            if (i == 0) {
                break;
            }
        }
        return null;
    }
}
var msgf = null;
var taskf = null;
var clockf = null;
function flash(id) {
    if (!ge(id)) return;
    switch (ge(id).className) {
        case "task1":
            if (taskf)
                ge(id).className = "task2";
            break;
        case "task2":
            ge(id).className = "task1";
            break;
        case "clock1":
            ge(id).className = "clock2";
            break;
        case "clock2":
            ge(id).className = "clock1";
            break;
        case "msg1":
            ge(id).className = "msg2";
            break;
        case "msg2":
            ge(id).className = "msg1";
            break;
    }
}
function msgflash() {
    return;
    if (msgf) {
        clearInterval(msgf);
        ge("msg").className = "msg2";
        msgf = null;
    }
    else
        msgf = setInterval("flash('msg')", 500);
}
function clockflash() {
    if (clockf) {
        clearInterval(clockf);
        ge("clock").className = "clock2";
        clockf = null;
    }
    else
        clockf = setInterval("flash('clock')", 500);
}
function taskflash() {
    if (taskf) {
        clearInterval(taskf);
        ge("task").className = "task2";
        taskf = null;
    }
    else
        taskf = setInterval("flash('task')", 500);
}
$(document).ready(function() {
    UserData.init();
    if (typeof (pageonload) == "function") setTimeout("pageonload()", 50);
    if (typeof (pageOnLoad) == "function") setTimeout("pageOnLoad()", 50);
});
$(window).resize(function() {
    if (typeof (pageonresize) == "function") pageonresize();
    if (typeof (pageOnResize) == "function") pageOnResize();
});
var UserData = {};
UserData.DataFile = "UDCookie";
UserData.Object = null;
UserData.init = function() {
    if (!UserData.Object) {
        try {
            UserData.Object = document.createElement('input');
            UserData.Object.type = "hidden";
            UserData.Object.addBehavior("#default#userData");
            document.body.appendChild(UserData.Object);
        }
        catch (e) {
            UserData.Object = null;
            return false;
        }
    }
    return true;
}
UserData.setValue = function(Name, Value, Time) {
    if (!UserData.Object) {
        if (!UserData.init()) return;
    }
    if (UserData.Object) {
        var o = UserData.Object;
        o.load(UserData.DataFile);
        if (UserData.DataFile) o.setAttribute(Name, escape(Value));
        var d = new Date(); //.Time.Date();
        d.setTime(d.getTime() + Time ? Time : 365 * 24 * 3600 * 1000);
        o.expires = d.toUTCString();
        o.save(UserData.DataFile);
    }
}
UserData.getValue = function(Name) {
    if (!UserData.Object) {
        if (!UserData.init()) return;
    }
    if (UserData.Object) {
        var o = UserData.Object;
        o.load(UserData.DataFile);
        return o.getAttribute(Name) ? unescape(o.getAttribute(Name)) : null;
    }
}
UserData.removeValue = function(Name) {
    //debugger;
    UserData.setValue(Name, null);
    return;
    if (!UserData.Object) {
        if (!UserData.init()) return;
    }
    if (UserData.Object) {
        var o = UserData.Object;
        o.load(UserData.DataFile);
        d.setTime(d.getTime() - 1000);
        o.expires = d.toUTCString();
        o.save(UserData.DataFile);
    }
}
String.prototype.toXml = function() {
    var xmlDoc = null;
    try {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async = "false";
        xmlDoc.loadXML(this);
    }
    catch (e) {
        try {
            parser = new DOMParser();
            xmlDoc = parser.parseFromString(this, "text/xml");
        }
        catch (e) { }
    }
    return xmlDoc;
}

/*
设置列表框的样式
boxId：列表框的Id；
listRows：列表的行数；
*/
setListOutBox = function(boxId, listRows, rowHeight) {
    if (!rowHeight) rowHeight = 23;
    getObj(boxId).style.height = (listRows * rowHeight + 80) + "px";
}
Sales = {}; //	   ：  命名空间
Sales.Pager = {}; //	   ：  分页控件Js


// 判断输入是否是数字--(数字包含小数)
function isnumber(str) {
    return !isNaN(str);
}

// 判断输入是否是一个整数
function isint(str) {
    var result = str.match(/^[0-9]+$/);
    if (result == null) return false;
    return true;
}


function DateAdd(interval, number, date) {
    /*
    *   功能:实现VBScript的DateAdd功能.
    *   参数:interval,字符串表达式，表示要添加的时间间隔.
    *   参数:number,数值表达式，表示要添加的时间间隔的个数.
    *   参数:date,时间对象.
    *   返回:新的时间对象.
    *   var   now   =   new   Date();
    *   var   newDate   =   DateAdd("d",5,now);
    *---------------   DateAdd(interval,number,date)   -----------------
    */
    switch (interval) {
        case "y":
            {
                date.setFullYear(date.getFullYear() + number);
                return date;
                break;
            }
        case "q":
            {
                date.setMonth(date.getMonth() + number * 3);
                return date;
                break;
            }
        case "m":
            {
                date.setMonth(date.getMonth() + number);
                return date;
                break;
            }
        case "w":
            {
                date.setDate(date.getDate() + number * 7);
                return date;
                break;
            }
        case "d":
            {
                date.setDate(date.getDate() + number);
                return date;
                break;
            }
        case "h":
            {
                date.setHours(date.getHours() + number);
                return date;
                break;
            }
        case "m":
            {
                date.setMinutes(date.getMinutes() + number);
                return date;
                break;
            }
        case "s":
            {
                date.setSeconds(date.getSeconds() + number);
                return date;
                break;
            }
        default:
            {
                date.setDate(d.getDate() + number);
                return date;
                break;
            }
    }
}