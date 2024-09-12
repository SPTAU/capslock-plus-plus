;~ 初始化段，也就是自动运行段，所有需要自动运行的代码放这里，然后放到程序最开头

initAll()
{
    Suspend True ;挂起所有热键

    loadingAnimation := IniRead("CapsLock+settings.ini", "System", "loadingAnimation", 1)
    language := IniRead("CapsLock+settings.ini", "System", "language", 0)

    if(loadingAnimation != "0")
        showLoading

    ;------------  language -----------
    ;  language:=CLsets.global.language

    if(isLangChinese())
    {
        language_Simplified_Chinese()
    } else {
        language_English()
    }
    ;------------  /language -----------

    settingsInit() ;初始化设置

    ;  bindWinsInit()

    ;  jsEval_init()

    ;  global needInitQ:=1 ;+q初始化标志位
    ;  CLq() ;初始化+q

    ;  setTimer(mouseSpeedInit, -1)
    Suspend False

    if(loadingAnimation != "0")
        hideLoading
}
