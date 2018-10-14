#include <a_samp>
#include <crashdetect>   // Zeex/samp-plugin-crashdetect
#include <foreach> // Open-GTO/foreach:v19.0
#include <sscanf2> // maddinat0r/sscanf:v2.8.2
#include <streamer>      // samp-incognito/samp-streamer-plugin
#include <easyDialog> // Awsomedude/easyDialog:2.0
#include <a_mysql> // pBlueG/SA-MP-MySQL
#include <Pawn.CMD> // urShadow/Pawn.CMD
#include <CEFix>   // aktah/SAMP-CEFix
#include <dl-compat> // AGraber/samp-dl-compat

#define MYSQL_HOSTNAME		"localhost"
#define MYSQL_USERNAME		"root"
#define MYSQL_PASSWORD		"root"
#define MYSQL_DATABASE		"codeak"

new
	MySQL: Database,
	PlayerName[MAX_PLAYERS][30],
	PlayerIP[MAX_PLAYERS][17]
;

native WP_Hash(buffer[], len, const str[]);

enum PlayerData
{
	ID,
	Password[129],
	Cash,
	Kills,
	Deaths
};
new PlayerInfo[MAX_PLAYERS][PlayerData];

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
	return 1;
}

public OnPlayerConnect(playerid)
{
	new query[140];
	GetPlayerName(playerid, PlayerName[playerid], 30);
	GetPlayerIp(playerid, PlayerIP[playerid], 16);

	mysql_format(Database, query, sizeof(query), "SELECT `Password`, `ID` FROM `users` WHERE `Username` = '%e' LIMIT 0, 1", PlayerName[playerid]); // We are selecting the password and the ID from the player's name
	mysql_tquery(Database, query, "CheckPlayer", "i", playerid);
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
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "{FF0000}รหัสผ่านไม่ถูกต้อง!\n{FFFFFF}Type your correct password below to continue and sign in to your account", "เข้าสู่ระบบ", "ออกจากเกมส์");
	}
	return 1;
}

Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Kick(playerid);

	if(strlen(inputtext) < 3) return Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "{FF0000}รหัสผ่านสั้นเกินไป!\n{FFFFFF}ต้องใช้รหัสผ่านที่มีความยาวตั้งแต่ 3 ตัวขึ้นไป", "สมัครสมาชิก", "ออกจากเกมส์");

	new query[300];
	WP_Hash(PlayerInfo[playerid][Password], 129, inputtext);
	mysql_format(Database, query, sizeof(query), "INSERT INTO `users` (`Username`, `Password`, `IP`, `Cash`, `Kills`, `Deaths`) VALUES ('%e', '%e', '%e', 0, 0, 0)", PlayerName[playerid], PlayerInfo[playerid][Password], PlayerIP[playerid]);

	mysql_pquery(Database, query, "RegisterPlayer", "i", playerid);
	return 1;
}

forward CheckPlayer(playerid);
public CheckPlayer(playerid)
{
	new rows, string[150];
	cache_get_row_count(rows);

	if(rows)
	{
		cache_get_value_name(0, "Password", PlayerInfo[playerid][Password], 129); 
		cache_get_value_name_int(0, "ID", PlayerInfo[playerid][ID]);
		format(string, sizeof(string), "ยินดีต้อนรับกลับ\nโปรดกรอกรหัสผ่านด้านล่างเพื่อเข้าสู่ระบบ"); 
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", string, "เข้าสู่ระบบ", "ออกจากเกมส์");
	}
	else
	{	
		format(string, sizeof(string), "ยินดีต้อนรับเข้าสู่เซิร์ฟเวอร์ของเรา\nคุณจำเป็นต้องลงทะเบียนก่อนหากต้องการเข้าเล่น โดยพิมพ์รหัสผ่านของคุณด้านล่างนี้:");
		Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", string, "สมัครสมาชิก", "ออกจากเกมส์");
	}
	return 1;
}

forward LoadPlayer(playerid);
public LoadPlayer(playerid)
{
	cache_get_value_name_int(0, "Cash", PlayerInfo[playerid][Cash]);
	cache_get_value_name_int(0, "Kills", PlayerInfo[playerid][Kills]);
	cache_get_value_name_int(0, "Deaths", PlayerInfo[playerid][Deaths]);

	GivePlayerMoney(playerid, PlayerInfo[playerid][Cash]);
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
	return 1;
}
