%REM
    Agent openagent
    Created Sep 9, 2013 by Nathan Hilbert/DAI
    Description: Comments for Agent
%END REM
Option Public
Option Declare
Option Base 1



Dim db As NotesDatabase
Dim doc As NotesDocument
Dim s As NotesSession
Dim tmpName As NotesName
Dim userView As NotesView
Dim userDoc As NotesDocument
Dim grantsView As NotesView
Dim grantsDoc As NotesDocument

'Other variables
Dim i As Integer

Const amp = |&|
Const BR = |<br />|
Const comma = |,|
Const errorStr = |ERROR: |
Const quoteStr = |"|

Const jsonStart = |{|
Const jsonEnd = |}|

Const featureCollectionStart = |{ "type": "FeatureCollection",|
Const featureCollectionEnd = |}|


Const featuresStart = |"features": [|
Const featuresEnd = |]|

Const featureTypeStart = |{ "type": "Feature",|
Const featureTypeEnd = |}|

Const arrayStart = "["
Const arrayEnd = "]"
Dim jsonText As String






%REM
    Sub Initialize
    Description: Comments for Sub
%END REM
Sub Initialize()
    'Print out this line to force Domino to not write it"s own 
    'HTML gunk at the beginning of the resulting page

    Dim cmdName As String
    Dim queryStr As String
    Dim servicesStr As String  
    Dim tmpStr As String
    Dim tmpInt As Integer

    'Initialize our Notes session object
    Set s = New NotesSession
    'Then get a handle to the current database
    Set db = s.CurrentDatabase
    'Get a handle to the agent"s context (header variables and so on)
    Set doc = s.DocumentContext 


    'Parse the command line and call the correct function
    queryStr = doc.Query_String_Decoded(0) & amp
    'cmdName = GetCmdLineValue(queryStr, "&cmd=", amp)
    servicesStr = ||
    Print |content-type: text/html;|
    GetGeoJSONList(servicesStr)


End Sub


Function getTimeStamp(dt As Variant) As Long
    Dim dtEpoch As New NotesDateTime("1/1/1970 00:00:00")
    Dim dtTemp As New NotesDateTime(dt & | 00:00:00|)
    Dim temper As Long
    temper = dtTemp.TimeDifference(dtEpoch)
    getTimeStamp = temper

End Function




Sub GetGeoJSONList(servicesStr As String)



    jsonText = |[|
    
    Dim isfirst As Integer
    isfirst = 1

    'doing stuff here if done set counter to 10000
    'Local Notes objects
    Dim ve As NotesViewEntry
    Dim vec As NotesViewEntryCollection
    
    'Other variables
    Dim numGrants As Integer
    Dim sectorcode As String
    sectorcode = "GISData_Act"
    
    
    Dim lat As String
    Dim lon As String

    
    Set grantsView = db.GetView(sectorcode)
    If Not grantsView Is Nothing Then
        'Do we have a search string?
        'If Len(Trim(searchStr)) > 0 Then
        '   'See if we can find any users by the search string
        '   Set vec = grantsView.GetAllEntriesByKey(searchStr)
        'Else
        'Otherwise get all documents
        Set vec = grantsView.AllEntries
        'End If
        'Now, if we have any entries - put them into the array
        If vec.Count > 0 Then
            'Get the number of contacts to use throughout the rest of the code
            numGrants = vec.Count
            'Start the Array JSON text
            
            'Process all of the entries in the View Entry Collection
            For i = 1 To numGrants
                Set ve = vec.GetNthEntry(i)
                If Not ve Is Nothing Then
                    Set grantsDoc = ve.Document
                    If Not grantsDoc Is Nothing Then
                        
                        If isfirst = 1 Then
                            jsonText = jsonText & |{|
                            isfirst = 2
                        Else
                            jsonText = jsontext & |,{|
                        End If
                        
                        If Not Len(grantsDoc.Latitude(0)) <2 Then

                            lat = grantsDoc.Latitude(0)
                            
                        Else
                            
                            lat = "0"
                        End If
                        
                        If Not Len(grantsDoc.Longitude(0)) <2 Then
                            
                            lon = grantsDoc.Longitude(0)
                        Else
                            lon = "0"
                        End If
                        
                        
                        jsonText = jsonText & |"Activity_No":"| & grantsDoc.Activity_No(0) & |",| _ 
                        & |"Status":"| & grantsDoc.Status(0) & |",| _ 
                        & |"Sub_Component":"| & grantsDoc.Sub_Component(0) & |",| _ 
                        & |"Activity_Title":"| & LSescape(grantsDoc.Activity_Title(0)) & |",| _ 
                        & |"Award_Amount":"| & grantsDoc.Award_Amount(0) & |",| _ 
                        & |"Start_Date_Current":"| & grantsDoc.Start_Date_Current(0) & |",| _ 
                        & |"End_Date_Current":"| & grantsDoc.End_Date_Current(0) & |",| _ 
                        & |"Atype":"| & grantsDoc.AType(0) & |",| _ 
                        & |"Crosscutting":"| & grantsDoc.Crosscutting(0) & |",| _ 
                        & |"Latitude":| & lat & |,| _ 
                        & | "Longitude":| & lon & |,| _ 
                        & |"Dist_Name":"| & grantsDoc.Dist_Name(0) & |",| _ 
                        & |"DataType":"Activities"}|
                        

                    End If
                End If
            Next i
            'Write our resulting JSON results to the browser
            
            
        End If
    End If
    
    

    sectorcode = "GISData_Grant"
    

    
    Set grantsView = db.GetView(sectorcode)
    If Not grantsView Is Nothing Then
        'Do we have a search string?
        'If Len(Trim(searchStr)) > 0 Then
        '   'See if we can find any users by the search string
        '   Set vec = grantsView.GetAllEntriesByKey(searchStr)
        'Else
        'Otherwise get all documents
        Set vec = grantsView.AllEntries
        'End If
        'Now, if we have any entries - put them into the array
        If vec.Count > 0 Then
            'Get the number of contacts to use throughout the rest of the code
            numGrants = vec.Count
            'Start the Array JSON text
            
            'Process all of the entries in the View Entry Collection
            For i = 1 To numGrants
                Set ve = vec.GetNthEntry(i)
                If Not ve Is Nothing Then
                    Set grantsDoc = ve.Document
                    If Not grantsDoc Is Nothing Then
                        If isfirst = 1 Then
                            jsonText = jsonText & |{|
                            isfirst = 2
                        Else
                            jsonText = jsontext & |,{|
                        End If

                        
                        If Len(grantsDoc.Latitude(0)) <2 Then
                            lat = "0"
                        Else
                            lat = grantsDoc.Latitude(0)
                        End If
                        
                        If Len(grantsDoc.Longitude(0)) <2 Then
                            lon = "0"
                        Else
                            lon = grantsDoc.Longitude(0)
                        End If
                        
                        
                        jsonText = jsonText & |"Activity_No":"| & grantsDoc.Grant_No(0) & |",| _ 
                        & |"Status":"| & grantsDoc.Status(0) & |",| _ 
                        & |"Sub_Component":"| & grantsDoc.Sub_Component(0) & |",| _ 
                        & |"Activity_Title":"| & LSescape(grantsDoc.Grant_Title(0)) & |",| _ 
                        & |"Award_Amount":"| & grantsDoc.Award_Amount(0) & |",| _ 
                        & |"Start_Date_Current":"| & grantsDoc.Start_Date_Current(0) & |",| _ 
                        & |"End_Date_Current":"| & grantsDoc.End_Date_Current(0) & |",| _ 
                        & |"Atype":"| & grantsDoc.GType(0) & |",| _ 
                        & |"Crosscutting":"| & grantsDoc.Crosscutting(0) & |",| _ 
                        & |"Latitude":| & lat & |,| _ 
                        & | "Longitude":| & lon & |,| _ 
                        & |"Dist_Name":"| & grantsDoc.Dist_Name(0) & |",| _ 
                        & |"DataType":"Grants"}|

                    End If
                End If
            Next i
            'Write our resulting JSON results to the browser
            
            
        End If
    End If


    Print jsonText & |]|
    



End Sub
Function LSescape(strIn As String) As String
'
' This function performs the equivalent of a JavaScript escape.
' Kenneth H?man, TJ Group AB.
'
Dim strAllowed As String
Dim i As Integer
Dim strChar As String
Dim strReturn As String

'These are the characters that the JavaScript escape-function allows, so we let them pass
'unchanged in this function as well.
strAllowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 " & "@/.*-_"
i = 1
strReturn = ""

While Not (i > Len(strIn))
strChar = Mid$(strIn, i, 1)
If InStr(1, strAllowed, strChar) > 0 Then
strReturn = strReturn & strChar
Else
strReturn = strReturn & "%" & Hex$(Asc(strChar))
End If
i = i + 1
Wend

LSescape = strReturn

End Function