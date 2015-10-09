#gnChunkSize = 1024 * 32
Define.s MD5_0, MD5_1
MD5_0 = ""
MD5_1 = ""

Procedure.s iMD5FileFingerprint(cFile.s)
  StatusBarText(0,0,"Processing your file.")
  Protected cHash.s, nBytes, hFile, *pDataChunk, hMD5
  
  hFile = ReadFile(#PB_Any, cFile, #PB_File_SharedRead)
  If hfile
    *pDataChunk = AllocateMemory(#gnChunkSize)
    If *pDataChunk
      hMD5 = ExamineMD5Fingerprint(#PB_Any)
      If hMD5
        While Not Eof(hFile)
          ; You could update a progress bar...
          nBytes = ReadData(hFile, *pDataChunk, #gnChunkSize)
          NextFingerprint(hMD5, *pDataChunk, nBytes)
        Wend
        cHash = FinishFingerprint(hMD5)
        StatusBarText(0,0,"File processed correctly.")
      Else
        Debug "Failed to init md5"
        StatusBarText(0,0,"Failed to init md5")
      EndIf
      FreeMemory(*pDataChunk)
    Else
      Debug "Failed to allocate "+Str(#gnChunkSize)+" bytes of memory"
      StatusBarText(0,0,"Failed to allocate "+Str(#gnChunkSize)+" bytes of memory")
    EndIf
    CloseFile(hFile)
  Else
    Debug "Failed to open file"
    StatusBarText(0,0,"Failed to open file")
  EndIf
  
  ProcedureReturn cHash
  
EndProcedure

XIncludeFile "MD5Checker_FormMain.pbf"
XIncludeFile "MD5Checker_FormAbout.pbf"

Procedure Button_SelectFileEvent(Event)
  ;If OpenFile(FileMD5_0, OpenFileRequester("Choose a File File", "","All files (*.*)|*.*", 0))
  StatusBarText(0,0,"Select a file.")
  TempMD5.s = iMD5FileFingerprint(OpenFileRequester("Choose a File File", "","All files (*.*)|*.*", 0))
    ;TempMD5.s = iMD5FileFingerprint(FileMD5_0)
    ;Debug FileMD5_0
  SetGadgetText(String_FileName_0, "[Insert File's Path Here]")
  SetGadgetText(String_MD5_0_Upper, UCase(TempMD5))
  SetGadgetText(String_MD5_0_Lower, LCase(TempMD5))
  ;EndIf
EndProcedure

Procedure MenuItem_AboutEvent(Event)
  OpenWindow_MD5About()
EndProcedure

Procedure Button_CloseAboutEvent(Event)
  ;Debug "Hi"
  CloseWindow(#Window_MD5About)
EndProcedure

Procedure Button_CheckMD5Event(Event)
  SetGadgetText(String_MD5_1_Upper, UCase(GetClipboardText()))
  SetGadgetText(String_MD5_1_Lower, LCase(GetClipboardText()))
  If GetGadgetText(String_MD5_0_Lower) = GetGadgetText(String_MD5_1_Lower)
    StatusBarText(0,0,"The MD5 hashes are the same.")
  Else
    StatusBarText(0,0,"The MD5 hashes aren't the same.")
  EndIf
EndProcedure

Procedure Button_CopyFileMD5Event(Event)
  SetClipboardText(GetGadgetText(String_MD5_0_Lower))
  StatusBarText(0,0,"Your file's MD5 hash has been copied into the clipboard.")
EndProcedure

OpenWindow_MD5Main()

Repeat
  Event = WaitWindowEvent()
  isClosed.b = 0
  
  Select EventWindow()
    Case MainWindow
      If #False = Window_MD5Main_Events(Event)
        isClosed=1
      EndIf
      
    Default
      Window_MD5About_Events(Event)
  EndSelect
  
Until isClosed = 1

; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 21
; Folding = --
; EnableUnicode
; EnableXP