
#include <a_samp>

#undef  MAX_PLAYERS
#define MAX_PLAYERS (100)
 // Added
#define CE_AUTO

#include <crashdetect>   // Zeex/samp-plugin-crashdetect
#include <foreach> // Open-GTO/foreach:v19.0
#include <sscanf2> // maddinat0r/sscanf:v2.8.2
#include <streamer>      // samp-incognito/samp-streamer-plugin
#include <CEFix>   // aktah/SAMP-CEFix
#include <easyDialog> // Awsomedude/easyDialog:2.0
#include <a_mysql> // pBlueG/SA-MP-MySQL
#include <Pawn.CMD> // urShadow/Pawn.CMD
#include <dl-compat> // AGraber/samp-dl-compat
#include <YSI\y_hooks> // pawn-lang/YSI-Includes

#define MYSQL_HOSTNAME		"localhost"
#define MYSQL_USERNAME		"root"
#define MYSQL_PASSWORD		"root"
#define MYSQL_DATABASE		"codeak"

new
	MySQL: Database,
	PlayerName[MAX_PLAYERS][30],
	PlayerIP[MAX_PLAYERS][17]
;

native WP_Hash(buffer[], len, const str[]); // Southclaws/samp-whirlpool

enum PlayerData
{
	ID,
	Password[129],
	Cash,
	Kills,
	Deaths,
	pAkOOC[91], // +1 for spaces
	bool:isLogged
};
new PlayerInfo[MAX_PLAYERS + 1][PlayerData];

main() {}

public OnGameModeInit()
{
	new MySQLOpt: option_id = mysql_init_options();

	mysql_set_option(option_id, AUTO_RECONNECT, true);

	Database = mysql_connect(MYSQL_HOSTNAME, MYSQL_USERNAME, MYSQL_PASSWORD, MYSQL_DATABASE, option_id);
	if (Database == MYSQL_INVALID_HANDLE || mysql_errno(Database) != 0)
	{
		print("MySQL connection failed. Server is shutting down.");
		SendRconCommand("exit");
		return 1;
	}

	print("MySQL connection is successful.");

	PlayerInfo[MAX_PLAYERS][isLogged]=false;
	PlayerInfo[MAX_PLAYERS][Kills]=
	PlayerInfo[MAX_PLAYERS][Deaths]=
	PlayerInfo[MAX_PLAYERS][Cash]=
	PlayerInfo[MAX_PLAYERS][ID]=0;
	PlayerInfo[MAX_PLAYERS][pAkOOC][0]=
	PlayerInfo[MAX_PLAYERS][Password][0] = '\0';
	
	return 1;
}

public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, PlayerName[playerid], 30);
	GetPlayerIp(playerid, PlayerIP[playerid], 16);

	PlayerInfo[playerid] = PlayerInfo[MAX_PLAYERS];
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if (!PlayerInfo[playerid][isLogged])
	{
	    TogglePlayerSpectating(playerid, true);
		SetPlayerColor(playerid, 0x8D8D8DFF);
		SetTimerEx("ScreenLogin", 400, false, "i", playerid);
	}
	else {
		SpawnPlayer(playerid);
	}
	return 1;
}

forward ScreenLogin(playerid);
public ScreenLogin(playerid)
{
	if(IsPlayerConnected(playerid)) {

	    switch(random(5))
	    {
			case 0:
			{
				InterpolateCameraPos(playerid, 1515.2737,-1665.1134,30.8490, 1457.7661,-1648.8522,84.2313, 20000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 1554.5918,-1675.5037,16.1953, 1518.7808,-1740.4697,13.5469, 20000, CAMERA_MOVE);
			}
			case 1:
			{
				InterpolateCameraPos(playerid, 211.1743,-1964.6896,25.8913, 197.4750,-1931.2467,15.9717, 20000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 154.8850,-1980.1570,-1.3705, 139.8383,-1941.7241,-1.9266, 20000, CAMERA_MOVE);
			}
			case 2:
			{
				InterpolateCameraPos(playerid, 1919.1664,-1727.6240,47.0318, 1972.3707,-1748.2458,47.0318, 20000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 1939.9507,-1780.5978,13.3906, 1939.9507,-1780.5978,13.3906, 20000, CAMERA_MOVE);
			}
			case 3:
			{
				InterpolateCameraPos(playerid, 2080.5361,-1824.4825,13.3828, 2082.2178,-1781.4225,13.3828, 20000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 2103.5410,-1806.7010,13.3828, 2103.5410,-1806.7010,13.3828, 20000, CAMERA_MOVE);
			}
			case 4:
			{
				InterpolateCameraPos(playerid, 944.4015,-2283.3127,62.0990, 979.8951,-2167.8540,62.0990, 20000, CAMERA_MOVE);
				InterpolateCameraLookAt(playerid, 1086.8553,-2293.2737,43.6042, 1082.9528,-2232.9998,52.3210, 20000, CAMERA_MOVE);
			}
		}
		new query[140];
		mysql_format(Database, query, sizeof(query), "SELECT `Password`, `ID` FROM `users` WHERE `Username` = '%e' LIMIT 0, 1", PlayerName[playerid]); // We are selecting the password and the ID from the player's name
		mysql_tquery(Database, query, "CheckPlayer", "i", playerid);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SavePlayer(playerid);
}

Dialog:DIALOG_LOGIN(playerid, response, listitem, inputtext[])
{
	if(!response) 
		return Kick(playerid);

	new password[129], query[100];
	WP_Hash(password, 129, inputtext);
	if(!strcmp(password, PlayerInfo[playerid][Password]))
	{
		mysql_format(Database, query, sizeof(query), "SELECT * FROM `users` WHERE `Username` = '%e' LIMIT 0, 1", PlayerName[playerid]);
		mysql_tquery(Database, query, "LoadPlayer", "i", playerid);
	}
	else
	{
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "{FF0000}ÃËÑÊ¼èÒ¹äÁè¶Ù¡µéÍ§!\n{FFFFFF}â»Ã´¡ÃÍ¡ÃËÑÊ¼èÒ¹´éÒ¹ÅèÒ§à¾×èÍà¢éÒàÅè¹ã¹à«ÔÃì¿àÇÍÃì¢Í§àÃÒ", "à¢éÒÊÙèÃÐºº", "ÍÍ¡¨Ò¡à¡ÁÊì");
	}
	return 1;
}

Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Kick(playerid);

	if(strlen(inputtext) < 3) {
		return Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "{FF0000}ÃËÑÊ¼èÒ¹ÊÑé¹à¡Ô¹ä»!\n{FFFFFF}µéÍ§ãªéÃËÑÊ¼èÒ¹·ÕèÁÕ¤ÇÒÁÂÒÇµÑé§áµè 3 µÑÇ¢Öé¹ä»", "ÊÁÑ¤ÃÊÁÒªÔ¡", "ÍÍ¡¨Ò¡à¡ÁÊì");
	}
	new query[300];
	WP_Hash(PlayerInfo[playerid][Password], 129, inputtext);
	mysql_format(Database, query, sizeof(query), "INSERT INTO `users` (`Username`, `Password`, `IP`, `Cash`, `Kills`, `Deaths`) VALUES ('%e', '%e', '%e', 0, 0, 0)", PlayerName[playerid], PlayerInfo[playerid][Password], PlayerIP[playerid]);

	mysql_pquery(Database, query, "RegisterPlayer", "i", playerid);
	return 1;
}

forward CheckPlayer(playerid);
public CheckPlayer(playerid)
{
	new rows;
	cache_get_row_count(rows);

	if(rows)
	{
		cache_get_value_name(0, "Password", PlayerInfo[playerid][Password], 129); 
		cache_get_value_name_int(0, "ID", PlayerInfo[playerid][ID]);
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "{FFFFFF}ÂÔ¹´Õ{FFFF00}µéÍ¹ÃÑº{FFFFFF}¡ÅÑº\nâ»Ã´¡ÃÍ¡ÃËÑÊ¼èÒ¹´éÒ¹ÅèÒ§à¾×èÍà¢éÒÊÙèÃÐºº", "à¢éÒÊÙèÃÐºº", "ÍÍ¡¨Ò¡à¡ÁÊì");
	}
	else
	{	
		Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "{FFFFFF}ÂÔ¹´Õ{FFFF00}µéÍ¹ÃÑº{FFFFFF}à¢éÒÊÙè{FFFF00}à«ÔÃì¿àÇÍÃì{FFFFFF}¢Í§àÃÒ\n¤Ø³¨Óà»ç¹µéÍ§Å§·ÐàºÕÂ¹¡èÍ¹ËÒ¡µéÍ§¡ÒÃà¢éÒàÅè¹ â´Â¾ÔÁ¾ìÃËÑÊ¼èÒ¹¢Í§¤Ø³´éÒ¹ÅèÒ§¹Õé: ", "ÊÁÑ¤ÃÊÁÒªÔ¡", "ÍÍ¡¨Ò¡à¡ÁÊì");
	}
	return 1;
}

forward LoadPlayer(playerid);
public LoadPlayer(playerid)
{	
	PlayerInfo[playerid][isLogged] = true;

	cache_get_value_name_int(0, "Cash", PlayerInfo[playerid][Cash]);
	cache_get_value_name_int(0, "Kills", PlayerInfo[playerid][Kills]);
	cache_get_value_name_int(0, "Deaths", PlayerInfo[playerid][Deaths]);

	GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);

	SetSpawnInfo(playerid, NO_TEAM, 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}

forward SavePlayer(playerid);
public SavePlayer(playerid)
{
	new query[140];
	mysql_format(Database, query, sizeof(query), "UPDATE `users` SET `Cash` = '%d', `Kills` = '%d', `Deaths` = '%d' WHERE `ID` = '%d'", PlayerInfo[playerid][Cash], PlayerInfo[playerid][Kills], PlayerInfo[playerid][Deaths], PlayerInfo[playerid][ID]);

	mysql_tquery(Database, query);
	return 1;
}

forward RegisterPlayer(playerid);
public RegisterPlayer(playerid)
{
	PlayerInfo[playerid][ID] = cache_insert_id();

	new query[140];
	mysql_format(Database, query, sizeof(query), "SELECT `Password`, `ID` FROM `users` WHERE `Username` = '%e' LIMIT 0, 1", PlayerName[playerid]); // We are selecting the password and the ID from the player's name
	mysql_tquery(Database, query, "CheckPlayer", "i", playerid);
	return 1;
}

public OnPlayerSpawn(playerid) {
	TogglePlayerSpectating(playerid, false);

	if(!PlayerInfo[playerid][isLogged]) {
		return Kick(playerid);
	}

	GivePlayerWeapon(playerid, 24, 100);
	SetPlayerPos(playerid, 0, 0, 3);
	return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        SendClientMessage(playerid, -1, "{00FFFF}ERROR: {FFFFFF}à¡Ô´¢éÍ¼Ô´¾ÅÒ´ã¹¡ÒÃãªé¤ÓÊÑè§");
        return 0;
    }
    return 1;
}

#include "includes/private_ooc.pwn"
#include "includes/fpsmode.pwn"
#include "includes/movedoor.pwn" 
