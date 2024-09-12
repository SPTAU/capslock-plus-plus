;为了避免在IDE里Ctrl+C会复制一行，写个函数来获取
getSelText_testVersion()
{
    ClipboardOld := ClipboardAll
    Clipboard := ""
    SendInput "+{Left}^{c}+{Right}"
    ClipWait 0.1
    selText := Clipboard
    Clipboard := ClipboardOld
    ;~ MsgBox, % "@" . Asc(selText) . "@"
    ;~ MsgBox, % StrLen(selText)
    Length := StrLen(String)
    if(Ord(selText)!=13 && StrLen(selText)>1)
    {
        return SubStr(selText, 2)
    }
    else
    {
        return
    }
    Clipboard := ClipboardOld
    return
}


getSelText()
{
    ClipboardOld := ClipboardAll
    Clipboard := ""
    SendInput "^{insert}"
    ClipWait 0.1
    selText := Clipboard
    Clipboard := ClipboardOld
    lastChar := SubStr(selText, -1, 1)
    if(Ord(lastChar)!=10) ;如果最后一个字符是换行符，就认为是在IDE那复制了整行，不要这个结果
    {
        return selText
    }
    Clipboard := ClipboardOld
    return
}

UTF8encode(str) ; UTF8 encoding function
{
    returnStr := ""
    StrCap := StrPut(str, "UTF-8")  ; StrPut now directly supports "UTF-8"
    UTF8String := Buffer(StrCap)    ; Create a buffer with sufficient capacity

    StrPut(str, UTF8String, "UTF-8")  ; Store the string as UTF-8 in the buffer

    ; Loop through the buffer (ignoring the final null character)
    Loop StrCap - 1  ; StrPut includes the null terminator, so we subtract 1
    {
        char := NumGet(UTF8String, A_Index - 1, "UChar")  ; Get each byte
        returnStr .= "%" . Format("{:02X}", char)         ; Convert to hex and append
    }

    return returnStr  ; Return the percent-encoded string
}


URLencode(str) ;用于链接的话只要符号转换就行。需要全部转换的，用UTF8encode()
{
    local arr1 := ["!","#","$","&","'","(",")","*","+",",",":",";","=","?","@","[","]"], ;"/",
          arr2 := ["%21","%23","%24","%26","%27","%28","%29","%2a","%2b","%2c","%3a","%3b","%3d","%3f","%40","%5b","%5d"] ;"%2f",

    loop %arr1.MaxIndex()%
    {
        str := StrReplace(str, arr1[A_Index], arr2[A_Index])
    }
    ; MsgBox, % str
    return str
}


checkStrType(str, fuzzy := 0)
{
    if(!FileExist(str))
    {
        ;  msgbox, % str
        if(RegExMatch(str,"iS)^((https?:\/\/)|www\.)([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?|(https?:\/\/)?([\da-z\.-]+)\.(com|net|org)(\W[\/\w \.-]*)*\/?$"))
            return "web"
    }
    if(RegExMatch(str, "i)^ftp://"))
        return "ftp"
    else
    {
        if(fuzzy)
            return "fileOrFolder"
        if(RegExMatch(str,"iS)^[a-z]:\\.+\..+$"))
            return "file"
        if(RegExMatch(str,"iS)^[a-z]:\\[^.]*$"))
            return "folder"
    }
    return "unknown"
}

;winset, region窗口切割功能在放大了屏幕后(也就是dpi改变)不会改变，这里用来修复这个问题
;  100%dpi：96
;  125%dpi：120
;  150%dpi：144
;  200%dpi：192
;  250%dpi：240
;  300%dpi：288
;  400%dpi：384
;  500%dpi：480
fixDpi(num)
{
    ;msgbox, % Ceil(1/96*A_ScreenDPI)
    t := Ceil(num/96*A_ScreenDPI)
    if(A_ScreenDPI>96 && A_ScreenDPI<=120)  ;125%
        t+=1
    if(A_ScreenDPI>120 && A_ScreenDPI<=144) ;150
        t+=1
    if(A_ScreenDPI>144 && A_ScreenDPI<=192) ;200%
        t+=2
    if(A_ScreenDPI>192 && A_ScreenDPI<=240) ;250
        t+=3
    if(A_ScreenDPI>240 && A_ScreenDPI<=288) ;300%
        t+=4
    if(A_ScreenDPI>288) ; && A_ScreenDPI<=384 >=400%
        t+=6
    return t
}



;保存设置到settings.ini
setSettings(sec,key,val)
{
    IniWrite %val%, "CapsLock+settings.ini", %sec%, %key%
}

;显示一个信息
showMsg(msg, t := 2000)
{
    ToolTip %msg%
    t := -t
    settimer clearToolTip, %t%
}

clearToolTip(){
ToolTip
return
}

alert(str)
{
    msgbox %str%
    return
}

; 运行函数字符串，被运行的函数的参数只接收字符串，参数分割按 CSV 方式
; 最多支持3个参数
runFunc(str){
    ;如果只给了函数名，没有括号，当做是不传参直接调用函数
    if(!RegExMatch(Trim(str), "\)$"))
    {
        %str%()
        return
    }
    if(RegExMatch(str, "(\w+)\((.*)\)$", &match))
    {
        func:=Func(match[1])

        if(!match[2])
        {
            func()
            return
        }

        params:={}
        loop Parse, match[2], "CSV"
        {
            params.insert(A_LoopField)
        }

        parmasLen:=params.MaxIndex()

        if(parmasLen==1)
        {
            func(params[1])
            return
        }
        if(parmasLen==2)
        {
            func(params[1],params[2])
            return
        }
        if(parmasLen==3)
        {
            func(params[1],params[2],params[3])
            return
        }
    }
}
