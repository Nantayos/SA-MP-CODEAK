
#include <a_samp>
#include <crashdetect>   // Zeex/samp-plugin-crashdetect
#include <foreach> // Open-GTO/foreach:v19.0
#include <sscanf2> // maddinat0r/sscanf:v2.8.2
#include <streamer>      // samp-incognito/samp-streamer-plugin
#include <easyDialog> // Awsomedude/easyDialog:2.0
#include <a_mysql> // pBlueG/SA-MP-MySQL
#include <Pawn.CMD> // urShadow/Pawn.CMD
#include <dl-compat> // AGraber/samp-dl-compat
#include <CEFix>   // aktah/SAMP-CEFix

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
	Deaths
};
new PlayerInfo[MAX_PLAYERS][PlayerData];

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
		new str[80];
		format(str, sizeof(str), "{FF0000}���ʼ�ҹ���١��ͧ!\n{FFFFFF}�ô��͡���ʼ�ҹ��ҹ��ҧ�����������к�");
		CE_Convert(str);
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", str, "�������к�", "�͡�ҡ����");
	}
	return 1;
}

Dialog:DIALOG_REGISTER(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Kick(playerid);

	if(strlen(inputtext) < 3) {
		new str[144];
		format(str, sizeof(str), "{FF0000}���ʼ�ҹ����Թ�!\n{FFFFFF}��ͧ�����ʼ�ҹ����դ�����ǵ���� 3 ��Ǣ���");
		CE_Convert(str);
		return Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", str, "��Ѥ���Ҫԡ", "�͡�ҡ����");
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
	new rows, string[150];
	cache_get_row_count(rows);

	if(rows)
	{
		cache_get_value_name(0, "Password", PlayerInfo[playerid][Password], 129); 
		cache_get_value_name_int(0, "ID", PlayerInfo[playerid][ID]);
		format(string, sizeof(string), "�Թ�յ�͹�Ѻ��Ѻ\n�ô��͡���ʼ�ҹ��ҹ��ҧ�����������к�"); 
		Dialog_Show(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", string, "�������к�", "�͡�ҡ����");
	}
	else
	{	
		format(string, sizeof(string), "�Թ�յ�͹�Ѻ���������������ͧ���\n�س���繵�ͧŧ����¹��͹�ҡ��ͧ��������� �¾�������ʼ�ҹ�ͧ�س��ҹ��ҧ���:");
		Dialog_Show(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", string, "��Ѥ���Ҫԡ", "�͡�ҡ����");
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
	SetPlayerPos(playerid, 0, 0, 3);

	CE_SendClientMessage(playerid, -1, "{ff0000}�Թ��{ff0040}��͹�Ѻ{ff0080}������{ff00bf}��������� {ff8000}SA-MP CODEAK");
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        SendClientMessage(playerid, -1, "{00FFFF}ERROR: {FFFFFF}�Դ��ͼԴ��Ҵ㹡��������");
        return 0;
    }
    return 1;
}

CMD:3d(playerid, params[]) {
	new Float:PosX, Float:PosY, Float:PosZ;
	GetPlayerPos(playerid, PosX, PosY, PosZ);

	new string[144];
	format(string, sizeof(string), "Dynamic 3DText: {ff0000}�Թ��{ff0040}��͹�Ѻ{ff0080}������{ff00bf}��������� {ff8000}SA-MP CODEAK");
	CreateDynamic3DTextLabel(string, -1, PosX, PosY, PosZ, 20.0);
	return 1;
}

CMD:fix3d(playerid, params[]) {
	new Float:PosX, Float:PosY, Float:PosZ;
	GetPlayerPos(playerid, PosX, PosY, PosZ);

	new string[144];
	format(string, sizeof(string), "Fix Dynamic 3DText: {ff0000}�Թ��{ff0040}��͹�Ѻ{ff0080}������{ff00bf}��������� {ff8000}SA-MP CODEAK");
	CE_Convert(string);
	CreateDynamic3DTextLabel(string, -1, PosX, PosY, PosZ, 20.0);
	return 1;
}