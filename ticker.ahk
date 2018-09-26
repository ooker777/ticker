; ticker - A Simple Time Tracker
; track your time usage on a daily basis

#InstallKeybdHook
#InstallMouseHook
Menu, Tray, Icon, %A_WinDir%\system32\shell32.dll, 44
Menu, Tray, Tip, ticker - A Simple Time Tracker`nPress numlock to see details

SetWorkingDir, C:\Users\%A_UserName%\Documents
SetTimer, CheckTime, 60000 ; updates every 1 minute

CheckTime:
    FormatTime, thedate, , dd-MM-yyyy

    IniRead, dc,    track.txt, %thedate%, dc,    0
    IniRead, NonFocused,      track.txt, %thedate%, nonfocused,       0
    IniRead, IdleTime,        track.txt, %thedate%, idle,        0

    If (A_TimeIdlePhysical < 600000) ; 10 minutes
    {
        If (WinActive("ahk_class DSUI:PDFXCViewer") or WinActive("ahk_class  Framework::CFrame")) 
            dc++
        Else
            NonFocused++
    }
    Else
        IdleTime++
    
    TotalTime := dc + NonFocused + IdleTime

    IniWrite, %dc%,    track.txt, %thedate%, dc
    IniWrite, %NonFocused% ,     track.txt, %thedate%, nonfocused
    IniWrite, %IdleTime% ,     track.txt, %thedate%, idle
    IniWrite, %TotalTime% ,      track.txt, %thedate%, total

Return

FormatMinutes(NumberOfMinutes)  ; Convert mins to hh:mm
{
    Time := 19990101 ; *Midnight* of an arbitrary date
    Time += %NumberOfMinutes%, minutes
    FormatTime, Hmm, %Time%, H'h 'mm
    Return Hmm
}

numlock::
    ; Gui, Add, Text,, % "Dispassionated Concentration: " 
	Gui, font, s15, bold
    Gui, Add, Text, , % FormatMinutes(dc)
	Gui, font
	Gui, Add, Text,xs Y+0, % "Non Focused："  FormatMinutes(NonFocused)
                               . "`nIdle Time："  FormatMinutes(IdleTime)
                               . "`nTotal Time："  FormatMinutes(TotalTime)

    Gui, -SysMenu
    FormatTime, thedate, , dd/MM
    Gui, Show, , Track Log - %thedate%
    Keywait, Esc, D T5
    Gui, Destroy
Return
