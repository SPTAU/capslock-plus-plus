/*
提出settings.ini的设置信息

ini demo:
diko(Korean Dict)=http://cndic.naver.com/search/all?q={q}
CLSets object Demo:
CLSets.QRun=
{
    diko:{  //键值，排除掉括号里面的
        fullKey:"diko(Korean Dict)", //全名键值
        setValue:"http://cndic.naver.com/search/all?q={q}",
        iconIndex:17;   //icon索引
    }
}
*/
settingsInit(){
global settingsModifyTime ;设置文件的修改时间
global CLSets:={} ;保存Capslock+settings.ini的各种设置
CLSets.length:={} ;保存settings.ini中每个字段的关键词数量
global setsChanges:={} ;保存哪些设置经过改变
;set.ini 里面所有字段名，有更新必须修改这里，否则会无法获取
global iniSections:=["System","QSearch","QRun","QWeb","TabHotString","QStyle","TTranslate","Keys"]
settingsModifyTime := FileGetTime("CapsLock+settings.ini")

;init CapsLock+settingsDemo.ini and CapsLock+settings.ini
if not FileExist("CapsLock+settingsDemo.ini")
{
    FileAppend %lang_settingsDemoFileContent_1%, "CapsLock+settingsDemo.ini", "UTF-16"
    FileAppend %lang_settingsDemoFileContent_2%, "CapsLock+settingsDemo.ini", "UTF-16"
    FileSetAttrib "+R", "CapsLock+settingsDemo.ini"
}
else
{
    setDemoModifyTime := FileGetTime("CapsLock+settingsDemo.ini")
    if FileExist("language")
    {
        thisScriptModifyTime := FileGetTime("language")
    }
    else
    {
        thisScriptModifyTime := FileGetTime(%A_ScriptName%)
    }

    thisScriptModifyTime -= setDemoModifyTime
    if(thisScriptModifyTime > 0) ;如果主程序文件比较新，那就是更新过，那就覆盖一遍
    {
        FileSetAttrib "-R", "CapsLock+settingsDemo.ini"
        FileDelete "CapsLock+settingsDemo.ini"
        FileAppend %lang_settingsDemoFileContent_1%, "CapsLock+settingsDemo.ini", "UTF-16"
        FileAppend %lang_settingsDemoFileContent_2%, "CapsLock+settingsDemo.ini", "UTF-16"
        FileSetAttrib "+R", "CapsLock+settingsDemo.ini"
    }
}
if not FileExist("CapsLock+settings.ini")
{
    FileAppend %lang_settingsFileContent%, "CapsLock+settings.ini", "UTF-16"
}
lang_settingsDemoFileContent_1:=""
lang_settingsDemoFileContent_2:=""
lang_settingsFileContent:=""
;  IniRead, settingsSections, CapsLock+settings.ini, , , %A_Space%
;  sectionArr:=StrSplit(settingsSections,"`n")
for key,sectionValue in iniSections
{
    setsChanges[sectionValue]:={}
    setsChanges[sectionValue].deleted:={}
    setsChanges[sectionValue].modified:={}
    setsChanges[sectionValue].appended:={}
    settingsSectionInit(sectionValue)
}
keysInit()
SetTimer globalSettings, -1
SetTimer setShortcutKey, -1
SetTimer hotStringInit, -1
SetTimer monitorSettingsFile, 500
return
}
;监控设置文件的修改，并作出改动
monitorSettingsFile(){
latestModifyTime := FileGetTime("CapsLock+settings.ini")
if(latestModifyTime!=settingsModifyTime)
{
    settingsModifyTime:=latestModifyTime
    ;  IniRead, settingsSections, CapsLock+settings.ini, , , %A_Space%
    ;  sectionArr:=StrSplit(settingsSections,"`n")
    isChange := {}
    for key,sectionValue in iniSections ;sectionArr
    {
        isChange[sectionValue] := settingsSectionInit(sectionValue)
    }
    if (isChange["Keys"]=1)
    {
        SetTimer keysInit, -1
    }
    if(isChange["System"]=1) ;如果global改过
    {

        for key1 in setsChanges.System
        {
            for key2 in setsChanges.System[key1]
            {
                SetTimer globalSettings, -1
            }
        }
    }
    if(isChange["TabHotString"]=1)
    {
        SetTimer hotStringInit, -1
    }
}
return
}
getShortSetKey(str)
{
    return RegExReplace(str, "\s*<.*>$")
}

settingsSectionInit(sectionValue)
{
    isChange:=0 ;这个字段是否有改动过
    settingsKeys := IniRead("CapsLock+settings.ini", %sectionValue%, , %A_Space%)
    settingsKeys := RegExReplace(settingsKeys, "m`n)=.*$")
    keyArr:=StrSplit(settingsKeys,"`n")


    tempLen:=CLSets.length[sectionValue]
    if !IsNumber(tempLen) ;如果还没初始化过
    {
        CLSets[sectionValue]:={}
        _clsetsSec:=CLSets[sectionValue]
        CLSets.length[sectionValue]:=0

        for key,keyValue in keyArr
        {
            setValue := IniRead("CapsLock+settings.ini", %sectionValue%, %keyValue%, %A_Space%)

            if(sectionValue="Keys")
            {
                ;如果是 keys 项的值，控制它们的开头必须为 "keyFunc_" ，以避免调用到其他非 keyFunc_ 函数
                ;同时，也就要求所有按键函数名应该以 "keyFunc_" 开头
                if(SubStr(setValue,1,8)="keyFunc_")
                    _clsetsSec[keyValue]:=setValue
                ;  else
                ;      _clsetsSec[keyValue]:="keyFunc_" . setValue
            }
            else
            {
                _clsetsSec[keyValue]:=setValue
            }
            CLSets.length[sectionValue]++
        }
    }
    else    ;不是初始化
    {
        _clsetsSec:=CLSets[sectionValue]
        for key,value in _clsetsSec
        {
            valNew := IniRead("CapsLock+settings.ini", %sectionValue%, %key%, %A_Space%)
            if(valNew="") ;已删除
            {
                ;在这里接直接删除CLSets的话，循环的index会被弄乱，跑完for才删除CLSets
                setsChanges[sectionValue].deleted.insert(key)
                isChange:=1
            }
            else
            {
                if(value!=valNew)
                {
                    ;  msgbox, % value . "@" . valNew
                    _clsetsSec[key]:=valNew
                    setsChanges[sectionValue].modified[key]:=valNew
                    isChange:=1
                }
            }
        }

        for key, value in setsChanges[sectionValue].deleted
        {
            _clsetsSec.remove(value)
            CLSets.length[sectionValue]--
        }

        for key,value in keyArr
        {
            valOld:=_clsetsSec[value]
            if(!(valOld=0||valOld)) ;如果未声明过的变量， 新添加
            {
                valNew := IniRead("CapsLock+settings.ini", %sectionValue%, %value%, %A_Space%)
                _clsetsSec[value]:=valNew
                CLSets.length[sectionValue]++
                setsChanges[sectionValue].appended[value]:=valNew
                isChange:=1
            }
        }

    }
return isChange
}


globalSettings(){
;  scriptNameNoSuffix:=RegExReplace(A_ScriptName , "i)(\.ahk|\.exe)$")
;----------auto start-------------
autostartLnk := A_StartupCommon . "\CapsLock+.lnk"
if(CLsets.global.autostart) ;如果开启开机自启动
{
    if FileExist(%autostartLnk%)
    {
        FileGetShortcut %autostartLnk%, &lnkTarget
        if(lnkTarget!=A_ScriptFullPath)
            FileCreateShortcut %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir%
    }
    else
    {
        FileCreateShortcut %A_ScriptFullPath%, %autostartLnk%, %A_WorkingDir%
    }
}
else
{
    if FileExist(%autostartLnk%)
    {
        FileDelete %autostartLnk%
    }
}

if(CLsets.System.allowClipboard!="0")
	CLsets.System.allowClipboard:=1

return
}
; 支持ctrl+alt+Capslock启动capslock+
setShortcutKey(){
startMenuLnk := A_ProgramsCommon . "\CapsLock+.lnk"
if FileExist(%startMenuLnk%)
{
    FileGetShortcut %startMenuLnk%, &lnkTarget
    if(lnkTarget!=A_ScriptFullPath)
        FileCreateShortcut %A_ScriptFullPath%, %startMenuLnk%, %A_WorkingDir%
}
else
{
    FileCreateShortcut %A_ScriptFullPath%, %startMenuLnk%, %A_WorkingDir%
}
return
}
; caps+tab 热字串替换初始化；用拼接正则的方法实现关键字匹配
hotStringInit(){
global regexHotString:="iS)("
for key,value in CLSets.TabHotString
{
    regexHotString.="\Q" . key . "\E" . "|"
}
for key,value in CLSets.QRun
{
    regexHotString.="\Q" . key . "\E" . "|"
}
for key,value in CLSets.QWeb
{
    regexHotString.="\Q" . key . "\E" . "|"
}
regexHotString.=")$"
return
}
CLhotString()
{
    matchKey:=""
    RegExMatch(Clipboard, regexHotString, matchKey)
    if(matchKey)
    {
        if(CLSets.TabHotString[matchKey])
        {
            temp := RegExReplace(Clipboard, "\Q" . matchKey . "\E$", CLSets.TabHotString[matchKey])
            temp := StrReplace(temp, "\n", "`n", 1, , -1) ;替换换行符
            temp := StrReplace(temp, "`n", "\n", 1, , -1) ;有转义符的换回来
            Clipboard:=temp
        }
        else if(IsObject(CLSets.QRun[matchKey]))
        {
            Clipboard:=RegExReplace(Clipboard, "\Q" . matchKey . "\E$", CLSets.QRun[matchKey].setValue)
        }
        else
        {
            Clipboard:=RegExReplace(Clipboard, "\Q" . matchKey . "\E$", CLSets.QWeb[matchKey].setValue)
        }
    }

    return matchKey
}



