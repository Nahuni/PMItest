Attribute VB_Name = "modCustomScripts"
Public Sub CustomScript(index As Long, caseID As Long)
    Select Case caseID
        
                Case 1
                        Msg = "*Is looking for a challenger at the arena! if you think you are man enough, go fight them!"

                        Call AddLog("Map #" & GetPlayerMap(index) & ": " & GetPlayerName(index) & " " & Msg, PLAYER_LOG)
                        Call MapMsg(GetPlayerMap(index), GetPlayerName(index) & " " & Right$(Msg, Len(Msg) - 1), BrightRed)
                
                Case 2
                        Msg = "AHas fled the Arena! If he has claimed victory, than our praise be to you! If you are running away, you have brought us shame."

                        Call AddLog("Map #" & GetPlayerMap(index) & ": " & GetPlayerName(index) & " " & Msg, PLAYER_LOG)
                        Call MapMsg(GetPlayerMap(index), GetPlayerName(index) & " " & Right$(Msg, Len(Msg) - 1), BrightRed)
                                
                Case 3
                        Msg = "AIs looking for a good time at the Pink Carrot! Go hang out with them and have some fun!"

                        Call AddLog("Map #" & GetPlayerMap(index) & ": " & GetPlayerName(index) & " " & Msg, PLAYER_LOG)
                        Call MapMsg(GetPlayerMap(index), GetPlayerName(index) & " " & Right$(Msg, Len(Msg) - 1), EmoteColor)
                        
        Case Else
            PlayerMsg index, "You just activated custom script " & caseID & ". This script is not yet programmed.", BrightRed
    End Select
End Sub
