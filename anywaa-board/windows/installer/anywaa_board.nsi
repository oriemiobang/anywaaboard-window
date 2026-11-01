; Anywaa Board for Windows - NSIS installer wrapper
; Build from this directory with:
;   makensis anywaa_board.nsi
;
; The MKLC package must be present at:
;   ../build/mklc_output/setup.exe

Unicode true
ManifestDPIAware true

!include "MUI2.nsh"
!include "LogicLib.nsh"

!define APP_NAME "Anywaa Board"
!define APP_VERSION "1.0.0"
!define APP_PUBLISHER "Bella Technologies"
!define APP_WEBSITE "https://bellatechnologies.com"
!define APP_UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\AnywaaBoard"
!define MKLC_SETUP "..\build\mklc_output\setup.exe"

Name "${APP_NAME} ${APP_VERSION}"
OutFile "..\dist\AnywaaBoard_Setup_v${APP_VERSION}.exe"
InstallDir "$PROGRAMFILES\Anywaa Board"
InstallDirRegKey HKLM "${APP_UNINSTALL_KEY}" "InstallLocation"
RequestExecutionLevel admin
SetCompressor /SOLID lzma
SetDatablockOptimize on

VIProductVersion "1.0.0.0"
VIAddVersionKey "ProductName" "${APP_NAME}"
VIAddVersionKey "ProductVersion" "${APP_VERSION}"
VIAddVersionKey "CompanyName" "${APP_PUBLISHER}"
VIAddVersionKey "LegalCopyright" "Copyright (c) 2026 ${APP_PUBLISHER}"
VIAddVersionKey "FileDescription" "Dha Anywaa keyboard layout installer"
VIAddVersionKey "FileVersion" "${APP_VERSION}"

!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE "${APP_NAME} setup"
!define MUI_WELCOMEPAGE_TEXT "This wizard installs the ${APP_NAME} Dha Anywaa keyboard layout."
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Open Windows keyboard settings"
!define MUI_FINISHPAGE_RUN_FUNCTION OpenKeyboardSettings

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Function .onInit
    SetShellVarContext all
FunctionEnd

Function un.onInit
    SetShellVarContext all
FunctionEnd

Function OpenKeyboardSettings
    ExecShell "open" "ms-settings:regionlanguage"
FunctionEnd

Section "Anywaa Board keyboard layout" MainSection
    SetShellVarContext all
    SetOutPath "$INSTDIR"
    SetOverwrite ifnewer

    ; Keep the original MKLC package so the wrapper can request its uninstall.
    File /oname=mklc_setup.exe "${MKLC_SETUP}"

    ; MKLC setup.exe is interactive and may request its own elevation.
    ExecWait '"$INSTDIR\mklc_setup.exe"' $0
    ${If} $0 != 0
        MessageBox MB_ICONSTOP|MB_OK \
            "The keyboard layout installer returned error code $0. The installation was not completed."
        Abort
    ${EndIf}

    WriteUninstaller "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "${APP_UNINSTALL_KEY}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "${APP_UNINSTALL_KEY}" "DisplayVersion" "${APP_VERSION}"
    WriteRegStr HKLM "${APP_UNINSTALL_KEY}" "Publisher" "${APP_PUBLISHER}"
    WriteRegStr HKLM "${APP_UNINSTALL_KEY}" "URLInfoAbout" "${APP_WEBSITE}"
    WriteRegStr HKLM "${APP_UNINSTALL_KEY}" "InstallLocation" "$INSTDIR"
    WriteRegStr HKLM "${APP_UNINSTALL_KEY}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
    WriteRegStr HKLM "${APP_UNINSTALL_KEY}" "QuietUninstallString" '"$INSTDIR\Uninstall.exe" /S'
SectionEnd

Section "Uninstall"
    SetShellVarContext all

    ; The MKLC package owns the layout registration and DLL removal.
    IfFileExists "$INSTDIR\mklc_setup.exe" 0 remove_wrapper
    ExecWait '"$INSTDIR\mklc_setup.exe" /uninstall' $0
    ${If} $0 != 0
        MessageBox MB_ICONSTOP|MB_OK \
            "The keyboard layout uninstaller returned error code $0. The wrapper was not removed."
        Abort
    ${EndIf}

remove_wrapper:
    DeleteRegKey HKLM "${APP_UNINSTALL_KEY}"
    Delete "$INSTDIR\mklc_setup.exe"
    Delete "$INSTDIR\Uninstall.exe"
    RMDir "$INSTDIR"
SectionEnd
