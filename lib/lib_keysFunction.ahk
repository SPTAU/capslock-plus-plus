; keys functions start-------------
; 所有按键对应功能都放在这，为防止从set.ini通过按键设置调用到非按键功能函数，
; 规定函数以"keyFunc_"开头

keyFunc_doNothing(){
    return
}

keyFunc_test(){
    MsgBox , "testing", "T1"
    return
}

keyFunc_send(p){
    Sendinput %p%
    return
}

keyFunc_run(p){
    run %p%
    return
}

keyFunc_toggleCapsLock(){
    SetCapsLockState, %GetKeyState("CapsLock","T") ? "Off" : "On"%
    return
}

keyFunc_mouseSpeedIncrease(){
    global
    mouseSpeed+=1
    if(mouseSpeed>20)
    {
        mouseSpeed:=20
    }
    showMsg("mouse speed: " . mouseSpeed, 1000)
    setSettings("System","mouseSpeed",mouseSpeed)
    return
}


keyFunc_mouseSpeedDecrease(){
    global
    mouseSpeed-=1
    if(mouseSpeed<1)
    {
        mouseSpeed:=1
    }
    showMsg("mouse speed: " . mouseSpeed, 1000)
    setSettings("System","mouseSpeed",mouseSpeed)
    return
}


keyFunc_moveLeft(i:=1){
    SendInput "{Left %i%}"
    return
}


keyFunc_moveRight(i:=1){
    SendInput "{Right %i%}"
    return
}


keyFunc_moveUp(i:=1){
    SendInput "{up %i%}"
    return
}


keyFunc_moveDown(i:=1){
    SendInput "{down %i%}"
    return
}


keyFunc_moveWordLeft(i:=1){
    SendInput "^{Left %i%}"
    return
}


keyFunc_moveWordRight(i:=1){
    SendInput "^{Right %i%}"
    return
}


keyFunc_backspace(){
    SendInput "{backspace}"
    return
}


keyFunc_delete(){
    SendInput "{delete}"
    return
}

keyFunc_deleteAll(){
    SendInput "^{a}{delete}"
    return
}

keyFunc_deleteWord(){
    SendInput "+^{left}"
    SendInput "{delete}"
    return
}


keyFunc_forwardDeleteWord(){
    SendInput "+^{right}"
    SendInput "{delete}"
    return
}


keyFunc_end(){
    SendInput "{End}"
    return
}


keyFunc_home(){
    SendInput "{Home}"
    return
}


keyFunc_moveToPageBeginning(){
    SendInput "^{Home}"
    return
}


keyFunc_moveToPageEnd(){
    SendInput "^{End}"
    return
}

keyFunc_deleteLine(){
    SendInput "{End}+{home}{bs}"
    return
}

keyFunc_deleteToLineBeginning(){
    SendInput "+{Home}{bs}"
    return
}

keyFunc_deleteToLineEnd(){
    SendInput "+{End}{bs}"
    return
}

keyFunc_deleteToPageBeginning(){
    SendInput "+^{Home}{bs}"
    return
}

keyFunc_deleteToPageEnd(){
    SendInput "+^{End}{bs}"
    return
}

keyFunc_enterWherever(){
    SendInput "{End}{Enter}"
    return
}

keyFunc_esc(){
    SendInput "{Esc}"
    return
}

keyFunc_enter(){
    SendInput "{Enter}"
    return
}

;双字符
keyFunc_doubleChar(char1,char2:=""){
    if(char2=="")
    {
        char2:=char1
    }
    charLen:=StrLen(char2)
    selText:=getSelText()
    ClipboardOld:=ClipboardAll
    if(selText)
    {
        Clipboard:=char1 . selText . char2
        SendInput "+{insert}"
    }
    else
    {
        Clipboard:=char1 . char2
        SendInput "+{insert}"
        ; prevent the left input from interrupting the paste (may occur in vscode)
        ; fact: tests show that 50ms is not enough
        Sleep 75
        SendInput "{left %charLen%}"
    }
    Sleep 100
    Clipboard:=ClipboardOld
    return
}

keyFunc_sendChar(char){
    ClipboardOld:=ClipboardAll
    Clipboard:=char
    SendInput "+{insert}"
    Sleep 50
    Clipboard:=ClipboardOld
    return
}

keyFunc_doubleAngle(){
    keyFunc_doubleChar("<",">")
    return
}

keyFunc_pageUp(){
    SendInput "{PgUp}"
    return
}


keyFunc_pageDown(){
    SendInput "{PgDn}"
    return
}

;页面向上移动一页，光标不动
keyFunc_pageMoveUp(){
    SendInput "^{PgUp}"
    return
}

;页面向下移动一页，光标不动
keyFunc_pageMoveDown(){
    SendInput "^{PgDn}"
    return
}

keyFunc_switchClipboard(){
    global
    if(CLsets.global.allowClipboard)
    {
        CLsets.global.allowClipboard:="0"
        setSettings("System","allowClipboard","0")
        showMsg("Clipboard OFF",1500)
    }
    else
    {
        CLsets.global.allowClipboard:="1"
        setSettings("System","allowClipboard","1")
        showMsg("Clipboard ON",1500)
    }
    return
}


keyFunc_undoRedo(){
    global
    if(ctrlZ)
    {
        SendInput "^{z}"
        ctrlZ:=""
    }
    Else
    {
        SendInput "^{y}"
        ctrlZ:=1
    }
    return
}


keyFunc_tabPrve(){
    SendInput "^+{tab}"
    return
}


keyFunc_tabNext(){
    SendInput "^{tab}"
    return
}


keyFunc_jumpPageTop(){
    SendInput "^{Home}"
    return
}


keyFunc_jumpPageBottom(){
    SendInput "^{End}"
    return
}


keyFunc_selectUp(i:=1){
    SendInput "+{Up %i%}"
    return
}


keyFunc_selectDown(i:=1){
    SendInput "+{Down %i%}"
    return
}


keyFunc_selectLeft(i:=1){
    SendInput "+{Left %i%}"
    return
}


keyFunc_selectRight(i:=1){
    SendInput "+{Right %i%}"
    return
}


keyFunc_selectHome(){
    SendInput "+{Home}"
    return
}


keyFunc_selectEnd(){
    SendInput "+{End}"
    return
}

keyFunc_selectToPageBeginning(){
    SendInput "+^{Home}"
    return
}


keyFunc_selectToPageEnd(){
    SendInput "+^{End}"
    return
}


keyFunc_selectCurrentWord(){
    SendInput "^{Left}"
    SendInput "+^{Right}"
    return
}


keyFunc_selectCurrentLine(){
    SendInput "{Home}"
    SendInput "+{End}"
    return
}


keyFunc_selectWordLeft(i:=1){
    SendInput "+^{Left %i%}"
    return
}


keyFunc_selectWordRight(i:=1){
    SendInput "+^{Right %i%}"
    return
}

;页面移动一行，光标不动
keyFunc_pageMoveLineUp(i:=1){
    SendInput "^{Up %i%}"
    return
}


keyFunc_pageMoveLineDown(i:=1){
    SendInput "^{Down %i%}"
    return
}


keyFunc_openCpasDocs(){
    if(isLangChinese())
    {
        Run "https://capslox.com/capslock-plus"
    } else {
        Run "https://capslox.com/capslock-plus/en.html"
    }
    return
}


keyFunc_mediaPrev(){
    SendInput "{Media_Prev}"
    return
}


keyFunc_mediaNext(){
    SendInput "{Media_Next}"
    return
}


keyFunc_mediaPlayPause(){
    SendInput "{Media_Play_Pause}"
    return
}


keyFunc_volumeUp(){
    SendInput "{Volume_Up}"
    return
}


keyFunc_volumeDown(){
    SendInput "{Volume_Down}"
    return
}


keyFunc_volumeMute(){
    SendInput "{Volume_Mute}"
    return
}


keyFunc_reload(){
    MsgBox reload, , 0.5
    Reload
    return
}

keyFunc_send_dot(){
    SendInput "{U+002e}"
    return
}


; 鼠标左键点击
keyfunc_click_left(){
    MouseClick "Left"
}

; 鼠标右键点击
keyfunc_click_right(){
    MouseClick "Right"
}

; 移动鼠标
keyfunc_mouse_up(){
    MouseMove 0, -dynamic_speed(), 0, "R"
}

keyfunc_mouse_down(){
    MouseMove 0, dynamic_speed(), 0, "R"
}

keyfunc_mouse_left(){
    MouseMove -dynamic_speed(), 0, 0, "R"
}

keyfunc_mouse_right(){
    MouseMove dynamic_speed(), 0, 0, "R"
}

; 上滑滚轮
keyfunc_wheel_up(){
    Send "{WheelUp 3}"
}

; 下滑滚轮
keyfunc_wheel_down(){
    Send "{Wheeldown 3}"
}


;keys functions end-------------


; 判断是否为连续点击，连续点击时指数增加移动速度
; init 初始单次移动距离
; a 加速度
; max 最大单次移动距离
dynamic_speed(init:=10, a:=0.2, max:=80)
{
    static N := 0
    if (A_ThisHotkey = A_PriorHotkey) and (A_TimeSincePriorHotkey < 300)
        N += a
    else
        N := 0
    return Min(Floor(init+Exp(N)), max)
}
