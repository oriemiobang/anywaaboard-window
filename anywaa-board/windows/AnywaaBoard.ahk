#Requires AutoHotkey v2.0
#SingleInstance Force

; Anywaa Board - Dha Anywaa input fallback
; Requires AutoHotkey v2: https://www.autohotkey.com/
;
; Right Alt (RAlt) is used as AltGr:
;   RAlt + vowel       -> lowercase special vowel
;   RAlt + Shift + key -> uppercase special vowel or digraph
;
; Only the listed RAlt combinations are intercepted. Unbound keys retain
; their normal Windows behavior.

global MappingGuideUrl := "https://github.com/oriemiobang/anywaaboard-window/blob/main/windows/README.md"

; Vowels and special character.
RAlt & a:: SendDha("ä", "Ä")
RAlt & e:: SendDha("ë", "Ë")
RAlt & i:: SendDha("ï", "Ï")
RAlt & o:: SendDha("ö", "Ö")
RAlt & x:: SendDha("ø", "Ø")

; Lowercase and uppercase digraphs.
RAlt & d:: SendDha("dh", "DH")
RAlt & n:: SendDha("nh", "NH")
RAlt & g:: SendDha("ng", "NG")
RAlt & t:: SendDha("th", "TH")
RAlt & y:: SendDha("ny", "NY")

SendDha(lowercase, uppercase) {
    if GetKeyState("Shift", "P") {
        SendText(uppercase)
    } else {
        SendText(lowercase)
    }
}

iconPath := A_ScriptDir "\installer\assets\anywaa-board.ico"
if A_IsCompiled {
    TraySetIcon(A_ScriptFullPath)
} else if FileExist(iconPath) {
    TraySetIcon(iconPath)
} else {
    TraySetIcon("shell32.dll", 269)
}
A_TrayMenu.Delete()
A_TrayMenu.Add("Anywaa Board - Active", ShowStatus)
A_TrayMenu.Add()
A_TrayMenu.Add("Open key mapping guide", OpenMappingGuide)
A_TrayMenu.Add("Run on startup", ToggleStartup)
A_TrayMenu.Add("Exit", ExitScript)
A_TrayMenu.Default := "Anywaa Board - Active"
A_TrayMenu.ClickCount := 1

ShowStatus(*) {
    TrayTip("Anywaa Board is active.", "Anywaa Board")
}

OpenMappingGuide(*) {
    global MappingGuideUrl
    Run(MappingGuideUrl)
}

ToggleStartup(*) {
    startupPath := A_Startup "\" A_ScriptName

    if FileExist(startupPath) {
        FileDelete(startupPath)
        if FileExist(startupPath) {
            MsgBox("Could not remove the startup copy:`n" startupPath, "Anywaa Board", "Iconx")
            return
        }
        TrayTip("Anywaa Board will not start automatically.", "Startup disabled")
        return
    }

    try {
        FileCopy(A_ScriptFullPath, startupPath, true)
    } catch as error {
        MsgBox("Could not enable startup:`n" error.Message, "Anywaa Board", "Iconx")
        return
    }

    if !FileExist(startupPath) {
        MsgBox("The startup copy was not created:`n" startupPath, "Anywaa Board", "Iconx")
        return
    }
    TrayTip("Anywaa Board will start with Windows.", "Startup enabled")
}

ExitScript(*) {
    ExitApp()
}
