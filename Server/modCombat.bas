Attribute VB_Name = "modCombat"
Option Explicit

' ################################
' ##      Basic Calculations    ##
' ################################
Dim i As Long
Function GetPlayerMaxVital(ByVal index As Long, ByVal Vital As Vitals) As Long
    If index > MAX_PLAYERS Then Exit Function
    Select Case Vital
        Case HP
            Select Case GetPlayerClass(index)
                Case 1 ' Warrior
                    GetPlayerMaxVital = ((GetPlayerLevel(index) / 2) + (GetPlayerStat(index, Endurance) / 2)) * 15 + 150
                Case 2 ' Mage
                    GetPlayerMaxVital = ((GetPlayerLevel(index) / 2) + (GetPlayerStat(index, Endurance) / 2)) * 5 + 65
                Case Else ' Anything else - Warrior by default
                    GetPlayerMaxVital = ((GetPlayerLevel(index) / 2) + (GetPlayerStat(index, Endurance) / 2)) * 15 + 150
            End Select
        For i = 1 To 10
                If TempPlayer(index).Buffs(i) = BUFF_ADD_HP Then
                    GetPlayerMaxVital = GetPlayerMaxVital + TempPlayer(index).BuffValue(i)

                End If
                If TempPlayer(index).Buffs(i) = BUFF_SUB_HP Then
                    GetPlayerMaxVital = GetPlayerMaxVital - TempPlayer(index).BuffValue(i)
                End If
            Next
        Case MP
            Select Case GetPlayerClass(index)
                Case 1 ' Warrior
                    GetPlayerMaxVital = ((GetPlayerLevel(index) / 2) + (GetPlayerStat(index, Intelligence) / 2)) * 5 + 25
                Case 2 ' Mage
                    GetPlayerMaxVital = ((GetPlayerLevel(index) / 2) + (GetPlayerStat(index, Intelligence) / 2)) * 30 + 85
                Case Else ' Anything else - Warrior by default
                    GetPlayerMaxVital = ((GetPlayerLevel(index) / 2) + (GetPlayerStat(index, Intelligence) / 2)) * 5 + 25
            End Select
    For i = 1 To 10
                If TempPlayer(index).Buffs(i) = BUFF_ADD_MP Then
                    GetPlayerMaxVital = GetPlayerMaxVital + TempPlayer(index).BuffValue(i)
                End If
                If TempPlayer(index).Buffs(i) = BUFF_SUB_MP Then
                    GetPlayerMaxVital = GetPlayerMaxVital - TempPlayer(index).BuffValue(i)
                End If
            Next
    End Select
End Function
Function GetPlayerVitalRegen(ByVal index As Long, ByVal Vital As Vitals) As Long
    Dim i As Long

    ' Prevent subscript out of range
    If IsPlaying(index) = False Or index <= 0 Or index > MAX_PLAYERS Then
        GetPlayerVitalRegen = 0
        Exit Function
    End If

    Select Case Vital
        Case HP
            i = (GetPlayerStat(index, Stats.Willpower) * 0.8) + 6
        Case MP
            i = (GetPlayerStat(index, Stats.Willpower) / 4) + 12.5
    End Select

    If i < 2 Then i = 2
    GetPlayerVitalRegen = i
End Function
Function GetPlayerDamage(ByVal index As Long) As Long
    Dim i As Long
    Dim weaponNum As Long
    
    GetPlayerDamage = 0

    ' Check for subscript out of range
    If IsPlaying(index) = False Or index <= 0 Or index > MAX_PLAYERS Then
        Exit Function
    End If
    If GetPlayerEquipment(index, Weapon) > 0 Then
        weaponNum = GetPlayerEquipment(index, Weapon)
        GetPlayerDamage = 0.085 * 5 * GetPlayerStat(index, Strength) * Item(weaponNum).Data2 + (GetPlayerLevel(index) / 5)
    Else
        GetPlayerDamage = 0.085 * 5 * GetPlayerStat(index, Strength) + (GetPlayerLevel(index) / 5)
    End If
For i = 1 To 10
        If TempPlayer(index).Buffs(i) = BUFF_ADD_ATK Then
            GetPlayerDamage = GetPlayerDamage + TempPlayer(index).BuffValue(i)
        End If
        If TempPlayer(index).Buffs(i) = BUFF_SUB_ATK Then
            GetPlayerDamage = GetPlayerDamage - TempPlayer(index).BuffValue(i)
        End If
    Next
End Function
Function GetPlayerDef(ByVal index As Long) As Long
    Dim i As Long
    Dim DefNum As Long
    Dim Def As Long
    
    GetPlayerDef = 0
    Def = 0
    ' Check for subscript out of range
    If IsPlaying(index) = False Or index <= 0 Or index > MAX_PLAYERS Then
        Exit Function
    End If
    
    
    If GetPlayerEquipment(index, Armor) > 0 Then
        DefNum = GetPlayerEquipment(index, Armor)
        Def = Def + Item(DefNum).Data2
    End If
    
    If GetPlayerEquipment(index, Helmet) > 0 Then
        DefNum = GetPlayerEquipment(index, Helmet)
        Def = Def + Item(DefNum).Data2
    End If
    
    If GetPlayerEquipment(index, Shield) > 0 Then
        DefNum = GetPlayerEquipment(index, Shield)
        Def = Def + Item(DefNum).Data2
    End If
    
   If Not GetPlayerEquipment(index, Armor) > 0 And Not GetPlayerEquipment(index, Helmet) > 0 And Not GetPlayerEquipment(index, Shield) > 0 Then
        GetPlayerDef = 0.085 * GetPlayerStat(index, Endurance) + (GetPlayerLevel(index) / 5)
    Else
        GetPlayerDef = 0.085 * GetPlayerStat(index, Endurance) * Def + (GetPlayerLevel(index) / 5)
    End If
 For i = 1 To 10
        If TempPlayer(index).Buffs(i) = BUFF_ADD_DEF Then
            GetPlayerDef = GetPlayerDef + TempPlayer(index).BuffValue(i)
        End If
        If TempPlayer(index).Buffs(i) = BUFF_SUB_DEF Then
            GetPlayerDef = GetPlayerDef - TempPlayer(index).BuffValue(i)
        End If
    Next
End Function

Function GetNpcMaxVital(ByVal npcNum As Long, ByVal Vital As Vitals) As Long
    Dim x As Long

    ' Prevent subscript out of range
    If npcNum <= 0 Or npcNum > MAX_NPCS Then
        GetNpcMaxVital = 0
        Exit Function
    End If

    Select Case Vital
        Case HP
            GetNpcMaxVital = Npc(npcNum).HP
        Case MP
            GetNpcMaxVital = 30 + (Npc(npcNum).stat(Intelligence) * 10) + 2
    End Select

End Function

Function GetNpcVitalRegen(ByVal npcNum As Long, ByVal Vital As Vitals) As Long
    Dim i As Long

    'Prevent subscript out of range
    If npcNum <= 0 Or npcNum > MAX_NPCS Then
        GetNpcVitalRegen = 0
        Exit Function
    End If

    Select Case Vital
        Case HP
            i = (Npc(npcNum).stat(Stats.Willpower) * 0.8) + 6
        Case MP
            i = (Npc(npcNum).stat(Stats.Willpower) / 4) + 12.5
    End Select
    
    GetNpcVitalRegen = i

End Function

Function GetNpcDamage(ByVal npcNum As Long) As Long
    GetNpcDamage = 0.085 * 5 * Npc(npcNum).stat(Stats.Strength) * Npc(npcNum).Damage + (Npc(npcNum).Level / 5)
End Function

' ###############################
' ##      Luck-based rates     ##
' ###############################

Public Function CanPlayerBlock(ByVal index As Long) As Boolean
Dim rate As Long
Dim rndNum As Long

    CanPlayerBlock = False

    rate = 0
    ' TODO : make it based on shield lulz
End Function

Public Function CanPlayerCrit(ByVal index As Long) As Boolean
Dim rate As Long
Dim rndNum As Long

    CanPlayerCrit = False

    rate = GetPlayerStat(index, Agility) / 52.08
    rndNum = rand(1, 100)
    If rndNum <= rate Then
        CanPlayerCrit = True
    End If
End Function

Public Function CanPlayerDodge(ByVal index As Long) As Boolean
Dim rate As Long
Dim rndNum As Long

    CanPlayerDodge = False

    rate = GetPlayerStat(index, Agility) / 83.3
    rndNum = rand(1, 100)
    If rndNum <= rate Then
        CanPlayerDodge = True
    End If
End Function

Public Function CanPlayerParry(ByVal index As Long) As Boolean
Dim rate As Long
Dim rndNum As Long

    CanPlayerParry = False

    rate = GetPlayerStat(index, Strength) * 0.25
    rndNum = rand(1, 100)
    If rndNum <= rate Then
        CanPlayerParry = True
    End If
End Function

Public Function CanNpcBlock(ByVal npcNum As Long) As Boolean
Dim rate As Long
Dim stat As Long
Dim rndNum As Long

    CanNpcBlock = False
    
    stat = Npc(npcNum).stat(Stats.Agility) / 5  'guessed shield agility
    rate = stat / 12.08
    
    rndNum = rand(1, 100)
    
    If rndNum <= rate Then
        CanNpcBlock = True
    End If
    
End Function

Public Function CanNpcCrit(ByVal npcNum As Long) As Boolean
Dim rate As Long
Dim rndNum As Long

    CanNpcCrit = False

    rate = Npc(npcNum).stat(Stats.Agility) / 52.08
    rndNum = rand(1, 100)
    If rndNum <= rate Then
        CanNpcCrit = True
    End If
End Function

Public Function CanNpcDodge(ByVal npcNum As Long) As Boolean
Dim rate As Long
Dim rndNum As Long

    CanNpcDodge = False

    rate = Npc(npcNum).stat(Stats.Agility) / 83.3
    rndNum = rand(1, 100)
    If rndNum <= rate Then
        CanNpcDodge = True
    End If
End Function

Public Function CanNpcParry(ByVal npcNum As Long) As Boolean
Dim rate As Long
Dim rndNum As Long

    CanNpcParry = False

    rate = Npc(npcNum).stat(Stats.Strength) * 0.25
    rndNum = rand(1, 100)
    If rndNum <= rate Then
        CanNpcParry = True
    End If
End Function

' ###################################
' ##      Player Attacking NPC     ##
' ###################################

Public Sub TryPlayerAttackNpc(ByVal index As Long, ByVal mapNpcNum As Long)
Dim blockAmount As Long
Dim npcNum As Long
Dim mapnum As Long
Dim Damage As Long

    Damage = 0

    ' Can we attack the npc?
    If CanPlayerAttackNpc(index, mapNpcNum) Then
    
        mapnum = GetPlayerMap(index)
        npcNum = MapNpc(mapnum).Npc(mapNpcNum).Num
    
        ' check if NPC can avoid the attack
        If CanNpcDodge(npcNum) Then
            SendActionMsg mapnum, "Dodge!", Pink, 1, (MapNpc(mapnum).Npc(mapNpcNum).x * 32), (MapNpc(mapnum).Npc(mapNpcNum).y * 32)
            Exit Sub
        End If
        If CanNpcParry(npcNum) Then
            SendActionMsg mapnum, "Parry!", Pink, 1, (MapNpc(mapnum).Npc(mapNpcNum).x * 32), (MapNpc(mapnum).Npc(mapNpcNum).y * 32)
            Exit Sub
        End If

        ' Get the damage we can do
        Damage = GetPlayerDamage(index)
        
        ' if the npc blocks, take away the block amount
        blockAmount = CanNpcBlock(mapNpcNum)
        Damage = Damage - blockAmount
        
        ' take away armour
        Damage = Damage - rand(1, (Npc(npcNum).stat(Stats.Agility) * 2))
        ' randomise from 1 to max hit
        Damage = rand(1, Damage)
        
        ' * 1.5 if it's a crit!
        If CanPlayerCrit(index) Then
            Damage = Damage * 1.5
            SendActionMsg mapnum, "Critical!", BrightCyan, 1, (GetPlayerX(index) * 32), (GetPlayerY(index) * 32)
        End If
            Damage = Damage - GetPlayerDef(index)
        If Damage > 0 Then
            Call PlayerAttackNpc(index, mapNpcNum, Damage)
        Else
            Call PlayerMsg(index, "You Miss.", BrightRed)
        End If
    End If
End Sub

Public Function CanPlayerAttackNpc(ByVal attacker As Long, ByVal mapNpcNum As Long, Optional ByVal IsSpell As Boolean = False) As Boolean
    Dim mapnum As Long
    Dim npcNum As Long
    Dim NpcX As Long
    Dim NpcY As Long
    Dim attackspeed As Long

    ' Check for subscript out of range
    If IsPlaying(attacker) = False Or mapNpcNum <= 0 Or mapNpcNum > MAX_MAP_NPCS Then
        Exit Function
    End If

    ' Check for subscript out of range
    If MapNpc(GetPlayerMap(attacker)).Npc(mapNpcNum).Num <= 0 Then
        Exit Function
    End If

    mapnum = GetPlayerMap(attacker)
    npcNum = MapNpc(mapnum).Npc(mapNpcNum).Num
    
    ' Make sure the npc isn't already dead
    If MapNpc(mapnum).Npc(mapNpcNum).Vital(Vitals.HP) <= 0 Then
        If Npc(MapNpc(mapnum).Npc(mapNpcNum).Num).Behaviour <> NPC_BEHAVIOUR_FRIENDLY Then
            If Npc(MapNpc(mapnum).Npc(mapNpcNum).Num).Behaviour <> NPC_BEHAVIOUR_SHOPKEEPER Then
                Exit Function
            End If
        End If
    End If

    ' Make sure they are on the same map
    If IsPlaying(attacker) Then
    
        ' exit out early
        If IsSpell Then
             If npcNum > 0 Then
                If Npc(npcNum).Behaviour <> NPC_BEHAVIOUR_FRIENDLY And Npc(npcNum).Behaviour <> NPC_BEHAVIOUR_SHOPKEEPER Then
                    CanPlayerAttackNpc = True
                    Exit Function
                End If
            End If
        End If

        ' attack speed from weapon
        If GetPlayerEquipment(attacker, Weapon) > 0 Then
            attackspeed = Item(GetPlayerEquipment(attacker, Weapon)).Speed
        Else
            attackspeed = 1000
        End If

        If npcNum > 0 And GetTickCount > TempPlayer(attacker).AttackTimer + attackspeed Then
            ' Check if at same coordinates
            Select Case GetPlayerDir(attacker)
                Case DIR_UP
                    NpcX = MapNpc(mapnum).Npc(mapNpcNum).x
                    NpcY = MapNpc(mapnum).Npc(mapNpcNum).y + 1
                Case DIR_DOWN
                    NpcX = MapNpc(mapnum).Npc(mapNpcNum).x
                    NpcY = MapNpc(mapnum).Npc(mapNpcNum).y - 1
                Case DIR_LEFT
                    NpcX = MapNpc(mapnum).Npc(mapNpcNum).x + 1
                    NpcY = MapNpc(mapnum).Npc(mapNpcNum).y
                Case DIR_RIGHT
                    NpcX = MapNpc(mapnum).Npc(mapNpcNum).x - 1
                    NpcY = MapNpc(mapnum).Npc(mapNpcNum).y
            End Select

            If NpcX = GetPlayerX(attacker) Then
                If NpcY = GetPlayerY(attacker) Then
                    If Npc(npcNum).Behaviour <> NPC_BEHAVIOUR_FRIENDLY And Npc(npcNum).Behaviour <> NPC_BEHAVIOUR_SHOPKEEPER Then
                        CanPlayerAttackNpc = True
                    Else
                        If Len(Trim$(Npc(npcNum).AttackSay)) > 0 Then
                            PlayerMsg attacker, Trim$(Npc(npcNum).Name) & ": " & Trim$(Npc(npcNum).AttackSay), White
                        End If
                    End If
                End If
            End If
        End If
    End If

End Function

Public Sub PlayerAttackNpc(ByVal attacker As Long, ByVal mapNpcNum As Long, ByVal Damage As Long, Optional ByVal spellnum As Long, Optional ByVal overTime As Boolean = False)
    Dim Name As String
    Dim exp As Long
    Dim n As Long
    Dim i As Long
    Dim STR As Long
    Dim Def As Long
    Dim mapnum As Long
    Dim npcNum As Long
    Dim buffer As clsBuffer

    ' Check for subscript out of range
    If IsPlaying(attacker) = False Or mapNpcNum <= 0 Or mapNpcNum > MAX_MAP_NPCS Or Damage < 0 Then
        Exit Sub
    End If

    mapnum = GetPlayerMap(attacker)
    npcNum = MapNpc(mapnum).Npc(mapNpcNum).Num
    Name = Trim$(Npc(npcNum).Name)
    
    ' Check for weapon
    n = 0

    If GetPlayerEquipment(attacker, Weapon) > 0 Then
        n = GetPlayerEquipment(attacker, Weapon)
    End If
    
    ' set the regen timer
    TempPlayer(attacker).stopRegen = True
    TempPlayer(attacker).stopRegenTimer = GetTickCount

    If Damage >= MapNpc(mapnum).Npc(mapNpcNum).Vital(Vitals.HP) Then
    
        SendActionMsg GetPlayerMap(attacker), "-" & MapNpc(mapnum).Npc(mapNpcNum).Vital(Vitals.HP), BrightRed, 1, (MapNpc(mapnum).Npc(mapNpcNum).x * 32), (MapNpc(mapnum).Npc(mapNpcNum).y * 32)
        SendBlood GetPlayerMap(attacker), MapNpc(mapnum).Npc(mapNpcNum).x, MapNpc(mapnum).Npc(mapNpcNum).y
        
        ' send the sound
        If spellnum > 0 Then SendMapSound attacker, MapNpc(mapnum).Npc(mapNpcNum).x, MapNpc(mapnum).Npc(mapNpcNum).y, SoundEntity.seSpell, spellnum
        
        ' send animation
        If n > 0 Then
            If Not overTime Then
                If spellnum = 0 Then Call SendAnimation(mapnum, Item(GetPlayerEquipment(attacker, Weapon)).Animation, MapNpc(mapnum).Npc(mapNpcNum).x, MapNpc(mapnum).Npc(mapNpcNum).y)
            End If
        End If

        ' Calculate exp to give attacker
        exp = Npc(npcNum).exp

        ' Make sure we dont get less then 0
        If exp < 0 Then
            exp = 1
        End If

        ' in party?
        If TempPlayer(attacker).inParty > 0 Then
            ' pass through party sharing function
            Party_ShareExp TempPlayer(attacker).inParty, exp, attacker, GetPlayerMap(attacker)
        Else
            ' no party - keep exp for self
            GivePlayerEXP attacker, exp
        End If
        
        'Drop the goods if they get it
        n = Int(Rnd * Npc(npcNum).DropChance) + 1

        If n = 1 Then
            Call SpawnItem(Npc(npcNum).DropItem, Npc(npcNum).DropItemValue, mapnum, MapNpc(mapnum).Npc(mapNpcNum).x, MapNpc(mapnum).Npc(mapNpcNum).y)
        End If

        ' Now set HP to 0 so we know to actually kill them in the server loop (this prevents subscript out of range)
        MapNpc(mapnum).Npc(mapNpcNum).Num = 0
        MapNpc(mapnum).Npc(mapNpcNum).SpawnWait = GetTickCount
        MapNpc(mapnum).Npc(mapNpcNum).Vital(Vitals.HP) = 0
        UpdateMapBlock mapnum, MapNpc(mapnum).Npc(mapNpcNum).x, MapNpc(mapnum).Npc(mapNpcNum).y, False
        
        ' clear DoTs and HoTs
        For i = 1 To MAX_DOTS
            With MapNpc(mapnum).Npc(mapNpcNum).DoT(i)
                .Spell = 0
                .Timer = 0
                .Caster = 0
                .StartTime = 0
                .Used = False
            End With
            
            With MapNpc(mapnum).Npc(mapNpcNum).HoT(i)
                .Spell = 0
                .Timer = 0
                .Caster = 0
                .StartTime = 0
                .Used = False
            End With
        Next
        
        ' send death to the map
        Set buffer = New clsBuffer
        buffer.WriteLong SNpcDead
        buffer.WriteLong mapNpcNum
        SendDataToMap mapnum, buffer.ToArray()
        Set buffer = Nothing
        
        'Loop through entire map and purge NPC from targets
        For i = 1 To Player_HighIndex
            If IsPlaying(i) And IsConnected(i) Then
                If Player(i).Map = mapnum Then
                    If TempPlayer(i).targetType = TARGET_TYPE_NPC Then
                        If TempPlayer(i).target = mapNpcNum Then
                            TempPlayer(i).target = 0
                            TempPlayer(i).targetType = TARGET_TYPE_NONE
                            SendTarget i
                        End If
                    End If
                End If
            End If
        Next
    Else
        ' NPC not dead, just do the damage
        MapNpc(mapnum).Npc(mapNpcNum).Vital(Vitals.HP) = MapNpc(mapnum).Npc(mapNpcNum).Vital(Vitals.HP) - Damage

        ' Check for a weapon and say damage
        SendActionMsg mapnum, "-" & Damage, BrightRed, 1, (MapNpc(mapnum).Npc(mapNpcNum).x * 32), (MapNpc(mapnum).Npc(mapNpcNum).y * 32)
        SendBlood GetPlayerMap(attacker), MapNpc(mapnum).Npc(mapNpcNum).x, MapNpc(mapnum).Npc(mapNpcNum).y
        
        ' send the sound
        If spellnum > 0 Then SendMapSound attacker, MapNpc(mapnum).Npc(mapNpcNum).x, MapNpc(mapnum).Npc(mapNpcNum).y, SoundEntity.seSpell, spellnum
        
        ' send animation
        If n > 0 Then
            If Not overTime Then
                If spellnum = 0 Then Call SendAnimation(mapnum, Item(GetPlayerEquipment(attacker, Weapon)).Animation, 0, 0, TARGET_TYPE_NPC, mapNpcNum)
            End If
        End If

        ' Set the NPC target to the player
        MapNpc(mapnum).Npc(mapNpcNum).targetType = 1 ' player
        MapNpc(mapnum).Npc(mapNpcNum).target = attacker

        ' Now check for guard ai and if so have all onmap guards come after'm
        If Npc(MapNpc(mapnum).Npc(mapNpcNum).Num).Behaviour = NPC_BEHAVIOUR_GUARD Then
            For i = 1 To MAX_MAP_NPCS
                If MapNpc(mapnum).Npc(i).Num = MapNpc(mapnum).Npc(mapNpcNum).Num Then
                    MapNpc(mapnum).Npc(i).target = attacker
                    MapNpc(mapnum).Npc(i).targetType = 1 ' player
                End If
            Next
        End If
        
        ' set the regen timer
        MapNpc(mapnum).Npc(mapNpcNum).stopRegen = True
        MapNpc(mapnum).Npc(mapNpcNum).stopRegenTimer = GetTickCount
        
        ' if stunning spell, stun the npc
        If spellnum > 0 Then
            If Spell(spellnum).StunDuration > 0 Then StunNPC mapNpcNum, mapnum, spellnum
            ' DoT
            If Spell(spellnum).Duration > 0 Then
                AddDoT_Npc mapnum, mapNpcNum, spellnum, attacker
            End If
        End If
        
        SendMapNpcVitals mapnum, mapNpcNum
    End If

    If spellnum = 0 Then
        ' Reset attack timer
        TempPlayer(attacker).AttackTimer = GetTickCount
    End If
End Sub

' ###################################
' ##      NPC Attacking Player     ##
' ###################################

Public Sub TryNpcAttackPlayer(ByVal mapNpcNum As Long, ByVal index As Long)
Dim mapnum As Long, npcNum As Long, blockAmount As Long, Damage As Long

    ' Can the npc attack the player?
    If CanNpcAttackPlayer(mapNpcNum, index) Then
        mapnum = GetPlayerMap(index)
        npcNum = MapNpc(mapnum).Npc(mapNpcNum).Num
    
        ' check if PLAYER can avoid the attack
        If CanPlayerDodge(index) Then
            SendActionMsg mapnum, "Dodge!", Pink, 1, (Player(index).x * 32), (Player(index).y * 32)
            Exit Sub
        End If
        If CanPlayerParry(index) Then
            SendActionMsg mapnum, "Parry!", Pink, 1, (Player(index).x * 32), (Player(index).y * 32)
            Exit Sub
        End If

        ' Get the damage we can do
        Damage = GetNpcDamage(npcNum)
        
        ' if the player blocks, take away the block amount
        blockAmount = CanPlayerBlock(index)
        Damage = Damage - blockAmount
        
        ' take away armour
        Damage = Damage - rand(1, (GetPlayerStat(index, Agility) * 2))
        
        ' randomise for up to 10% lower than max hit
        Damage = rand(1, Damage)
        
        ' * 1.5 if crit hit
        If CanNpcCrit(index) Then
            Damage = Damage * 1.5
            SendActionMsg mapnum, "Critical!", BrightCyan, 1, (MapNpc(mapnum).Npc(mapNpcNum).x * 32), (MapNpc(mapnum).Npc(mapNpcNum).y * 32)
        End If

        If Damage > 0 Then
            Call NpcAttackPlayer(mapNpcNum, index, Damage)
        End If
    End If
End Sub

Function CanNpcAttackPlayer(ByVal mapNpcNum As Long, ByVal index As Long) As Boolean
    Dim mapnum As Long
    Dim npcNum As Long

    ' Check for subscript out of range
    If mapNpcNum <= 0 Or mapNpcNum > MAX_MAP_NPCS Or Not IsPlaying(index) Then
        Exit Function
    End If

    ' Check for subscript out of range
    If MapNpc(GetPlayerMap(index)).Npc(mapNpcNum).Num <= 0 Then
        Exit Function
    End If

    mapnum = GetPlayerMap(index)
    npcNum = MapNpc(mapnum).Npc(mapNpcNum).Num

    ' Make sure the npc isn't already dead
    If MapNpc(mapnum).Npc(mapNpcNum).Vital(Vitals.HP) <= 0 Then
        Exit Function
    End If

    ' Make sure npcs dont attack more then once a second
    If GetTickCount < MapNpc(mapnum).Npc(mapNpcNum).AttackTimer + 1000 Then
        Exit Function
    End If

    ' Make sure we dont attack the player if they are switching maps
    If TempPlayer(index).GettingMap = YES Then
        Exit Function
    End If

    MapNpc(mapnum).Npc(mapNpcNum).AttackTimer = GetTickCount

    ' Make sure they are on the same map
    If IsPlaying(index) Then
        If npcNum > 0 Then

            ' Check if at same coordinates
            If (GetPlayerY(index) + 1 = MapNpc(mapnum).Npc(mapNpcNum).y) And (GetPlayerX(index) = MapNpc(mapnum).Npc(mapNpcNum).x) Then
                CanNpcAttackPlayer = True
            Else
                If (GetPlayerY(index) - 1 = MapNpc(mapnum).Npc(mapNpcNum).y) And (GetPlayerX(index) = MapNpc(mapnum).Npc(mapNpcNum).x) Then
                    CanNpcAttackPlayer = True
                Else
                    If (GetPlayerY(index) = MapNpc(mapnum).Npc(mapNpcNum).y) And (GetPlayerX(index) + 1 = MapNpc(mapnum).Npc(mapNpcNum).x) Then
                        CanNpcAttackPlayer = True
                    Else
                        If (GetPlayerY(index) = MapNpc(mapnum).Npc(mapNpcNum).y) And (GetPlayerX(index) - 1 = MapNpc(mapnum).Npc(mapNpcNum).x) Then
                            CanNpcAttackPlayer = True
                        End If
                    End If
                End If
            End If
        End If
    End If
End Function

Sub NpcAttackPlayer(ByVal mapNpcNum As Long, ByVal victim As Long, ByVal Damage As Long)
    Dim Name As String
    Dim exp As Long
    Dim mapnum As Long
    Dim i As Long
    Dim buffer As clsBuffer

    ' Check for subscript out of range
    If mapNpcNum <= 0 Or mapNpcNum > MAX_MAP_NPCS Or IsPlaying(victim) = False Then
        Exit Sub
    End If

    ' Check for subscript out of range
    If MapNpc(GetPlayerMap(victim)).Npc(mapNpcNum).Num <= 0 Then
        Exit Sub
    End If

    mapnum = GetPlayerMap(victim)
    Name = Trim$(Npc(MapNpc(mapnum).Npc(mapNpcNum).Num).Name)
    
    ' Send this packet so they can see the npc attacking
    Set buffer = New clsBuffer
    buffer.WriteLong SNpcAttack
    buffer.WriteLong mapNpcNum
    SendDataToMap mapnum, buffer.ToArray()
    Set buffer = Nothing
    
    If Damage <= 0 Then
        Exit Sub
    End If
    
    ' set the regen timer
    MapNpc(mapnum).Npc(mapNpcNum).stopRegen = True
    MapNpc(mapnum).Npc(mapNpcNum).stopRegenTimer = GetTickCount

    If Damage >= GetPlayerVital(victim, Vitals.HP) Then
        ' Say damage
        SendActionMsg GetPlayerMap(victim), "-" & GetPlayerVital(victim, Vitals.HP), BrightRed, 1, (GetPlayerX(victim) * 32), (GetPlayerY(victim) * 32)
        
        ' send the sound
        SendMapSound victim, GetPlayerX(victim), GetPlayerY(victim), SoundEntity.seNpc, MapNpc(mapnum).Npc(mapNpcNum).Num
        
        ' kill player
        KillPlayer victim
        
        ' Player is dead
        Call GlobalMsg(GetPlayerName(victim) & ", Was beaten up by a by a " & Name, BrightRed)

        ' Set NPC target to 0
        MapNpc(mapnum).Npc(mapNpcNum).target = 0
        MapNpc(mapnum).Npc(mapNpcNum).targetType = 0
    Else
        ' Player not dead, just do the damage
        Call SetPlayerVital(victim, Vitals.HP, GetPlayerVital(victim, Vitals.HP) - Damage)
        Call SendVital(victim, Vitals.HP)
        Call SendAnimation(mapnum, Npc(MapNpc(GetPlayerMap(victim)).Npc(mapNpcNum).Num).Animation, 0, 0, TARGET_TYPE_PLAYER, victim)
        
        ' send vitals to party if in one
        If TempPlayer(victim).inParty > 0 Then SendPartyVitals TempPlayer(victim).inParty, victim
        
        ' send the sound
        SendMapSound victim, GetPlayerX(victim), GetPlayerY(victim), SoundEntity.seNpc, MapNpc(mapnum).Npc(mapNpcNum).Num
        
        ' Say damage
        SendActionMsg GetPlayerMap(victim), "-" & Damage, BrightRed, 1, (GetPlayerX(victim) * 32), (GetPlayerY(victim) * 32)
        SendBlood GetPlayerMap(victim), GetPlayerX(victim), GetPlayerY(victim)
        
        ' set the regen timer
        TempPlayer(victim).stopRegen = True
        TempPlayer(victim).stopRegenTimer = GetTickCount
    End If

End Sub

' ###################################
' ##    Player Attacking Player    ##
' ###################################

Public Sub TryPlayerAttackPlayer(ByVal attacker As Long, ByVal victim As Long)
Dim blockAmount As Long
Dim npcNum As Long
Dim mapnum As Long
Dim Damage As Long

    Damage = 0

    ' Can we attack the npc?
    If CanPlayerAttackPlayer(attacker, victim) Then
    
        mapnum = GetPlayerMap(attacker)
    
        ' check if NPC can avoid the attack
        If CanPlayerDodge(victim) Then
            SendActionMsg mapnum, "Dodge!", Pink, 1, (GetPlayerX(victim) * 32), (GetPlayerY(victim) * 32)
            Exit Sub
        End If
        If CanPlayerParry(victim) Then
            SendActionMsg mapnum, "Parry!", Pink, 1, (GetPlayerX(victim) * 32), (GetPlayerY(victim) * 32)
            Exit Sub
        End If

        ' Get the damage we can do
        Damage = GetPlayerDamage(attacker)
        
        ' if the npc blocks, take away the block amount
        blockAmount = CanPlayerBlock(victim)
        Damage = Damage - blockAmount
        
        ' take away armour
        Damage = Damage - rand(1, (GetPlayerStat(victim, Agility) * 2))
        
        ' randomise for up to 10% lower than max hit
        Damage = rand(1, Damage)
        
        ' * 1.5 if can crit
        If CanPlayerCrit(attacker) Then
            Damage = Damage * 1.5
            SendActionMsg mapnum, "Critical!", BrightCyan, 1, (GetPlayerX(attacker) * 32), (GetPlayerY(attacker) * 32)
        End If
            Damage = Damage - GetPlayerDef(victim)
        If Damage > 0 Then
            Call PlayerAttackPlayer(attacker, victim, Damage)
        Else
            Call PlayerMsg(attacker, "You Miss.", BrightRed)
        End If
    End If
End Sub

Function CanPlayerAttackPlayer(ByVal attacker As Long, ByVal victim As Long, Optional ByVal IsSpell As Boolean = False) As Boolean

    If Not IsSpell Then
        ' Check attack timer
        If GetPlayerEquipment(attacker, Weapon) > 0 Then
            If GetTickCount < TempPlayer(attacker).AttackTimer + Item(GetPlayerEquipment(attacker, Weapon)).Speed Then Exit Function
        Else
            If GetTickCount < TempPlayer(attacker).AttackTimer + 1000 Then Exit Function
        End If
    End If

    ' Check for subscript out of range
    If Not IsPlaying(victim) Then Exit Function

    ' Make sure they are on the same map
    If Not GetPlayerMap(attacker) = GetPlayerMap(victim) Then Exit Function

    ' Make sure we dont attack the player if they are switching maps
    If TempPlayer(victim).GettingMap = YES Then Exit Function

    If Not IsSpell Then
        ' Check if at same coordinates
        Select Case GetPlayerDir(attacker)
            Case DIR_UP
    
                If Not ((GetPlayerY(victim) + 1 = GetPlayerY(attacker)) And (GetPlayerX(victim) = GetPlayerX(attacker))) Then Exit Function
            Case DIR_DOWN
    
                If Not ((GetPlayerY(victim) - 1 = GetPlayerY(attacker)) And (GetPlayerX(victim) = GetPlayerX(attacker))) Then Exit Function
            Case DIR_LEFT
    
                If Not ((GetPlayerY(victim) = GetPlayerY(attacker)) And (GetPlayerX(victim) + 1 = GetPlayerX(attacker))) Then Exit Function
            Case DIR_RIGHT
    
                If Not ((GetPlayerY(victim) = GetPlayerY(attacker)) And (GetPlayerX(victim) - 1 = GetPlayerX(attacker))) Then Exit Function
            Case Else
                Exit Function
        End Select
    End If

    ' Check if map is attackable
    If Not Map(GetPlayerMap(attacker)).Moral = MAP_MORAL_NONE Then
        If GetPlayerPK(victim) = NO Then
            Call PlayerMsg(attacker, "This is a safe zone!", BrightRed)
            Exit Function
        End If
    End If

    ' Make sure they have more then 0 hp
    If GetPlayerVital(victim, Vitals.HP) <= 0 Then Exit Function

    ' Check to make sure that they dont have access
    If GetPlayerAccess(attacker) > ADMIN_MONITOR Then
        Call PlayerMsg(attacker, "Admins cannot attack other players.", BrightBlue)
        Exit Function
    End If

    ' Check to make sure the victim isn't an admin
    If GetPlayerAccess(victim) > ADMIN_MONITOR Then
        Call PlayerMsg(attacker, "You cannot attack " & GetPlayerName(victim) & "!", BrightRed)
        Exit Function
    End If

    ' Make sure attacker is high enough level
    If GetPlayerLevel(attacker) < 10 Then
        Call PlayerMsg(attacker, "You are below level 10, you cannot attack another player yet!", BrightRed)
        Exit Function
    End If

    ' Make sure victim is high enough level
    If GetPlayerLevel(victim) < 10 Then
        Call PlayerMsg(attacker, GetPlayerName(victim) & " is below level 10, you cannot attack this player yet!", BrightRed)
        Exit Function
    End If

    CanPlayerAttackPlayer = True
End Function

Sub PlayerAttackPlayer(ByVal attacker As Long, ByVal victim As Long, ByVal Damage As Long, Optional ByVal spellnum As Long = 0)
    Dim exp As Long
    Dim n As Long
    Dim i As Long
    Dim buffer As clsBuffer

    ' Check for subscript out of range
    If IsPlaying(attacker) = False Or IsPlaying(victim) = False Or Damage < 0 Then
        Exit Sub
    End If

    ' Check for weapon
    n = 0

    If GetPlayerEquipment(attacker, Weapon) > 0 Then
        n = GetPlayerEquipment(attacker, Weapon)
    End If
    
    ' set the regen timer
    TempPlayer(attacker).stopRegen = True
    TempPlayer(attacker).stopRegenTimer = GetTickCount

    If Damage >= GetPlayerVital(victim, Vitals.HP) Then
        SendActionMsg GetPlayerMap(victim), "-" & GetPlayerVital(victim, Vitals.HP), BrightRed, 1, (GetPlayerX(victim) * 32), (GetPlayerY(victim) * 32)
        
        ' send the sound
        If spellnum > 0 Then SendMapSound victim, GetPlayerX(victim), GetPlayerY(victim), SoundEntity.seSpell, spellnum
        ' send animation
        If n > 0 Then
            If spellnum = 0 Then Call SendAnimation(GetPlayerMap(victim), Item(GetPlayerEquipment(attacker, Weapon)).Animation, 0, 0, TARGET_TYPE_PLAYER, victim)
        End If
        
        ' Player is dead
        Call GlobalMsg(GetPlayerName(victim) & " Attacked and defeated " & GetPlayerName(attacker), BrightRed)
        ' Calculate exp to give attacker
        exp = (GetPlayerExp(victim) \ 10)

        ' Make sure we dont get less then 0
        If exp < 0 Then
            exp = 0
        End If

        If exp = 0 Then
            Call PlayerMsg(victim, "You lost no exp.", BrightRed)
            Call PlayerMsg(attacker, "You received no exp.", BrightBlue)
        Else
            Call SetPlayerExp(victim, GetPlayerExp(victim) - exp)
            SendEXP victim
            Call PlayerMsg(victim, "You lost " & exp & " exp.", BrightRed)
            
            ' check if we're in a party
            If TempPlayer(attacker).inParty > 0 Then
                ' pass through party exp share function
                Party_ShareExp TempPlayer(attacker).inParty, exp, attacker, GetPlayerMap(attacker)
            Else
                ' not in party, get exp for self
                GivePlayerEXP attacker, exp
            End If
        End If
        
        ' purge target info of anyone who targetted dead guy
        For i = 1 To Player_HighIndex
            If IsPlaying(i) And IsConnected(i) Then
                If Player(i).Map = GetPlayerMap(attacker) Then
                    If TempPlayer(i).target = TARGET_TYPE_PLAYER Then
                        If TempPlayer(i).target = victim Then
                            TempPlayer(i).target = 0
                            TempPlayer(i).targetType = TARGET_TYPE_NONE
                            SendTarget i
                        End If
                    End If
                End If
            End If
        Next

        If GetPlayerPK(victim) = NO Then
            If GetPlayerPK(attacker) = NO Then
                Call SetPlayerPK(attacker, YES)
                Call SendPlayerData(attacker)
                Call GlobalMsg(GetPlayerName(attacker) & ", attacked and beat up someone!", BrightRed)
            End If

        Else
            Call GlobalMsg(GetPlayerName(victim) & "got what they had coming.", BrightRed)
        End If

        Call OnDeath(victim)
    Else
        ' Player not dead, just do the damage
        Call SetPlayerVital(victim, Vitals.HP, GetPlayerVital(victim, Vitals.HP) - Damage)
        Call SendVital(victim, Vitals.HP)
        
        ' send vitals to party if in one
        If TempPlayer(victim).inParty > 0 Then SendPartyVitals TempPlayer(victim).inParty, victim
        
        ' send the sound
        If spellnum > 0 Then SendMapSound victim, GetPlayerX(victim), GetPlayerY(victim), SoundEntity.seSpell, spellnum
        
        ' send animation
        If n > 0 Then
            If spellnum = 0 Then Call SendAnimation(GetPlayerMap(victim), Item(GetPlayerEquipment(attacker, Weapon)).Animation, 0, 0, TARGET_TYPE_PLAYER, victim)
        End If
        
        SendActionMsg GetPlayerMap(victim), "-" & Damage, BrightRed, 1, (GetPlayerX(victim) * 32), (GetPlayerY(victim) * 32)
        SendBlood GetPlayerMap(victim), GetPlayerX(victim), GetPlayerY(victim)
        
        ' set the regen timer
        TempPlayer(victim).stopRegen = True
        TempPlayer(victim).stopRegenTimer = GetTickCount
        
        'if a stunning spell, stun the player
        If spellnum > 0 Then
            If Spell(spellnum).StunDuration > 0 Then StunPlayer victim, spellnum
            ' DoT
            If Spell(spellnum).Duration > 0 Then
                AddDoT_Player victim, spellnum, attacker
            End If
        End If
    End If

    ' Reset attack timer
    TempPlayer(attacker).AttackTimer = GetTickCount
End Sub

' ############
' ## Spells ##
' ############

Public Sub BufferSpell(ByVal index As Long, ByVal spellslot As Long)
    Dim spellnum As Long
    Dim MPCost As Long
    Dim LevelReq As Long
    Dim mapnum As Long
    Dim SpellCastType As Long
    Dim ClassReq As Long
    Dim AccessReq As Long
    Dim Range As Long
    Dim HasBuffered As Boolean
    
    Dim targetType As Byte
    Dim target As Long
    
    ' Prevent subscript out of range
    If spellslot <= 0 Or spellslot > MAX_PLAYER_SPELLS Then Exit Sub
    
    spellnum = GetPlayerSpell(index, spellslot)
    mapnum = GetPlayerMap(index)
    
    If spellnum <= 0 Or spellnum > MAX_SPELLS Then Exit Sub
    
    ' Make sure player has the spell
    If Not HasSpell(index, spellnum) Then Exit Sub
    
    ' see if cooldown has finished
    If TempPlayer(index).SpellCD(spellslot) > GetTickCount Then
        PlayerMsg index, "Spell hasn't cooled down yet!", BrightRed
        Exit Sub
    End If

    MPCost = Spell(spellnum).MPCost

    ' Check if they have enough MP
    If GetPlayerVital(index, Vitals.MP) < MPCost Then
        Call PlayerMsg(index, "Not enough mana!", BrightRed)
        Exit Sub
    End If
    
    LevelReq = Spell(spellnum).LevelReq

    ' Make sure they are the right level
    If LevelReq > GetPlayerLevel(index) Then
        Call PlayerMsg(index, "You must be level " & LevelReq & " to cast this spell.", BrightRed)
        Exit Sub
    End If
    
    AccessReq = Spell(spellnum).AccessReq
    
    ' make sure they have the right access
    If AccessReq > GetPlayerAccess(index) Then
        Call PlayerMsg(index, "You must be an administrator to cast this spell.", BrightRed)
        Exit Sub
    End If
    
    ClassReq = Spell(spellnum).ClassReq
    
    ' make sure the classreq > 0
    If ClassReq > 0 Then ' 0 = no req
        If ClassReq <> GetPlayerClass(index) Then
            Call PlayerMsg(index, "Only " & CheckGrammar(Trim$(Class(ClassReq).Name)) & " can use this spell.", BrightRed)
            Exit Sub
        End If
    End If
    
    ' find out what kind of spell it is! self cast, target or AOE
    If Spell(spellnum).Range > 0 Then
        ' ranged attack, single target or aoe?
        If Not Spell(spellnum).IsAoE Then
            SpellCastType = 2 ' targetted
        Else
            SpellCastType = 3 ' targetted aoe
        End If
    Else
        If Not Spell(spellnum).IsAoE Then
            SpellCastType = 0 ' self-cast
        Else
            SpellCastType = 1 ' self-cast AoE
        End If
    End If
    
    targetType = TempPlayer(index).targetType
    target = TempPlayer(index).target
    Range = Spell(spellnum).Range
    HasBuffered = False
    
    Select Case SpellCastType
        Case 0, 1 ' self-cast & self-cast AOE
            HasBuffered = True
        Case 2, 3 ' targeted & targeted AOE
            ' check if have target
            If Not target > 0 Then
                PlayerMsg index, "You do not have a target.", BrightRed
            End If
            If targetType = TARGET_TYPE_PLAYER Then
                ' if have target, check in range
                If Not isInRange(Range, GetPlayerX(index), GetPlayerY(index), GetPlayerX(target), GetPlayerY(target)) Then
                    PlayerMsg index, "Target not in range.", BrightRed
                Else
                    ' go through spell types
                    If Spell(spellnum).Type <> SPELL_TYPE_DAMAGEHP And Spell(spellnum).Type <> SPELL_TYPE_DAMAGEMP Then
                        HasBuffered = True
                    Else
                        If CanPlayerAttackPlayer(index, target, True) Then
                            HasBuffered = True
                        End If
                    End If
                End If
            ElseIf targetType = TARGET_TYPE_NPC Then
                ' if have target, check in range
                If Not isInRange(Range, GetPlayerX(index), GetPlayerY(index), MapNpc(mapnum).Npc(target).x, MapNpc(mapnum).Npc(target).y) Then
                    PlayerMsg index, "Target not in range.", BrightRed
                    HasBuffered = False
                Else
                    ' go through spell types
                    If Spell(spellnum).Type <> SPELL_TYPE_DAMAGEHP And Spell(spellnum).Type <> SPELL_TYPE_DAMAGEMP Then
                        HasBuffered = True
                    Else
                        If CanPlayerAttackNpc(index, target, True) Then
                            HasBuffered = True
                        End If
                    End If
                End If
            End If
    End Select
    
    If HasBuffered Then
        SendAnimation mapnum, Spell(spellnum).CastAnim, 0, 0, TARGET_TYPE_PLAYER, index
        SendActionMsg mapnum, "Casting " & Trim$(Spell(spellnum).Name) & "!", BrightRed, ACTIONMSG_SCROLL, GetPlayerX(index) * 32, GetPlayerY(index) * 32
        TempPlayer(index).spellBuffer.Spell = spellslot
        TempPlayer(index).spellBuffer.Timer = GetTickCount
        TempPlayer(index).spellBuffer.target = TempPlayer(index).target
        TempPlayer(index).spellBuffer.tType = TempPlayer(index).targetType
        Exit Sub
    Else
        SendClearSpellBuffer index
    End If
End Sub
Public Sub CastSpell(ByVal index As Long, ByVal spellslot As Long, ByVal target As Long, ByVal targetType As Byte)
Dim Dur As Long
    Dim spellnum As Long
    Dim MPCost As Long
    Dim LevelReq As Long
    Dim mapnum As Long
    Dim Vital As Long
    Dim DidCast As Boolean
    Dim ClassReq As Long
    Dim AccessReq As Long
    Dim i As Long
    Dim AoE As Long
    Dim Range As Long
    Dim VitalType As Byte
    Dim increment As Boolean
    Dim x As Long, y As Long
   
    Dim buffer As clsBuffer
    Dim SpellCastType As Long
   
    DidCast = False

    ' Prevent subscript out of range
    If spellslot <= 0 Or spellslot > MAX_PLAYER_SPELLS Then Exit Sub

    spellnum = GetPlayerSpell(index, spellslot)
    mapnum = GetPlayerMap(index)

    ' Make sure player has the spell
    If Not HasSpell(index, spellnum) Then Exit Sub

    MPCost = Spell(spellnum).MPCost

    ' Check if they have enough MP
    If GetPlayerVital(index, Vitals.MP) < MPCost Then
        Call PlayerMsg(index, "Not enough mana!", BrightRed)
        Exit Sub
    End If
   
    LevelReq = Spell(spellnum).LevelReq

    ' Make sure they are the right level
    If LevelReq > GetPlayerLevel(index) Then
        Call PlayerMsg(index, "You must be level " & LevelReq & " to cast this spell.", BrightRed)
        Exit Sub
    End If
   
    AccessReq = Spell(spellnum).AccessReq
   
    ' make sure they have the right access
    If AccessReq > GetPlayerAccess(index) Then
        Call PlayerMsg(index, "You must be an administrator to cast this spell.", BrightRed)
        Exit Sub
    End If
   
    ClassReq = Spell(spellnum).ClassReq
   
    ' make sure the classreq > 0
    If ClassReq > 0 Then ' 0 = no req
        If ClassReq <> GetPlayerClass(index) Then
            Call PlayerMsg(index, "Only " & CheckGrammar(Trim$(Class(ClassReq).Name)) & " can use this spell.", BrightRed)
            Exit Sub
        End If
    End If
   
    ' find out what kind of spell it is! self cast, target or AOE
    If Spell(spellnum).Range > 0 Then
        ' ranged attack, single target or aoe?
        If Not Spell(spellnum).IsAoE Then
            SpellCastType = 2 ' targetted
        Else
            SpellCastType = 3 ' targetted aoe
        End If
    Else
        If Not Spell(spellnum).IsAoE Then
            SpellCastType = 0 ' self-cast
        Else
            SpellCastType = 1 ' self-cast AoE
        End If
    End If
   
    ' set the vital
    Vital = Spell(spellnum).Vital
    If Spell(spellnum).Type <> SPELL_TYPE_BUFF Then
        Vital = Spell(spellnum).Vital
        Vital = Round((Vital * 0.6)) * Round((Player(index).Level * 1.14)) * Round((Stats.Intelligence + (Stats.Willpower / 2)))
    
        If Spell(spellnum).Type = SPELL_TYPE_HEALHP Then
            Vital = Vital + Round((GetPlayerStat(index, Stats.Willpower) * 1.2))
        End If
    
        If Spell(spellnum).Type = SPELL_TYPE_DAMAGEHP Then
            Vital = Vital + Round((GetPlayerStat(index, Stats.Intelligence) * 1.2))
        End If
    End If
    
    If Spell(spellnum).Type = SPELL_TYPE_BUFF Then
        If Round(GetPlayerStat(index, Stats.Willpower) / 5) > 1 Then
            Dur = Spell(spellnum).Duration * Round(GetPlayerStat(index, Stats.Willpower) / 5)
        Else
            Dur = Spell(spellnum).Duration
        End If
    End If
    AoE = Spell(spellnum).AoE
    Range = Spell(spellnum).Range
   
    Select Case SpellCastType
        Case 0 ' self-cast target
         Case SPELL_TYPE_BUFF
                        Call ApplyBuff(index, Spell(spellnum).BuffType, Dur, Spell(spellnum).Vital)
                        SendAnimation GetPlayerMap(index), Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_PLAYER, index
                        ' send the sound
                        SendMapSound index, GetPlayerX(index), GetPlayerY(index), SoundEntity.seSpell, spellnum
                        DidCast = True
            Select Case Spell(spellnum).Type
                Case SPELL_TYPE_HEALHP
                    SpellPlayer_Effect Vitals.HP, True, index, Vital, spellnum
                    DidCast = True
                Case SPELL_TYPE_HEALMP
                    SpellPlayer_Effect Vitals.MP, True, index, Vital, spellnum
                    DidCast = True
                Case SPELL_TYPE_WARP
                    SendAnimation mapnum, Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_PLAYER, index
                    PlayerWarp index, Spell(spellnum).Map, Spell(spellnum).x, Spell(spellnum).y
                    SendAnimation GetPlayerMap(index), Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_PLAYER, index
                    DidCast = True
            End Select
        Case 1, 3 ' self-cast AOE & targetted AOE
            If SpellCastType = 1 Then
                x = GetPlayerX(index)
                y = GetPlayerY(index)
            ElseIf SpellCastType = 3 Then
                If targetType = 0 Then Exit Sub
                If target = 0 Then Exit Sub
               
                If targetType = TARGET_TYPE_PLAYER Then
                    x = GetPlayerX(target)
                    y = GetPlayerY(target)
                Else
                    x = MapNpc(mapnum).Npc(target).x
                    y = MapNpc(mapnum).Npc(target).y
                End If
               
                If Not isInRange(Range, GetPlayerX(index), GetPlayerY(index), x, y) Then
                    PlayerMsg index, "Target not in range.", BrightRed
                    SendClearSpellBuffer index
                End If
            End If
            Select Case Spell(spellnum).Type
                Case SPELL_TYPE_DAMAGEHP
                    DidCast = True
                    For i = 1 To Player_HighIndex
                        If IsPlaying(i) Then
                            If i <> index Then
                                If GetPlayerMap(i) = GetPlayerMap(index) Then
                                    If isInRange(AoE, x, y, GetPlayerX(i), GetPlayerY(i)) Then
                                        If CanPlayerAttackPlayer(index, i, True) Then
                                            SendAnimation mapnum, Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_PLAYER, i
                                            PlayerAttackPlayer index, i, Vital, spellnum
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    Next
                    For i = 1 To MAX_MAP_NPCS
                        If MapNpc(mapnum).Npc(i).Num > 0 Then
                            If MapNpc(mapnum).Npc(i).Vital(HP) > 0 Then
                                If isInRange(AoE, x, y, MapNpc(mapnum).Npc(i).x, MapNpc(mapnum).Npc(i).y) Then
                                    If CanPlayerAttackNpc(index, i, True) Then
                                        SendAnimation mapnum, Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_NPC, i
                                        PlayerAttackNpc index, i, Vital, spellnum
                                    End If
                                End If
                            End If
                        End If
                    Next
                Case SPELL_TYPE_HEALHP, SPELL_TYPE_HEALMP, SPELL_TYPE_DAMAGEMP
                    If Spell(spellnum).Type = SPELL_TYPE_HEALHP Then
                        VitalType = Vitals.HP
                        increment = True
                    ElseIf Spell(spellnum).Type = SPELL_TYPE_HEALMP Then
                        VitalType = Vitals.MP
                        increment = True
                    ElseIf Spell(spellnum).Type = SPELL_TYPE_DAMAGEMP Then
                        VitalType = Vitals.MP
                        increment = False
                    End If
                   
                    DidCast = True
                    For i = 1 To Player_HighIndex
                        If IsPlaying(i) Then
                            If GetPlayerMap(i) = GetPlayerMap(index) Then
                                If isInRange(AoE, x, y, GetPlayerX(i), GetPlayerY(i)) Then
                                    SpellPlayer_Effect VitalType, increment, i, Vital, spellnum
                                End If
                            End If
                        End If
                    Next
                    For i = 1 To MAX_MAP_NPCS
                        If MapNpc(mapnum).Npc(i).Num > 0 Then
                            If MapNpc(mapnum).Npc(i).Vital(HP) > 0 Then
                                If isInRange(AoE, x, y, MapNpc(mapnum).Npc(i).x, MapNpc(mapnum).Npc(i).y) Then
                                    SpellNpc_Effect VitalType, increment, i, Vital, spellnum, mapnum
                                End If
                            End If
                        End If
                    Next
            End Select
        Case 2 ' targetted
            If targetType = 0 Then Exit Sub
            If target = 0 Then Exit Sub
           
            If targetType = TARGET_TYPE_PLAYER Then
                x = GetPlayerX(target)
                y = GetPlayerY(target)
            Else
                x = MapNpc(mapnum).Npc(target).x
                y = MapNpc(mapnum).Npc(target).y
            End If
               
            If Not isInRange(Range, GetPlayerX(index), GetPlayerY(index), x, y) Then
                PlayerMsg index, "Target not in range.", BrightRed
                SendClearSpellBuffer index
                Exit Sub
            End If
           
            Select Case Spell(spellnum).Type
                Case SPELL_TYPE_DAMAGEHP
                    If targetType = TARGET_TYPE_PLAYER Then
                        If CanPlayerAttackPlayer(index, target, True) Then
                            If Vital > 0 Then
                                SendAnimation mapnum, Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_PLAYER, target
                                PlayerAttackPlayer index, target, Vital, spellnum
                                DidCast = True
                            End If
                        End If
                    Else
                        If CanPlayerAttackNpc(index, target, True) Then
                            If Vital > 0 Then
                                SendAnimation mapnum, Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_NPC, target
                                PlayerAttackNpc index, target, Vital, spellnum
                                DidCast = True
                            End If
                        End If
                    End If
                   
                Case SPELL_TYPE_DAMAGEMP, SPELL_TYPE_HEALMP, SPELL_TYPE_HEALHP
                    If Spell(spellnum).Type = SPELL_TYPE_DAMAGEMP Then
                        VitalType = Vitals.MP
                        increment = False
                        DidCast = True ' <--- Fixed!
                    ElseIf Spell(spellnum).Type = SPELL_TYPE_HEALMP Then
                        VitalType = Vitals.MP
                        increment = True
                        DidCast = True ' <--- Fixed!
                    ElseIf Spell(spellnum).Type = SPELL_TYPE_HEALHP Then
                        VitalType = Vitals.HP
                        increment = True
                        DidCast = True ' <--- Fixed!
                    End If
                   
                    If targetType = TARGET_TYPE_PLAYER Then
                        If Spell(spellnum).Type = SPELL_TYPE_DAMAGEMP Then
                            If CanPlayerAttackPlayer(index, target, True) Then
                                SpellPlayer_Effect VitalType, increment, target, Vital, spellnum
                            End If
                        Else
                            SpellPlayer_Effect VitalType, increment, target, Vital, spellnum
                        End If
                    Else
                        If Spell(spellnum).Type = SPELL_TYPE_DAMAGEMP Then
                            If CanPlayerAttackNpc(index, target, True) Then
                                SpellNpc_Effect VitalType, increment, target, Vital, spellnum, mapnum
                            End If
                        Else
                            SpellNpc_Effect VitalType, increment, target, Vital, spellnum, mapnum
                        End If
                    End If
            Case SPELL_TYPE_BUFF
                    If targetType = TARGET_TYPE_PLAYER Then
                        If Spell(spellnum).BuffType <= BUFF_ADD_DEF And Map(GetPlayerMap(index)).Moral <> MAP_MORAL_NONE Or Spell(spellnum).BuffType > BUFF_NONE And Map(GetPlayerMap(index)).Moral = MAP_MORAL_NONE Then
                            Call ApplyBuff(target, Spell(spellnum).BuffType, Dur, Spell(spellnum).Vital)
                            SendAnimation GetPlayerMap(index), Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_PLAYER, target
                            ' send the sound
                            SendMapSound index, GetPlayerX(index), GetPlayerY(index), SoundEntity.seSpell, spellnum
                            DidCast = True
                        Else
                            PlayerMsg index, "You can not debuff another player in a safe zone!", BrightRed
                        End If
                    End If
            Case SPELL_TYPE_BUFF
                    If targetType = TARGET_TYPE_PLAYER Then
                        If Spell(spellnum).BuffType <= BUFF_ADD_DEF And Map(GetPlayerMap(index)).Moral <> MAP_MORAL_NONE Or Spell(spellnum).BuffType > BUFF_NONE And Map(GetPlayerMap(index)).Moral = MAP_MORAL_NONE Then
                            Call ApplyBuff(target, Spell(spellnum).BuffType, Dur, Spell(spellnum).Vital)
                            SendAnimation GetPlayerMap(index), Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_PLAYER, target
                            ' send the sound
                            SendMapSound index, GetPlayerX(index), GetPlayerY(index), SoundEntity.seSpell, spellnum
                            DidCast = True
                        Else
                            PlayerMsg index, "You can not debuff another player in a safe zone!", BrightRed
                        End If
                    End If
            End Select
    Case SPELL_TYPE_BUFF
                    If targetType = TARGET_TYPE_PLAYER Then
                        If Spell(spellnum).BuffType <= BUFF_ADD_DEF And Map(GetPlayerMap(index)).Moral <> MAP_MORAL_NONE Or Spell(spellnum).BuffType > BUFF_NONE And Map(GetPlayerMap(index)).Moral = MAP_MORAL_NONE Then
                            Call ApplyBuff(target, Spell(spellnum).BuffType, Dur, Spell(spellnum).Vital)
                            SendAnimation GetPlayerMap(index), Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_PLAYER, target
                            ' send the sound
                            SendMapSound index, GetPlayerX(index), GetPlayerY(index), SoundEntity.seSpell, spellnum
                            DidCast = True
                        Else
                            PlayerMsg index, "You can not debuff another player in a safe zone!", BrightRed
                        End If
                    End If
    End Select
    If DidCast Then
        Call SetPlayerVital(index, Vitals.MP, GetPlayerVital(index, Vitals.MP) - MPCost)
        Call SendVital(index, Vitals.MP)
        ' send vitals to party if in one
        If TempPlayer(index).inParty > 0 Then SendPartyVitals TempPlayer(index).inParty, index
       
        TempPlayer(index).SpellCD(spellslot) = GetTickCount + (Spell(spellnum).CDTime * 1000)
        Call SendCooldown(index, spellslot)
        SendActionMsg mapnum, Trim$(Spell(spellnum).Name) & "!", BrightRed, ACTIONMSG_SCROLL, GetPlayerX(index) * 32, GetPlayerY(index) * 32
    End If
End Sub

Public Sub SpellPlayer_Effect(ByVal Vital As Byte, ByVal increment As Boolean, ByVal index As Long, ByVal Damage As Long, ByVal spellnum As Long)
Dim sSymbol As String * 1
Dim Colour As Long

    If Damage > 0 Then
        If increment Then
            sSymbol = "+"
            If Vital = Vitals.HP Then Colour = BrightGreen
            If Vital = Vitals.MP Then Colour = BrightBlue
        Else
            sSymbol = "-"
            Colour = Blue
        End If
    
        SendAnimation GetPlayerMap(index), Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_PLAYER, index
        SendActionMsg GetPlayerMap(index), sSymbol & Damage, Colour, ACTIONMSG_SCROLL, GetPlayerX(index) * 32, GetPlayerY(index) * 32
        
        ' send the sound
        SendMapSound index, GetPlayerX(index), GetPlayerY(index), SoundEntity.seSpell, spellnum
        
      If increment Then
SetPlayerVital index, Vital, GetPlayerVital(index, Vital) + Damage
DoEvents
SendVital index, HP
If Spell(spellnum).Duration > 0 Then
AddHoT_Player index, spellnum
End If
ElseIf Not increment Then
SetPlayerVital index, Vital, GetPlayerVital(index, Vital) - Damage
DoEvents
SendVital index, HP
End If
    End If
End Sub

Public Sub SpellNpc_Effect(ByVal Vital As Byte, ByVal increment As Boolean, ByVal index As Long, ByVal Damage As Long, ByVal spellnum As Long, ByVal mapnum As Long)
Dim sSymbol As String * 1
Dim Colour As Long

    If Damage > 0 Then
        If increment Then
            sSymbol = "+"
            If Vital = Vitals.HP Then Colour = BrightGreen
            If Vital = Vitals.MP Then Colour = BrightBlue
        Else
            sSymbol = "-"
            Colour = Blue
        End If
    
        SendAnimation mapnum, Spell(spellnum).SpellAnim, 0, 0, TARGET_TYPE_NPC, index
        SendActionMsg mapnum, sSymbol & Damage, Colour, ACTIONMSG_SCROLL, MapNpc(mapnum).Npc(index).x * 32, MapNpc(mapnum).Npc(index).y * 32
        
        ' send the sound
        SendMapSound index, MapNpc(mapnum).Npc(index).x, MapNpc(mapnum).Npc(index).y, SoundEntity.seSpell, spellnum
        
        If increment Then
            MapNpc(mapnum).Npc(index).Vital(Vital) = MapNpc(mapnum).Npc(index).Vital(Vital) + Damage
            If Spell(spellnum).Duration > 0 Then
                AddHoT_Npc mapnum, index, spellnum
            End If
        ElseIf Not increment Then
            MapNpc(mapnum).Npc(index).Vital(Vital) = MapNpc(mapnum).Npc(index).Vital(Vital) - Damage
        End If
    End If
End Sub

Public Sub AddDoT_Player(ByVal index As Long, ByVal spellnum As Long, ByVal Caster As Long)
Dim i As Long

    For i = 1 To MAX_DOTS
        With TempPlayer(index).DoT(i)
            If .Spell = spellnum Then
                .Timer = GetTickCount
                .Caster = Caster
                .StartTime = GetTickCount
                Exit Sub
            End If
            
            If .Used = False Then
                .Spell = spellnum
                .Timer = GetTickCount
                .Caster = Caster
                .Used = True
                .StartTime = GetTickCount
                Exit Sub
            End If
        End With
    Next
End Sub

Public Sub AddHoT_Player(ByVal index As Long, ByVal spellnum As Long)
Dim i As Long

    For i = 1 To MAX_DOTS
        With TempPlayer(index).HoT(i)
            If .Spell = spellnum Then
                .Timer = GetTickCount
                .StartTime = GetTickCount
                Exit Sub
            End If
            
            If .Used = False Then
                .Spell = spellnum
                .Timer = GetTickCount
                .Used = True
                .StartTime = GetTickCount
                Exit Sub
            End If
        End With
    Next
End Sub

Public Sub AddDoT_Npc(ByVal mapnum As Long, ByVal index As Long, ByVal spellnum As Long, ByVal Caster As Long)
Dim i As Long

    For i = 1 To MAX_DOTS
        With MapNpc(mapnum).Npc(index).DoT(i)
            If .Spell = spellnum Then
                .Timer = GetTickCount
                .Caster = Caster
                .StartTime = GetTickCount
                Exit Sub
            End If
            
            If .Used = False Then
                .Spell = spellnum
                .Timer = GetTickCount
                .Caster = Caster
                .Used = True
                .StartTime = GetTickCount
                Exit Sub
            End If
        End With
    Next
End Sub

Public Sub AddHoT_Npc(ByVal mapnum As Long, ByVal index As Long, ByVal spellnum As Long)
Dim i As Long

    For i = 1 To MAX_DOTS
        With MapNpc(mapnum).Npc(index).HoT(i)
            If .Spell = spellnum Then
                .Timer = GetTickCount
                .StartTime = GetTickCount
                Exit Sub
            End If
            
            If .Used = False Then
                .Spell = spellnum
                .Timer = GetTickCount
                .Used = True
                .StartTime = GetTickCount
                Exit Sub
            End If
        End With
    Next
End Sub

Public Sub HandleDoT_Player(ByVal index As Long, ByVal dotNum As Long)
    With TempPlayer(index).DoT(dotNum)
        If .Used And .Spell > 0 Then
            ' time to tick?
            If GetTickCount > .Timer + (Spell(.Spell).Interval * 1000) Then
                If CanPlayerAttackPlayer(.Caster, index, True) Then
                    PlayerAttackPlayer .Caster, index, Spell(.Spell).Vital
                End If
                .Timer = GetTickCount
                ' check if DoT is still active - if player died it'll have been purged
                If .Used And .Spell > 0 Then
                    ' destroy DoT if finished
                    If GetTickCount - .StartTime >= (Spell(.Spell).Duration * 1000) Then
                        .Used = False
                        .Spell = 0
                        .Timer = 0
                        .Caster = 0
                        .StartTime = 0
                    End If
                End If
            End If
        End If
    End With
End Sub

Public Sub HandleHoT_Player(ByVal index As Long, ByVal hotNum As Long)
    With TempPlayer(index).HoT(hotNum)
        If .Used And .Spell > 0 Then
           ' time to tick?
If GetTickCount > .Timer + (Spell(.Spell).Interval * 1000) Then
If Spell(.Spell).Type = SPELL_TYPE_HEALHP Then
SendActionMsg Player(index).Map, "+" & Spell(.Spell).Vital, BrightGreen, ACTIONMSG_SCROLL, Player(index).x * 32, Player(index).y * 32
SetPlayerVital index, Vitals.HP, GetPlayerVital(index, Vitals.HP) + Spell(.Spell).Vital
DoEvents
SendVital index, HP
Else
SendActionMsg Player(index).Map, "+" & Spell(.Spell).Vital, BrightBlue, ACTIONMSG_SCROLL, Player(index).x * 32, Player(index).y * 32
SetPlayerVital index, Vitals.MP, GetPlayerVital(index, Vitals.MP) + Spell(.Spell).Vital
DoEvents
SendVital index, HP
End If
                .Timer = GetTickCount
                ' check if DoT is still active - if player died it'll have been purged
                If .Used And .Spell > 0 Then
                    ' destroy hoT if finished
                    If GetTickCount - .StartTime >= (Spell(.Spell).Duration * 1000) Then
                        .Used = False
                        .Spell = 0
                        .Timer = 0
                        .Caster = 0
                        .StartTime = 0
                    End If
                End If
            End If
        End If
    End With
End Sub

Public Sub HandleDoT_Npc(ByVal mapnum As Long, ByVal index As Long, ByVal dotNum As Long)
    With MapNpc(mapnum).Npc(index).DoT(dotNum)
        If .Used And .Spell > 0 Then
            ' time to tick?
            If GetTickCount > .Timer + (Spell(.Spell).Interval * 1000) Then
                If CanPlayerAttackNpc(.Caster, index, True) Then
                    PlayerAttackNpc .Caster, index, Spell(.Spell).Vital, , True
                End If
                .Timer = GetTickCount
                ' check if DoT is still active - if NPC died it'll have been purged
                If .Used And .Spell > 0 Then
                    ' destroy DoT if finished
                    If GetTickCount - .StartTime >= (Spell(.Spell).Duration * 1000) Then
                        .Used = False
                        .Spell = 0
                        .Timer = 0
                        .Caster = 0
                        .StartTime = 0
                    End If
                End If
            End If
        End If
    End With
End Sub

Public Sub HandleHoT_Npc(ByVal mapnum As Long, ByVal index As Long, ByVal hotNum As Long)
    With MapNpc(mapnum).Npc(index).HoT(hotNum)
        If .Used And .Spell > 0 Then
            ' time to tick?
            If GetTickCount > .Timer + (Spell(.Spell).Interval * 1000) Then
                If Spell(.Spell).Type = SPELL_TYPE_HEALHP Then
                    SendActionMsg mapnum, "+" & Spell(.Spell).Vital, BrightGreen, ACTIONMSG_SCROLL, MapNpc(mapnum).Npc(index).x * 32, MapNpc(mapnum).Npc(index).y * 32
                    MapNpc(mapnum).Npc(index).Vital(Vitals.HP) = MapNpc(mapnum).Npc(index).Vital(Vitals.HP) + Spell(.Spell).Vital
                Else
                    SendActionMsg mapnum, "+" & Spell(.Spell).Vital, BrightBlue, ACTIONMSG_SCROLL, MapNpc(mapnum).Npc(index).x * 32, MapNpc(mapnum).Npc(index).y * 32
                    MapNpc(mapnum).Npc(index).Vital(Vitals.MP) = MapNpc(mapnum).Npc(index).Vital(Vitals.MP) + Spell(.Spell).Vital
                End If
                .Timer = GetTickCount
                ' check if DoT is still active - if NPC died it'll have been purged
                If .Used And .Spell > 0 Then
                    ' destroy hoT if finished
                    If GetTickCount - .StartTime >= (Spell(.Spell).Duration * 1000) Then
                        .Used = False
                        .Spell = 0
                        .Timer = 0
                        .Caster = 0
                        .StartTime = 0
                    End If
                End If
            End If
        End If
    End With
End Sub

Public Sub StunPlayer(ByVal index As Long, ByVal spellnum As Long)
    ' check if it's a stunning spell
    If Spell(spellnum).StunDuration > 0 Then
        ' set the values on index
        TempPlayer(index).StunDuration = Spell(spellnum).StunDuration
        TempPlayer(index).StunTimer = GetTickCount
        ' send it to the index
        SendStunned index
        ' tell him he's stunned
        PlayerMsg index, "You have been stunned.", BrightRed
    End If
End Sub

Public Sub StunNPC(ByVal index As Long, ByVal mapnum As Long, ByVal spellnum As Long)
    ' check if it's a stunning spell
    If Spell(spellnum).StunDuration > 0 Then
        ' set the values on index
        MapNpc(mapnum).Npc(index).StunDuration = Spell(spellnum).StunDuration
        MapNpc(mapnum).Npc(index).StunTimer = GetTickCount
    End If
End Sub

