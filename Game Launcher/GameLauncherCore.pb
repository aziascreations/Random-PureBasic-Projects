Global WebViewUrl.s = "127.0.0.1" ;Put the url of the WebView Gadget here.
Global isWebViewHidden.b = 0 ;0-Show the gadget / 1-Hide the gadget
Global isImageHidden.b = 1 ;0-Show the gadget / 1-Hide the gadget

Global regMainFolder.s = "Azias";
Global regSubFolder.s = "GameLauncher";
Global installFolder.s = "C:\Games\Testing\";

XIncludeFile "GameLauncherFormMain.pbf"
XIncludeFile "GameLauncherFormOptions.pbf"
XIncludeFile "GameLauncherFormError.pbf"

OpenWindow_Launcher_Main()

Procedure Button_OpenOptionsEvent(Event)
  OpenWindow_Launcher_Options()
  ;CloseWindow(#Window_MD5About)
EndProcedure

Procedure Button_DebugTestEvent(Event)
  Debug "hi"
EndProcedure

Procedure Button_OptionsEvent(Event)
  OpenWindow_Launcher_Options()
EndProcedure

Procedure Button_PlayEvent(Event)
  Debug "hi"
EndProcedure

Procedure Button_OpenGameDirEvent(Event)
  RunProgram(installFolder)
EndProcedure

Procedure Button_ChangeGameDirEvent(Event)
  
EndProcedure

Procedure Button_OptionsCancelEvent(Event)
    CloseWindow(Window_Launcher_Options)
EndProcedure

Procedure Button_OptionsSaveEvent(Event)
  
EndProcedure

Procedure.s ReadRegKey(OpenKey.l,SubKey.s,ValueName.s)
  hKey.l=0
  keyvalue.s= Space (255)
  DataSize.l=255
  
  If RegOpenKeyEx_ (OpenKey,SubKey,0, #KEY_READ ,@hKey)
    
  Else
    If RegQueryValueEx_ (hKey,ValueName,0,0,@keyvalue,@DataSize)
     keyvalue= ""
    Else
      keyvalue= Left (keyvalue,DataSize-1)
    EndIf
    RegCloseKey_ (hKey)
  EndIf
  ProcedureReturn keyvalue
EndProcedure

Procedure.l WriteRegKey(OpenKey.l,SubKey.s,keyset.s,keyvalue.s)
  hKey.l=0
  If RegCreateKey_ (OpenKey,SubKey,@hKey)=0
    Result=1
    DataSize.l= Len (keyvalue)
    If RegSetValueEx_ (hKey,keyset,0, #REG_SZ ,@keyvalue,DataSize)=0
      Result=2
    EndIf
    RegCloseKey_ (hKey)
  EndIf
  ProcedureReturn Result
  ;returns 0 if error / could not open or create SubKey
  ;returns 1 if error / could not write new value
  ;returns 2 if success
EndProcedure

Procedure.l WritebinaryRegKey(OpenKey.l,SubKey.s,keyset.s,keyvalue.l)
  hKey.l=0
  If RegCreateKey_ (OpenKey,SubKey,@hKey)=0
    Result=1
    DataSize.l=4 ;number of octets written
    If RegSetValueEx_ (hKey,keyset,0, #REG_BINARY ,@keyvalue,DataSize)=0
      Result=2
    EndIf
    RegCloseKey_ (hKey)
  EndIf
  ProcedureReturn Result
  ;returns 0 if error / could not open or create SubKey
  ;returns 1 if error / could not write new value
  ;returns 2 if success
EndProcedure

;installFolder = ReadRegKey(#HKEY_LOCAL_MACHINE,"SOFTWARE\"+regMainFolder+"\"+regSubFolder,"InstallDirectory")
;Debug installFolder

;Plante si le dossier n'a pas été trouvé et puis crée !
CheckFolder:
Select FileSize(installFolder)
  Case -1
    ;Debug "Info: Folder not found"
    If CreateDirectory(installFolder) = 0
      ;Debug "Error: Unable to create directory"
    Else
      ;Debug "Info: Folder created"
      Goto CheckFolder
    EndIf
  Case -2
    ;Debug "Info: Folder found"
EndSelect

Repeat
  Event = WaitWindowEvent()
  isMainClosed.b = 0
  isOptionsClosed.b = 0
  isErrorClosed.b = 0
  
  Select EventWindow()
    Case Window_Launcher_Main
      If #False = Window_Launcher_Main_Events(Event)
        isMainClosed=1
      EndIf
    Case Window_Launcher_Options
      If #False = Window_Launcher_Options_Events(Event)
        isOptionsClosed=1
      EndIf
    Case Window_Launcher_Error
      If #False = Window_Launcher_Error_Events(Event)
        isErrorClosed=1
      EndIf
    Default
      Window_Launcher_Main_Events(Event)
  EndSelect
  
  If isOptionsClosed = 1
    CloseWindow(Window_Launcher_Options)
  EndIf
  If isErrorClosed = 1
    CloseWindow(Window_Launcher_Error)
  EndIf
Until isMainClosed = 1
; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 33
; Folding = --
; EnableUnicode
; EnableXP