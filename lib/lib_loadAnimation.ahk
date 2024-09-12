showLoading(){
    global LoadingChar := [
        "_('<------",
        " _('=-----",
        " _('<-----",
        "  _('=----",
        "  _('<----",
        "   _('=---",
        "   _('<---",
        "    _('=--",
        "    _('<--",
        "     _('=-",
        "     _('<-",
        "      _(*=",
        "------_(*=",
        "------_(^<",
        "------_(^<",
        "------ |  ",
        "------>')_",
        "-----=')_ ",
        "----->')_ ",
        "----=')_  ",
        "---->')_  ",
        "---=')_   ",
        "--->')_   ",
        "--=')_    ",
        "-->')_    ",
        "-=')_     ",
        "->')_     ",
        "=*)_      ",
        "=*)_------",
        ">^)_------",
        ">^)_------",
        "  | ------"
    ]
    global LoadingGui := Gui("-Caption +AlwaysOnTop +Owner")
    LoadingGui.Font("s12 c0x555555", "Lucida Console")
    LoadingGui.Font("s12 c0x555555", "Fixedsys")
    LoadingGui.Font("s12 c0x555555", "Courier New")
    LoadingGui.Font("s12 c0x555555", "Source Code Pro")
    LoadingGui.Font("s12 c0x555555", "Consolas")
    LoadingText := LoadingGui.Add("Text", "H20 W100 Center", LoadingChar[1])
    global LoadingTextHwnd := ControlGetHwnd("Text")
    LoadingGui.Color("ffffff", "ffffff")
    LoadingGui.Show("Center NA")
    WinSetTransparent 230, "ahk_id " LoadingGui.Hwnd
    global charIndex := 1
    global loadingCharMaxIndex := LoadingChar.MaxIndex()
    SetTimer changeLoadingChar, 250, 777
    return LoadingGui
}

hideLoading(){
    SetTimer(changeLoadingChar, 0)
    LoadingGui.Destroy()
    return
}

changeLoadingChar(){
    charIndex := Mod(charIndex, loadingCharMaxIndex)+1
    ControlSetText %LoadingChar[charIndex]%, LoadingTextHwnd
    return
}
