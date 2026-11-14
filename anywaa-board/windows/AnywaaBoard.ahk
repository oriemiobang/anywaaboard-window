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

global MappingGuideUrl := "https://github.com/oriemiobang/anywaaboard-window/blob/main/anywaa-board/windows/README.md"

; ─── Startup splash screen ───────────────────────────────────────────────

ShowSplash() {
    splashGui := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", "Anywaa Board")
    splashGui.BackColor := "FFFFFF"
    splashGui.MarginX := 30
    splashGui.MarginY := 20

    ; App title
    splashGui.SetFont("s16 Bold c333333", "Segoe UI")
    splashGui.Add("Text", "w340 Center", "Anywaa Board")

    ; Subtitle
    splashGui.SetFont("s10 Norm c666666", "Segoe UI")
    splashGui.Add("Text", "w340 Center", "Dha Anywaa Keyboard")

    ; Spacer
    splashGui.Add("Text", "w340 h5", "")

    ; Status label
    splashGui.SetFont("s9 Norm c444444", "Segoe UI")
    statusText := splashGui.Add("Text", "w340 Center vStatusText", "Loading keyboard mappings...")

    ; Progress bar
    progressBar := splashGui.Add("Progress", "w340 h20 c2E86C1 BackgroundE8E8E8 vProgressBar Range0-100", 0)

    ; Spacer
    splashGui.Add("Text", "w340 h5", "")

    splashGui.Show("w400 AutoSize")

    ; Animate the progress bar
    steps := [
        {value: 20, text: "Loading keyboard mappings...", delay: 300},
        {value: 45, text: "Registering hotkeys...", delay: 300},
        {value: 70, text: "Setting up system tray...", delay: 300},
        {value: 90, text: "Almost ready...", delay: 200},
        {value: 100, text: "Anywaa Board is ready!", delay: 200}
    ]

    for step in steps {
        progressBar.Value := step.value
        statusText.Value := step.text
        Sleep(step.delay)
    }

    ; Brief pause to show the completed state
    Sleep(400)

    ; Show success message
    splashGui.SetFont("s11 Bold c27AE60", "Segoe UI")
    statusText.SetFont("s11 Bold c27AE60", "Segoe UI")
    statusText.Value := "✓ Anywaa Board is active!"

    splashGui.SetFont("s8 Norm c888888", "Segoe UI")
    splashGui.Add("Text", "w340 Center", "Look for the icon in your system tray (bottom-right)")

    splashGui.Show("w400 AutoSize")
    Sleep(2500)
    splashGui.Destroy()
}

ShowSplash()

; ─── Hotkey mappings ─────────────────────────────────────────────────────

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

; ─── System tray setup ───────────────────────────────────────────────────

iconPath := A_ScriptDir "\installer\assets\anywaa-board.ico"
if A_IsCompiled {
    TraySetIcon(A_ScriptFullPath)
} else if FileExist(iconPath) {
    TraySetIcon(iconPath)
} else {
    TraySetIcon("shell32.dll", 269)
}

A_IconTip := "Anywaa Board - Dha Anywaa Keyboard"

A_TrayMenu.Delete()
A_TrayMenu.Add("Anywaa Board - Active", ShowStatus)
A_TrayMenu.Add()
A_TrayMenu.Add("Open key mapping guide", OpenMappingGuide)
A_TrayMenu.Add("Run on startup", ToggleStartup)
A_TrayMenu.Add("Exit", ExitScript)
A_TrayMenu.Default := "Anywaa Board - Active"
A_TrayMenu.ClickCount := 1

; Check the startup menu item if already in startup folder.
startupCheck := A_Startup "\" A_ScriptName
if FileExist(startupCheck) {
    A_TrayMenu.Check("Run on startup")
}

; ─── Tray menu handlers ─────────────────────────────────────────────────

ShowStatus(*) {
    TrayTip("Anywaa Board is running.`nUse RAlt + key for Dha Anywaa characters.", "Anywaa Board")
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
        A_TrayMenu.Uncheck("Run on startup")
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
    A_TrayMenu.Check("Run on startup")
    TrayTip("Anywaa Board will start with Windows.", "Startup enabled")
}

ExitScript(*) {
    ExitApp()
}
