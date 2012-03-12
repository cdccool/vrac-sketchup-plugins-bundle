=begin
#----------------------------------------------------------------------------------------------------------
#**********************************************************************************************************
# Copyright � 2011 Fredo6 - Designed and written February 2011 by Fredo6
#
# Permission to use this software for any purpose and without fee is hereby granted
# Distribution of this software for commercial purpose is subject to:
#  - the expressed, written consent of the author
#  - the inclusion of the present copyright notice in all copies.

# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#-----------------------------------------------------------------------------
# Name			:  Lib6_txtmsg.rb
# Original Date	:  21 feb 2011
# Type			:  Script library part of the LibFredo6 shared libraries
# Description	:  Central definition of texts and Messages for LibFredo6 package
#				   PLEASE DO NOT TRANSLATE THE STRINGS - Use the Translate utility of LibFredo6 instead
#----------------------------------------------------------------------------------------------------------
#**********************************************************************************************************
=end

module Traductor

#--------------------------------------------------------------------------------------------------------------
# Messages for Message box
#--------------------------------------------------------------------------------------------------------------

T6[:T_Yes] = "Yes"
T6[:T_No] = "No"

T6[:T_WARNING_File] = "WARNING: File generated by Program - Please do NOT edit manually"
T6[:T_WARNING_ActiveChange] = "WARNING: You have made some changes"
T6[:T_WARNING_WhatToDo] = "What do you want to do?"
T6[:T_ERROR_InvalidValue] = "There are invalid values:"
T6[:T_ERROR_NotGoodValue] = "Invalid values: %1"
T6[:T_ERROR_InVCB] = "ERROR in VCB"

#--------------------------------------------------------------------------------------------------------------
# Common Buttons
#--------------------------------------------------------------------------------------------------------------

T6[:T_BUTTON_Close] = "Close"	
T6[:T_BUTTON_Save] = "Save changes"	
T6[:T_BUTTON_Ignore] = "Drop changes"	
T6[:T_BUTTON_DecideLater] = "Decide later"	
T6[:T_BUTTON_GoBack] = "Back"	
T6[:T_BUTTON_Add] = "Add"	
T6[:T_BUTTON_Done] = "Done"	
T6[:T_BUTTON_Print] = "Print"	
T6[:T_BUTTON_ExportCSV] = "Export CSV"	
T6[:T_BUTTON_ExportTXT] = "Export TXT"	
T6[:T_BUTTON_Export] = "Export"	
T6[:T_BUTTON_Purge] = "Purge"	
T6[:T_BUTTON_Change] = "Change"	
T6[:T_BUTTON_ResetFactory] = "Reset Factory"	
T6[:T_BUTTON_OK] = "OK"	
T6[:T_BUTTON_Cancel] = "Cancel"	
T6[:T_BUTTON_New] = "New"	
T6[:T_BUTTON_SelectAll] = "Select All"	
T6[:T_BUTTON_UnSelectAll] = "Unselect All"	
T6[:T_BUTTON_ClearAll] = "Clear All"	
T6[:T_BUTTON_Delete] = "Delete"	
T6[:T_BUTTON_DeleteAll] = "Delete All"	
T6[:T_BUTTON_Select] = "Select"	
T6[:T_BUTTON_UnSelect] = "Unselect"	
T6[:T_BUTTON_Up] = "Move Up"	
T6[:T_BUTTON_Down] = "Move Down"	
T6[:T_BUTTON_Update] = "Update"
T6[:T_BUTTON_Visualize] = "View"
T6[:T_BUTTON_CheckForUpdate] = "Check Plugins for Update"

#--------------------------------------------------------------------------------------------------------------
# Translate Configuration
#--------------------------------------------------------------------------------------------------------------

T6[:T_BUTTON_AddNewLng] = "Add new language"	
T6[:T_STR_ConfirmChange] = "Confirm Changes?"
T6[:T_STR_PleaseConfirm] = "Please confirm?"
T6[:T_STR_NoteChange] = "Note: Some changes may only be effective when you restart Sketchup"
T6[:T_STR_Translation] = "Language Translation for Plugin"
T6[:T_STR_Changes] = "Modifications:"
T6[:T_STR_LeftTranslate] = "Left to translate:"
T6[:T_STR_ToBeTranslated] = "Translate into:"
T6[:T_STR_Additional] = "Show other languages:"
T6[:T_STR_SupportedLanguages] = "Language Maintenance"
T6[:T_STR_LgCode] = "Code"
T6[:T_STR_LgEnglish] = "English Name"
T6[:T_STR_LgNative] = "Native Name"
T6[:T_STR_Lg2Char] = "2-character ISO code"
T6[:T_STR_NewLanguage] = "New Language..."
T6[:T_STR_ObsoleteStrings] = "Obsolete Strings"
T6[:T_STR_PreferredLanguages] = "Preferred Language"
T6[:T_STR_None] = "[none]"
T6[:T_STR_NEVER] = "NEVER"
T6[:T_STR_PurgeUnused] = "Purge unused"
T6[:T_TTIP_PurgeUnused] = "Purge unused strings"
T6[:T_STR_DoYouWantOpenFile] = "Do you want to open the file?"
T6[:T_STR_PleaseWait] = "Please wait...."
T6[:T_STR_DefaultParamDialog] = "Default Parameters...."
T6[:T_STR_ExitTool] = "Exit Tool"

T6[:T_TIP_Find] = "Find text"
T6[:T_TIP_FindNext] = "Find text downward"
T6[:T_TIP_FindPrev] = "Find text upward"
T6[:T_TIP_Pin_On] = "Leave the dialog box open when executing command"
T6[:T_TIP_Pin_Off] = "Close the dialog box when executing command"

T6[:T_STR_TR_Rotation] = "Rotation"
T6[:T_STR_TR_Scaling] = "Scaling"
T6[:T_STR_TR_Translation] = "Translation"

#--------------------------------------------------------------------------------------------------------------
# Common Terms
#--------------------------------------------------------------------------------------------------------------

T6[:T_TXT_Distance] = "Distance"
T6[:T_TXT_Year] = "Year"
T6[:T_TXT_Month] = "Month"
T6[:T_TXT_Day] = "Day"
T6[:T_TXT_Days] = "Days"
T6[:T_TXT_Hour] = "Hour"
T6[:T_TXT_Hours] = "Hours"
T6[:T_TXT_Minute] = "Minute"
T6[:T_TXT_Minutes] = "Minutes"
T6[:T_TXT_Second] = "Second"
T6[:T_TXT_Seconds] = "Seconds"
T6[:T_TXT_Directory] = "Directory"
T6[:T_TXT_Plugin] = "Plugin"
T6[:T_TXT_Version] = "Version"
T6[:T_TXT_Time] = "Time"
T6[:T_TXT_Date] = "Date"
T6[:T_TXT_Author] = "Author"
T6[:T_TXT_Comment] = "Comment"
T6[:T_TXT_Required] = "Required"
T6[:T_TXT_Ago] = "%1 ago"
T6[:T_TXT_InFuture] = "in %1"
T6[:T_TXT_Tomorrow] = "Tomorrow"
T6[:T_TXT_Yesterday] = "Yesterday"
T6[:T_TXT_Anonymous] = "Anonymous"
T6[:T_TXT_UP_TO_DATE] = "UP TO DATE"
T6[:T_TXT_OBSOLETE] = "OBSOLETE"
T6[:T_TXT_All] = "All"
T6[:T_TXT_Error] = "Error"
T6[:T_TXT_Trace] = "Trace"
T6[:T_TXT_Area] = "Area"
T6[:T_TXT_Element] = "Element"
T6[:T_TXT_Units] = "Units"

T6[:T_TXT_Vertex] = "Vertex"
T6[:T_TXT_Vertices] = "Vertices"
T6[:T_TXT_Edge] = "Edge"
T6[:T_TXT_Edges] = "Edges"
T6[:T_TXT_EDGES] = "EDGES"
T6[:T_TXT_Face] = "Face"
T6[:T_TXT_Faces] = "Faces"
T6[:T_TXT_FACES] = "FACES"
T6[:T_TXT_Model] = "Model"
T6[:T_TXT_DefaultMaterial] = "Default Material"

T6[:T_TXT_Plugin] = "Plugin"
T6[:T_TXT_File] = "File"
T6[:T_TXT_Folder] = "Folder"
T6[:T_TXT_FileOrFolder] = "Plugin File or Folder"	
T6[:T_TXT_RootDirectory] = "Root directory"	

T6[:T_TXT_RubyFiles] = "Ruby"
T6[:T_TXT_Toolbar] = "Toolbar"
T6[:T_TXT_Icons] = "Icons"
T6[:T_TXT_Menus] = "Menus"
T6[:T_TXT_Total] = "Total"
T6[:T_TXT_GRANDTOTAL] = "GRAND TOTAL"

T6[:T_TXT_GROUP] = "GROUP"
T6[:T_TXT_COMP_INST] = "COMPONENT INSTANCE"
T6[:T_TXT_COMPONENT] = "COMPONENT"
T6[:T_TXT_MATERIAL] = "MATERIAL"
T6[:T_TXT_BACK_MATERIAL] = "BACK MATERIAL"	
T6[:T_TXT_LAYER] = "LAYER"	
T6[:T_TXT_Layer] = "Layer"	
T6[:T_TXT_CurrentSelection] = "Current Selection"
T6[:T_TXT_WholeModel] = "Whole Model"

T6[:T_TXT_NO_Decimal] = "NO Decimal"
T6[:T_TXT_Decimal] = "Decimal"
T6[:T_TXT_Decimals] = "Decimals"

end #Module Traductor

