#Requires AutoHotkey v2.0
#SingleInstance Force

; Anywaa Board - Dha Anywaa Keyboard for Windows
; Publisher: Bella Technologies
; Repository: https://github.com/oriemiobang/anywaaboard-window

global MappingGuideUrl := "https://github.com/oriemiobang/anywaaboard-window/blob/main/anywaa-board/windows/README.md"
global AppName := "Anywaa Board"
global InstallDir := EnvGet("LOCALAPPDATA") "\Programs\AnywaaBoard"
global InstallExe := InstallDir "\AnywaaBoard.exe"
global RegRunKey := "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
global RegRunValue := "AnywaaBoard"

; ─── Check Command Line Arguments ─────────────────────────────────────────

global IsStartupLaunch := false
global IsFirstRun := false

for arg in A_Args {
    if (arg = "/startup")
        IsStartupLaunch := true
    else if (arg = "/firstrun")
        IsFirstRun := true
}

; ─── Self-Installation Check ──────────────────────────────────────────────
; When a user downloads AnywaaBoard.exe (e.g. from WhatsApp, Telegram, or Web)
; and runs it from Downloads, Desktop, or Temp, it installs itself permanently
; to %LOCALAPPDATA%\Programs\AnywaaBoard and configures auto-startup.

if (A_IsCompiled && StrLower(A_ScriptFullPath) != StrLower(InstallExe)) {
    RunInstaller()
    ExitApp()
}

; ─── Hotkey Mappings (Registered IMMEDIATELY for 0ms delay) ───────────────

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

; ─── System Tray Setup ───────────────────────────────────────────────────

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
A_TrayMenu.Add("Uninstall Anywaa Board", UninstallApp)
A_TrayMenu.Add()
A_TrayMenu.Add("Exit", ExitScript)
A_TrayMenu.Default := "Anywaa Board - Active"
A_TrayMenu.ClickCount := 1

if IsStartupRegistered() {
    A_TrayMenu.Check("Run on startup")
}

; ─── Visual Notification on Launch ───────────────────────────────────────

if IsStartupLaunch {
    ; Windows boot: show a floating badge so user knows it's active
    ShowNotification("⌨ Anywaa Board is Active", "Ready to type Dha Anywaa (Right Alt + key)")
} else if IsFirstRun {
    ShowNotification("✓ Anywaa Board Ready", "Auto-startup is enabled. Ready to type!")
} else {
    ShowNotification("⌨ Anywaa Board is Active", "Running in system tray. Ready to type!")
}

; ─── Self-Installer Function ─────────────────────────────────────────────

RunInstaller() {
    installGui := Gui("+AlwaysOnTop -MinimizeBox -MaximizeBox", "Anywaa Board Setup")
    installGui.BackColor := "FFFFFF"
    installGui.MarginX := 30
    installGui.MarginY := 25

    ; App Title
    installGui.SetFont("s16 Bold c1B4F72", "Segoe UI")
    installGui.Add("Text", "w360 Center", "Anywaa Board Setup")

    ; Subtitle
    installGui.SetFont("s10 Norm c666666", "Segoe UI")
    installGui.Add("Text", "w360 Center", "Dha Anywaa Keyboard for Windows")

    installGui.Add("Text", "w360 h10", "")

    ; Status label
    installGui.SetFont("s9 Norm c333333", "Segoe UI")
    statusLabel := installGui.Add("Text", "w360 Center", "Preparing installation...")

    ; Progress bar
    progressBar := installGui.Add("Progress", "w360 h22 c2E86C1 BackgroundEAECEE Range0-100", 15)

    installGui.Add("Text", "w360 h10", "")

    installGui.Show("w420 AutoSize Center")

    ; Step 1: Create install folder
    Sleep(250)
    statusLabel.Value := "Creating installation folder..."
    progressBar.Value := 35
    try {
        if !DirExist(InstallDir)
            DirCreate(InstallDir)
    }

    ; Step 2: Stop any running instance and copy file
    Sleep(250)
    statusLabel.Value := "Installing Anywaa Board..."
    progressBar.Value := 60
    try {
        RunWait('powershell -WindowStyle Hidden -Command "Get-Process -Name AnywaaBoard* -ErrorAction SilentlyContinue | Where-Object { $_.Id -ne ' . ProcessExist() . ' } | Stop-Process -Force"', , "Hide")
        Sleep(200)
    }
    try {
        FileCopy(A_ScriptFullPath, InstallExe, true)
    } catch as err {
        MsgBox("Failed to install Anywaa Board:`n" err.Message, "Installation Error", "Iconx")
        return
    }

    ; Step 3: Configure Startup & Shortcuts
    Sleep(250)
    statusLabel.Value := "Configuring automatic startup on Windows boot..."
    progressBar.Value := 85
    EnableStartup()

    try {
        startMenuDir := A_Programs "\Anywaa Board"
        if !DirExist(startMenuDir)
            DirCreate(startMenuDir)
        FileCreateShortcut(InstallExe, startMenuDir "\Anywaa Board.lnk", InstallDir, "", "Dha Anywaa Keyboard Layout", InstallExe)
    }

    ; Step 4: Finished!
    Sleep(250)
    progressBar.Value := 100
    statusLabel.SetFont("s11 Bold c27AE60", "Segoe UI")
    statusLabel.Value := "✓ Anywaa Board installed successfully!"

    installGui.SetFont("s9 Norm c444444", "Segoe UI")
    infoLabel := installGui.Add("Text", "w360 Center", "Anywaa Board will now start automatically whenever your computer turns on.`n`nUse Right Alt (RAlt) + key to type Dha Anywaa.")

    doneBtn := installGui.Add("Button", "w140 h34 x140 Default", "Start Typing")
    doneBtn.OnEvent("Click", (*) => installGui.Destroy())

    ; Launch the permanent installed copy
    try {
        Run('"' . InstallExe . '" /firstrun')
    }

    ; Automatically close the setup window after 4 seconds if not clicked
    SetTimer(() => (WinExist("Anywaa Board Setup") ? installGui.Destroy() : 0), -4000)
    WinWaitClose("ahk_id " . installGui.Hwnd)
}

; ─── Floating Notification Badge ─────────────────────────────────────────

ShowNotification(title, msg, duration := 3500) {
    global notiGui
    try {
        if IsSet(notiGui) && notiGui
            notiGui.Destroy()
    }
    notiGui := Gui("+AlwaysOnTop -Caption +ToolWindow +Border", "AnywaaNotification")
    notiGui.BackColor := "1E1E1E"
    notiGui.MarginX := 16
    notiGui.MarginY := 12
    notiGui.SetFont("s10 Bold cFFFFFF", "Segoe UI")
    notiGui.Add("Text", "w290", title)
    notiGui.SetFont("s9 Norm cCCCCCC", "Segoe UI")
    notiGui.Add("Text", "w290", msg)

    MonitorGetWorkArea(, &left, &top, &right, &bottom)
    x := right - 330
    y := bottom - 85
    notiGui.Show("x" . x . " y" . y . " NoActivate")

    ; Auto-dismiss after duration
    SetTimer(() => (IsSet(notiGui) && notiGui ? notiGui.Destroy() : 0), -duration)
}

; ─── Startup Management Functions ────────────────────────────────────────

IsStartupRegistered() {
    global RegRunKey, RegRunValue, InstallExe
    try {
        val := RegRead(RegRunKey, RegRunValue)
        return true
    } catch {
        shortcutPath := A_Startup "\AnywaaBoard.lnk"
        return FileExist(shortcutPath) ? true : false
    }
}

EnableStartup() {
    global RegRunKey, RegRunValue, InstallExe, InstallDir
    target := FileExist(InstallExe) ? InstallExe : A_ScriptFullPath

    ; 1. Registry Run key
    try {
        RegWrite('"' . target . '" /startup', "REG_SZ", RegRunKey, RegRunValue)
    }

    ; 2. Startup Folder shortcut
    try {
        FileCreateShortcut(target, A_Startup "\AnywaaBoard.lnk", InstallDir, "/startup", "Anywaa Board Keyboard", target)
    }

    ; 3. Eliminate Windows Startup Delay so it runs immediately on boot
    try {
        RegWrite(0, "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize", "StartupDelayInMSec")
    }
}

DisableStartup() {
    global RegRunKey, RegRunValue
    try {
        RegDelete(RegRunKey, RegRunValue)
    }
    try {
        shortcutPath := A_Startup "\AnywaaBoard.lnk"
        if FileExist(shortcutPath)
            FileDelete(shortcutPath)
    }
}

ToggleStartup(*) {
    if IsStartupRegistered() {
        DisableStartup()
        A_TrayMenu.Uncheck("Run on startup")
        ShowNotification("Startup Disabled", "Anywaa Board will not start automatically on Windows boot.")
    } else {
        EnableStartup()
        A_TrayMenu.Check("Run on startup")
        ShowNotification("Startup Enabled", "Anywaa Board will start automatically whenever Windows turns on.")
    }
}

; ─── Tray Menu Handlers ──────────────────────────────────────────────────

ShowStatus(*) {
    ShowNotification("⌨ Anywaa Board is Active", "Use Right Alt (RAlt) + vowels/keys to type Dha Anywaa.")
}

OpenMappingGuide(*) {
    global MappingGuideUrl
    Run(MappingGuideUrl)
}

UninstallApp(*) {
    global InstallDir
    result := MsgBox("Are you sure you want to uninstall Anywaa Board?", "Uninstall Anywaa Board", "YesNo Icon? Default2")
    if (result != "Yes")
        return

    ; Remove startup & shortcuts
    DisableStartup()
    try {
        startMenuDir := A_Programs "\Anywaa Board"
        if DirExist(startMenuDir)
            DirDelete(startMenuDir, true)
    }

    ; Delete installation directory via background process after exit
    try {
        cmd := 'powershell -WindowStyle Hidden -Command "Start-Sleep -Seconds 1; Remove-Item -LiteralPath \"' . InstallDir . '\" -Recurse -Force -ErrorAction SilentlyContinue"'
        Run(cmd, , "Hide")
    }

    MsgBox("Anywaa Board has been uninstalled successfully.", "Anywaa Board", "Iconi")
    ExitApp()
}

ExitScript(*) {
    ExitApp()
}
