; ticker - A Simple Time Tracker
; track your time usage on a daily basis

#InstallKeybdHook
#InstallMouseHook
Menu, Tray, Icon, %A_WinDir%\system32\shell32.dll, 44
Menu, Tray, Tip, ticker - A Simple Time Tracker`nPress right control to see details

SetWorkingDir, C:\Users\%A_UserName%\Documents
SetTimer, CheckTime, 60000 ; updates every 1 minute

CheckTime:
    FormatTime, thedate, , dd-MM-yyyy

    IniRead, ResearchTime,    track.txt, %thedate%, research,    0
    IniRead, ProgrammingTime, track.txt, %thedate%, programming, 0
    IniRead, SurfingTime,     track.txt, %thedate%, surfing,     0
    IniRead, WastedTime,      track.txt, %thedate%, waste,       0
    IniRead, IdleTime,        track.txt, %thedate%, idle,        0

    If (A_TimeIdlePhysical < 600000) ; 10 minutes
    {
        If (WinActive("ahk_class classFoxitReader") or WinActive("ahk_class AcrobatSDIWindow")) 
            ResearchTime++
        Else If (WinActive("ahk_class Vim") or WinActive("ahk_class Notepad2U"))
            ProgrammingTime++
        Else If (WinActive("ahk_class MozillaWindowClass") or WinActive("ahk_class Chrome_WidgetWin_1"))
            SurfingTime++
        Else
            WastedTime++
    }
    Else
        IdleTime++
    
    TotalTime := ResearchTime + ProgrammingTime + SurfingTime + WastedTime + IdleTime

    IniWrite, %ResearchTime%,    track.txt, %thedate%, research
    IniWrite, %ProgrammingTime%, track.txt, %thedate%, programming
    IniWrite, %SurfingTime%,     track.txt, %thedate%, surfing
    IniWrite, %WastedTime% ,     track.txt, %thedate%, waste
    IniWrite, %IdleTime% ,       track.txt, %thedate%, idle
    IniWrite, %TotalTime% ,      track.txt, %thedate%, total

Return

FormatMinutes(NumberOfMinutes)  ; Convert mins to hh:mm
{
    Time := 19990101 ; *Midnight* of an arbitrary date
    Time += %NumberOfMinutes%, minutes
    FormatTime, HHmm, %Time%, HH '小时' mm '分钟'
    Return HHmm
}

rctrl::
    Gui, Font, s10, Microsoft YaHei
    Gui, Add, Text, w150 Left, % "科研：`t"    FormatMinutes(ResearchTime)
                               . "`n编程：`t"  FormatMinutes(ProgrammingTime)
                               . "`n上网：`t"  FormatMinutes(SurfingTime)
                               . "`n浪费：`t"  FormatMinutes(WastedTime)
                               . "`n空闲：`t"  FormatMinutes(IdleTime)
                               . "`n总计：`t"  FormatMinutes(TotalTime)
    Gui, -SysMenu
    FormatTime, thedate, , yyyy/MM/dd
    Gui, Show, , Track Log - %thedate%
    Keywait, Esc, D T5
    Gui, Destroy
Return
