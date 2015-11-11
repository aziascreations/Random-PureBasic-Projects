Global isMainClosed.b
Global isItemsClosed.b
isMainClosed.b = 0

XIncludeFile "MJGLang.pb"

XIncludeFile "MJGFormMain.pbf"
XIncludeFile "MJGFormItems.pbf"
XIncludeFile "MJGFormAbout.pbf"
OpenWindow_MJG_Main()

Procedure MenuItem_ExitEvent(Event)
  isMainClosed = 1
EndProcedure

Procedure MenuItem_OpenOutputEvent(Event)
  RunProgram(".\")
EndProcedure

Procedure MenuItem_AboutEvent(Event)
  OpenWindow_MJG_About()
EndProcedure

;Items Window Procedures
Procedure Button_OpenItemsEvent(Event)
  OpenWindow_MJG_Items()
EndProcedure

Procedure Checkbox_Items_AddCommentEvent(Event)
  If GetGadgetState(Checkbox_Items_AddComment) = #PB_Checkbox_Checked
    DisableGadget(String_Items_Comment,0)
  Else
    DisableGadget(String_Items_Comment,1)
  EndIf
EndProcedure

Procedure Button_Items_GenerateEvent(Event)
  ;This is a temporary solution as PB Json Library don't generate the code as expected.
  ItemJson.s = "{"+Chr(34)+"parent"+Chr(34)+":"+Chr(34)+GetGadgetText(String_Items_Parent)+Chr(34)+","+Chr(34)+"textures"+Chr(34)+":{"+Chr(34)+"layer0"+Chr(34)+":"+Chr(34)+GetGadgetText(String_Items_ModID)+":items/"+GetGadgetText(String_Items_ItemName)
  
  itemJson = ItemJson+Chr(34)+"}}"
  
  #JSON_Parse = 0
  If ParseJSON(#JSON_Parse, ItemJson)
    Debug ComposeJSON(#JSON_Parse, #PB_JSON_PrettyPrint)
  EndIf
  
  ;Debug ItemJson
EndProcedure

Procedure Button_Items_ResetEvent(Event)
  SetGadgetText(String_Items_ModID,"")
  SetGadgetText(String_Items_ItemName,"")
  SetGadgetText(String_Items_TextureName,"")
  SetGadgetText(String_Items_Parent,"builtin/generated")
  SetGadgetState(Checkbox_Items_IncludeDisplay,#PB_Checkbox_Checked)
  SetGadgetState(Checkbox_Items_EnableMeta,#PB_Checkbox_Unchecked)
  
EndProcedure

Procedure Button_Items_CloseEvent(Event)
  CloseWindow(Window_MJG_Items)
EndProcedure

Repeat
  Event = WaitWindowEvent()
  
  Select EventWindow()
    Case Window_MJG_Main
      If #False = Window_MJG_Main_Events(Event)
        isMainClosed=1
      EndIf
    Case Window_MJG_Items
      If #False = Window_MJG_Items_Events(Event)
        ;isItemsClosed=1
        CloseWindow(Window_MJG_Items)
      EndIf
    Case Window_MJG_About
      If #False = Window_MJG_About_Events(Event)
        CloseWindow(Window_MJG_About)
      EndIf
    Default
      Window_MJG_Main_Events(Event)
  EndSelect
Until isMainClosed = 1
; IDE Options = PureBasic 5.30 (Windows - x64)
; CursorPosition = 5
; Folding = --
; EnableUnicode
; EnableXP