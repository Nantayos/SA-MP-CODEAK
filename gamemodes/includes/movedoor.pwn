/*
    - MoveDoor Dynamic (ระบบประตูเลื่อน Dynamic)

    ความสามารถของระบบ

    - สามารถสร้างประตูเลื่อนได้ภายในเกม (ไม่จำเป็นต้องรีเซิร์ฟเวอร์หรือสร้างประตูภายใน Gamemode)
    - สามารถแก้ไข,จัดการประตูเลื่อนได้ภายในเกม (บันทึกข้อมูลผ่าน SQL)
    - สามารถประยุกต์ใช้ได้กับเซิร์ฟเวอร์ทุกแนว (DM-RolePlay)

    BUGGED
    - หากพบบัคของตัวระบบสามารถติดต่อ Nantayos เพื่อการแก้ไข

    Credit : SC:RP (สำหรับแนวทางในการพัฒนาระบบนี้ขึ้นมา)
    Credit : Akatah (สำหรับคำสั่งของระบบ MoveDoor Dynamic)
*/

#include <YSI\y_hooks

#define MAX_DOOR (50)

enum doorInfo {
	DoorID,
	DoorExists,
	DoorOpened,
	Float:DoorRadius,
	DoorModel,
	Float:DoorSpeed,
	DoorTime,
	Float:DoorPos[6],
	DoorInterior,
	DoorWorld,
	Float:DoorMove[6],
	DoorFaction,
    DoorObject,
	DoorTimer,
	DoorMessage[32],
};

new DoorInfo[MAX_DOOR][doorInfo];

// COMMANDS ของระบบประตูเลื่อน Dynamic

CMD:movedoorcmds(playerid, params[])
{
    SendClientMessage(playerid, 0xAFAFAFAA, "[DYNAMIC MOVEDOOR]: /makemovedoor /removemovedoor /editmovedoor /whatmovedoor /gotomovedoors");

	return 1;
}

CMD:makemovedoor(playerid, params[])
{
    new
        id = -1,
        modelid,
        factionid,
        description[24],
        string[128];

    if (sscanf(params, "dds[32]", modelid, factionid, description))
    {
        return SendClientMessage(playerid, 0xAFAFAFAA, "/makemovedoor [modelid] [Faction(/viewgroups)] [Description]");
    }

    id = Door_Create(playerid, modelid, factionid);

	DoorInfo[id][DoorModel] = modelid;
	DoorInfo[id][DoorFaction] = factionid;
	
	format(DoorInfo[id][DoorMessage], 32, "%s", description);

    format(string, sizeof(string), "ประตูเลื่อนใหม่ถูกเพิ่ม [DoorID: %d, ModelID: %d, Description: %s]", id, modelid, description);
    SendClientMessage(playerid, 0x12900BBF, string);

	return 1;
}

CMD:editmovedoor(playerid, params[])
{
    new
        id = -1,
        type,
        string[128];

    if (sscanf(params, "dd", id, type))
    {
        return SendClientMessage(playerid, 0xAFAFAFAA, "/editmovedoor [doorid] [เลือกหมายเลข(1-ตำแหน่ง,2-เลื่อน,3-ความเร็ว(2.5 ค่าปกติ),4-ชื่อที่แสดง,5-กลุ่ม)]");
    }

    if (type == 1)
    {
        ResetEditing(playerid);
    
        EditDynamicObject(playerid, DoorInfo[id][DoorObject]);
        
  		EditGate[playerid] = id;
		EditType[playerid] = 1;
    }
    
    else if (type == 2)
    {
        ResetEditing(playerid);
    
        EditDynamicObject(playerid, DoorInfo[id][DoorObject]);

  		EditGate[playerid] = id;
		EditType[playerid] = 2;
    }
    
    else if (type == 3)
    {
	    new
	        Float:speed;
	        
		if (sscanf(params, "ddf", id, type, speed))
		    return SendClientMessage(playerid, 0xAFAFAFAA, "/editmovedoor [doorid] [3] [ความเร็วของการเลื่อนประตู]");
		
        DoorInfo[id][DoorSpeed] = speed;

		format(string, sizeof(string), "คุณแก้ไขความเร็วของการเปิดเป็น %f", speed);
	    SendClientMessage(playerid, 0x12900BBF, string);
	    
		Door_Save(playerid);
    }
    
    else if (type == 4)
    {
	    new
	        description[32];

		if (sscanf(params, "dds[32]", id, type, description))
		    return SendClientMessage(playerid, 0xAFAFAFAA, "/editmovedoor [doorid] [4] [ชื่อของประตู]");

		format(DoorInfo[id][DoorMessage], 32, "%s", description);

		format(string, sizeof(string), "คุณแก้ไขชื่อของประตูเป็น %s !", description);
	    SendClientMessage(playerid, 0x12900BBF, string);
	    
	    Door_Save(playerid);
    }
    
    else if (type == 5)
    {
	    new
	        factionid = -1;

		if (sscanf(params, "ddd", id, type, factionid))
		    return SendClientMessage(playerid, 0xAFAFAFAA, "/editmovedoor [doorid] [5] [กำหนด FACTION ของประตูเลื่อน (หรือใส่ -1 เพื่อตั้งให้ใช้ได้ทุกคน)]");

		if (factionid == -1)
		{
		    DoorInfo[id][DoorFaction] = -1;
		    SendClientMessage(playerid, -0x12900BBF, "คุณแก้ไขให้ประตูเลื่อนใช้ได้ทุกคน !");

            Door_Save(playerid);
		}
		
		else if (factionid >= 1)
		{
		    DoorInfo[id][DoorFaction] = factionid;
		    
		    format(string, sizeof(string), "คุณแก้ไขให้ประตูเลื่อนใช้ได้สำหรับ FactionID : %d !", factionid);
		    SendClientMessage(playerid, 0x12900BBF, string);
		    
		    Door_Save(playerid);
		}
    }

	return 1;
}

CMD:removemovedoor(playerid, params[])
{
	new
	    id = 0,
	    string[128];

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, 0xAFAFAFAA, "/removedoor [doorid]");

	MoveDoor_Remove(id);
	
	format(string, sizeof(string), "คุณได้ลบประตูเลื่อนไอดี %d เรียบร้อยแล้ว !", id);
	SendClientMessage(playerid, 0x12900BBF, string);

	return 1;
}

CMD:whatmovedoor(playerid, params[])
{
	new
	    id = -1,
	    string[128];

    if ((id = MoveDoor_Around(playerid)) != -1)
	{
		format(string, sizeof(string), "คุณอยู่ใกล้กับประตูเลื่อนไอดี %d !", id);
		SendClientMessage(playerid, 0x12900BBF, string);
	}

	return 1;
}

CMD:gotomovedoors(playerid, params[])
{
	new
	    string[128],
	    id;

	if (sscanf(params, "d", id))
	    return SendClientMessage(playerid, 0xAFAFAFAA, "/gotomovedoors [doorid]");

	SetPlayerPos(playerid, DoorInfo[id][DoorPos][0] - (2.5 * floatsin(-DoorInfo[id][DoorPos][3], degrees)), DoorInfo[id][DoorPos][1] - (2.5 * floatcos(-DoorInfo[id][DoorPos][3], degrees)), DoorInfo[id][DoorPos][2]);
	SetPlayerInterior(playerid, DoorInfo[id][DoorInterior]);

	SetPlayerVirtualWorld(playerid, DoorInfo[id][DoorWorld]);

    format(string, sizeof(string), "คุณได้เคลื่อนย้ายไปที่ประตูเลื่่อนไอดี %d", id);
	SendClientMessage(playerid, 0xFFFF00AA, string);

	return 1;
}

CMD:door(playerid, params[])
{
	new id = MoveDoor_Around(playerid);

	if (id != -1)
	{
		Door_Opened(id);
	}

	return 1;
}

//////////////////////////////////////

hook OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	new string[128];

	if (response == EDIT_RESPONSE_FINAL)
	{
	    if (EditGate[playerid] != -1 && DoorInfo[EditGate[playerid]][DoorExists])
	    {
	        switch (PlayerInfo[playerid][pEditType])
	        {
	            case 1:
	            {
	                new id = EditGate[playerid];

	                DoorInfo[id][DoorPos][0] = x;
	                DoorInfo[id][DoorPos][1] = y;
	                DoorInfo[id][DoorPos][2] = z;
	                DoorInfo[id][DoorPos][3] = rx;
	                DoorInfo[id][DoorPos][4] = ry;
	                DoorInfo[id][DoorPos][5] = rz;

	                DestroyDynamicObject(DoorInfo[id][DoorObject]);
					DoorInfo[id][DoorObject] = CreateDynamicObject(DoorInfo[id][DoorModel], DoorInfo[id][DoorPos][0], DoorInfo[id][DoorPos][1], DoorInfo[id][DoorPos][2], DoorInfo[id][DoorPos][3], DoorInfo[id][DoorPos][4], DoorInfo[id][DoorPos][5], DoorInfo[id][DoorWorld], DoorInfo[id][DoorInterior]);

					format(string, sizeof(string), "SERVER: เสร็จสิ้นการแก้ไขตำแหน่งประตูเลื่อนแล้ว %f %f %f", x, y, z);
				    SendClientMessage(playerid, 0xFFFF00AA, string);

					Door_Save(id);
				}
				case 2:
	            {
	                new id = EditGate[playerid];

	                DoorInfo[id][DoorMove][0] = x;
	                DoorInfo[id][DoorMove][1] = y;
	                DoorInfo[id][DoorMove][2] = z;
	                DoorInfo[id][DoorMove][3] = rx;
	                DoorInfo[id][DoorMove][4] = ry;
	                DoorInfo[id][DoorMove][5] = rz;

	                DestroyDynamicObject(DoorInfo[id][DoorObject]);
					DoorInfo[id][DoorObject] = CreateDynamicObject(DoorInfo[id][DoorModel], DoorInfo[id][DoorPos][0], DoorInfo[id][DoorPos][1], DoorInfo[id][DoorPos][2], DoorInfo[id][DoorPos][3], DoorInfo[id][DoorPos][4], DoorInfo[id][DoorPos][5], DoorInfo[id][DoorWorld], DoorInfo[id][DoorInterior]);

					format(string, sizeof(string), "SERVER: เสร็จสิ้นการแก้ไขตำแหน่งการเลื่อนของประตูเลื่อนแล้ว %f %f %f", x, y, z);
				    SendClientMessage(playerid, 0xFFFF00AA, string);

					Door_Save(id);
 				}
			}
		}
	}

	return 1;
}

stock Door_Create(playerid, modelid, factionid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;
		//query[128];

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_DOOR; i ++) if (!DoorInfo[i][DoorExists])
		{
		    DoorInfo[i][DoorExists] = true;
			DoorInfo[i][DoorSpeed] = 3.0;
			DoorInfo[i][DoorOpened] = 0;
			DoorInfo[i][DoorTime] = 0;

			DoorInfo[i][DoorRadius] = 5.0;
			
			format(DoorInfo[i][DoorMessage], 32, "(null)");

		    DoorInfo[i][DoorModel] = modelid;
		    DoorInfo[i][DoorFaction] = factionid;

			DoorInfo[i][DoorPos][0] = x + (3.0 * floatsin(-angle, degrees));
			DoorInfo[i][DoorPos][1] = y + (3.0 * floatcos(-angle, degrees));
			DoorInfo[i][DoorPos][2] = z;
			DoorInfo[i][DoorPos][3] = 0.0;
			DoorInfo[i][DoorPos][4] = 0.0;
			DoorInfo[i][DoorPos][5] = angle;

			DoorInfo[i][DoorMove][0] = x + (3.0 * floatsin(-angle, degrees));
			DoorInfo[i][DoorMove][1] = y + (3.0 * floatcos(-angle, degrees));
			DoorInfo[i][DoorMove][2] = z - 10.0;
			DoorInfo[i][DoorMove][3] = -1000.0;
			DoorInfo[i][DoorMove][4] = -1000.0;
			DoorInfo[i][DoorMove][5] = -1000.0;

            DoorInfo[i][DoorInterior] = GetPlayerInterior(playerid);
            DoorInfo[i][DoorWorld] = GetPlayerVirtualWorld(playerid);

            DoorInfo[i][DoorObject] = CreateDynamicObject(DoorInfo[i][DoorModel], DoorInfo[i][DoorPos][0], DoorInfo[i][DoorPos][1], DoorInfo[i][DoorPos][2], DoorInfo[i][DoorPos][3], DoorInfo[i][DoorPos][4], DoorInfo[i][DoorPos][5], DoorInfo[i][DoorWorld], DoorInfo[i][DoorInterior]);

			mysql_tquery(g_SQL, "INSERT INTO `doors` (`DoorModel`) VALUES(980)", "OnDoorCreated", "d", i);


            return i;
		}
	}
	return -1;
}

stock MoveDoor_Remove(doorid)
{
	if (doorid != -1 && DoorInfo[doorid][DoorExists])
	{
		new
		    query[64];

		format(query, sizeof(query), "DELETE FROM `doors` WHERE `DoorID` = '%d'", DoorInfo[doorid][DoorID]);
		mysql_tquery(g_SQL, query);

		if (IsValidDynamicObject(DoorInfo[doorid][DoorObject]))
		    DestroyDynamicObject(DoorInfo[doorid][DoorObject]);

		for (new i = 0; i != MAX_DOOR; i ++) if (DoorInfo[i][DoorExists]) {
		    Door_Save(i);
		}
		
		if (DoorInfo[doorid][DoorOpened] && DoorInfo[doorid][DoorTime] > 0) {
		    KillTimer(DoorInfo[doorid][DoorTimer]);
		}
		
	    DoorInfo[doorid][DoorExists] = false;
	    DoorInfo[doorid][DoorID] = 0;
	    DoorInfo[doorid][DoorOpened] = 0;
	}
	return 1;
}


stock Door_Save(doorid)
{
	new
	    query[768];

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `doors` SET `DoorModel` = '%d', `DoorSpeed` = '%.4f', `DoorRadius` = '%.4f', `DoorX` = '%.4f', `DoorY` = '%.4f', `DoorZ` = '%.4f', `DoorRX` = '%.4f', `DoorRY` = '%.4f', `DoorRZ` = '%.4f' WHERE `DoorID` = '%d'",
	    DoorInfo[doorid][DoorModel],
	    DoorInfo[doorid][DoorSpeed],
	    DoorInfo[doorid][DoorRadius],
	    DoorInfo[doorid][DoorPos][0],
	    DoorInfo[doorid][DoorPos][1],
	    DoorInfo[doorid][DoorPos][2],
	    DoorInfo[doorid][DoorPos][3],
	    DoorInfo[doorid][DoorPos][4],
	    DoorInfo[doorid][DoorPos][5],
	    DoorInfo[doorid][DoorID]
	);
	mysql_tquery(g_SQL, query);

	mysql_format(g_SQL, query, sizeof(query), "UPDATE `doors` SET `DoorInterior` = '%d', `DoorWorld` = '%d', `DoorMoveX` = '%.4f', `DoorMoveY` = '%.4f', `DoorMoveZ` = '%.4f', `DoorMoveRX` = '%.4f', `DoorMoveRY` = '%.4f', `DoorMoveRZ` = '%.4f', `DoorFaction` = '%d' WHERE `DoorID` = '%d'",

	    DoorInfo[doorid][DoorInterior],
	    DoorInfo[doorid][DoorWorld],
	    DoorInfo[doorid][DoorMove][0],
	    DoorInfo[doorid][DoorMove][1],
	    DoorInfo[doorid][DoorMove][2],
	    DoorInfo[doorid][DoorMove][3],
	    DoorInfo[doorid][DoorMove][4],
	    DoorInfo[doorid][DoorMove][5],
	    DoorInfo[doorid][DoorFaction],
	    DoorInfo[doorid][DoorID]
	);
	
	format(DoorInfo[doorid][DoorMessage], 32, "%s", DoorInfo[doorid][DoorMessage]);
	mysql_tquery(g_SQL, query);

	return 1;
}

stock MoveDoor_Around(playerid)
{
    for (new i = 0; i != MAX_DOOR; i ++) if (DoorInfo[i][DoorExists] && IsPlayerInRangeOfPoint(playerid, DoorInfo[i][DoorRadius], DoorInfo[i][DoorPos][0], DoorInfo[i][DoorPos][1], DoorInfo[i][DoorPos][2]))
	{
		if (GetPlayerInterior(playerid) == DoorInfo[i][DoorInterior] && GetPlayerVirtualWorld(playerid) == DoorInfo[i][DoorWorld])
			return i;
	}
	return -1;
}

forward Door_Loading();
public Door_Loading()
{
	new rows, fields;

	cache_get_row_count(rows);
	cache_get_field_count(fields);

	for (new i = 0; i < rows; i ++) if (i < MAX_DOOR)
	{
	    DoorInfo[i][DoorExists] = true;
	    DoorInfo[i][DoorOpened] = false;

		cache_get_value_name(0, "DoorMessage", DoorInfo[i][DoorMessage]);

	    cache_get_value_name_int(i, "DoorID", DoorInfo[i][DoorID]);
	    cache_get_value_name_int(i, "DoorModel", DoorInfo[i][DoorModel]);
	    cache_get_value_name_float(i, "DoorSpeed", DoorInfo[i][DoorSpeed]);
	    cache_get_value_name_float(i, "DoorRadius", DoorInfo[i][DoorRadius]);
	    cache_get_value_name_int(i, "DoorInterior", DoorInfo[i][DoorInterior]);
	    cache_get_value_name_int(i, "DoorWorld", DoorInfo[i][DoorWorld]);

	    cache_get_value_name_float(i, "DoorX", DoorInfo[i][DoorPos][0]);
	    cache_get_value_name_float(i, "DoorY", DoorInfo[i][DoorPos][1]);
	    cache_get_value_name_float(i, "DoorZ", DoorInfo[i][DoorPos][2]);
	    cache_get_value_name_float(i, "DoorRX", DoorInfo[i][DoorPos][3]);
	    cache_get_value_name_float(i, "DoorRY", DoorInfo[i][DoorPos][4]);
	    cache_get_value_name_float(i, "DoorRZ", DoorInfo[i][DoorPos][5]);

        cache_get_value_name_float(i, "DoorMoveX", DoorInfo[i][DoorMove][0]);
	    cache_get_value_name_float(i, "DoorMoveY", DoorInfo[i][DoorMove][1]);
	    cache_get_value_name_float(i, "DoorMoveZ", DoorInfo[i][DoorMove][2]);
	    cache_get_value_name_float(i, "DoorMoveRX", DoorInfo[i][DoorMove][3]);
	    cache_get_value_name_float(i, "DoorMoveRY", DoorInfo[i][DoorMove][4]);
	    cache_get_value_name_float(i, "DoorMoveRZ", DoorInfo[i][DoorMove][5]);

	    cache_get_value_name_int(i, "DoorFaction", DoorInfo[i][DoorFaction]);
	    DoorInfo[i][DoorObject] = CreateDynamicObject(DoorInfo[i][DoorModel], DoorInfo[i][DoorPos][0], DoorInfo[i][DoorPos][1], DoorInfo[i][DoorPos][2], DoorInfo[i][DoorPos][3], DoorInfo[i][DoorPos][4], DoorInfo[i][DoorPos][5], DoorInfo[i][DoorWorld], DoorInfo[i][DoorInterior]);

		printf("%d Loading", i);
	}
	return 1;
}

forward OnDoorCreated(doorid);
public OnDoorCreated(doorid)
{
	if (doorid == -1 || !DoorInfo[doorid][DoorExists])
	    return 0;

	DoorInfo[doorid][DoorID] = cache_insert_id();
	Door_Save(doorid);

	return 1;
}

forward CloseGate(gateid, linkid, Float:fX, Float:fY, Float:fZ, Float:speed, Float:fRotX, Float:fRotY, Float:fRotZ);
public CloseGate(gateid, linkid, Float:fX, Float:fY, Float:fZ, Float:speed, Float:fRotX, Float:fRotY, Float:fRotZ)
{
	new id = -1;

	if (DoorInfo[gateid][DoorExists] && DoorInfo[gateid][DoorOpened])
 	{
	 	MoveDynamicObject(DoorInfo[gateid][DoorObject], fX, fY, fZ, speed, fRotX, fRotY, fRotZ);
	 	DoorInfo[gateid][DoorOpened] = 0;

	 	if ((id = GetIDSQLDoor(linkid)) != -1)
            MoveDynamicObject(DoorInfo[id][DoorObject], DoorInfo[id][DoorPos][0], DoorInfo[id][DoorPos][1], DoorInfo[id][DoorPos][2], speed, DoorInfo[id][DoorPos][3], DoorInfo[id][DoorPos][4], DoorInfo[id][DoorPos][5]);

		DoorInfo[id][DoorOpened] = 0;
		return 1;
	}
	return 0;
}

stock Door_Opened(doorid)
{
	if (doorid != -1 && DoorInfo[doorid][DoorExists])
	{
		if (!DoorInfo[doorid][DoorOpened])
		{
		    DoorInfo[doorid][DoorOpened] = true;
		    MoveDynamicObject(DoorInfo[doorid][DoorObject], DoorInfo[doorid][DoorMove][0], DoorInfo[doorid][DoorMove][1], DoorInfo[doorid][DoorMove][2], DoorInfo[doorid][DoorSpeed], DoorInfo[doorid][DoorMove][3], DoorInfo[doorid][DoorMove][4], DoorInfo[doorid][DoorMove][5]);

            if (DoorInfo[doorid][DoorTime] > 0)
			{
				DoorInfo[doorid][DoorTimer] = SetTimerEx("CloseGate", DoorInfo[doorid][DoorTime], false, "ddfffffff", doorid, DoorInfo[doorid][DoorPos][0], DoorInfo[doorid][DoorPos][1], DoorInfo[doorid][DoorPos][2], DoorInfo[doorid][DoorSpeed], DoorInfo[doorid][DoorPos][3], DoorInfo[doorid][DoorPos][4], DoorInfo[doorid][DoorPos][5]);
			}
		}
		else if (DoorInfo[doorid][DoorOpened])
		{
		    DoorInfo[doorid][DoorOpened] = false;

           	MoveDynamicObject(DoorInfo[doorid][DoorObject], DoorInfo[doorid][DoorPos][0], DoorInfo[doorid][DoorPos][1], DoorInfo[doorid][DoorPos][2], DoorInfo[doorid][DoorSpeed], DoorInfo[doorid][DoorPos][3], DoorInfo[doorid][DoorPos][4], DoorInfo[doorid][DoorPos][5]);

            if (DoorInfo[doorid][DoorTime] > 0)
			{
				KillTimer(DoorInfo[doorid][DoorTimer]);
		    }
		}
	}
	return 1;
}

stock GetIDSQLDoor(sqlid)
{
	for (new i = 0; i != MAX_DOOR; i ++) if (DoorInfo[i][DoorExists] && DoorInfo[i][DoorID] == sqlid)
	    return i;

	return -1;
}
