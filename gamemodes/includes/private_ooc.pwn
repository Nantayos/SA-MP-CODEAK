/*
    �к����ӧҹ�����Ѻ...

    [PLUGIN] 
    - CEFix: https://github.com/aktah/SAMP-CEFix/releases

    [INCLUDE]
    - easyDialog: https://forum.sa-mp.com/showthread.php?t=475838
    - PAWN.CMD: (�Ҩ�� zcmd ᷹����������������� OnPlayerCommandText ��������ҧ � ������¹����������)

    ��ԧ�����ö�Ѵ�ŧ�ͧ�������繵�ͧ�շء���ҧ�����ҹ��

    ** ¡��� Plugin CEFix �Ҵ���������ѹ�� Highlight �ͧ�к���� !

    CE_Convert // �ŧ��ͤ������ç�Ѻ�� (��������¡��Ѻ������µç�Ҩ�����������͹ �й�������ҧ����� String ���������ѧ������ҧ��ҹ��ҧ)
*/

CMD:customooc(playerid, params[]) {
    ShowPlayerCustomOOC(playerid);
    return 1;
}

CMD:ooc(playerid, params[]) {

	if(isnull(params)) // ��Ǩ�ͺ��� parameter ��������բ�������� �Ҩ�� strlen(params) ᷹�ѹ��
	{
		SendClientMessage(playerid, -1, "�Ը���: /ooc [��ͤ���]");
		return 1;
	}
    new string[144], text[91], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
    format(text, sizeof text, PlayerInfo[playerid][pAkOOC]);

    format(string, sizeof string, "%s%s{FFFFFF}: %s", text, playername, params); // ������ҧ string �� format ����������������繵�ͧ���¡�� CE �ء � ���駷����������������
    CE_Convert(string);

    foreach(new i : Player) { // �ٻ�Ҽ����蹷����� ������ for �����ҡ����� foreach
        SendClientMessage(i, -1, string);
    }
    return 1;
}
alias:ooc("o");

ShowPlayerCustomOOC(playerid) {
    new str[144], text[90 + MAX_PLAYER_NAME + 1], num_color, playername[MAX_PLAYER_NAME];
    
    GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
    format(text, sizeof text, "%s%s", PlayerInfo[playerid][pAkOOC], playername);
    CE_Convert(text);
    num_color = CE_CountTag(text);

    format(str, sizeof str, "����\t��������´\n��ͤ���\t%s\n�ӹǹ��\t%d\n���ͺ\t", text, num_color);
    Dialog_Show(playerid, CustomOOC, DIALOG_STYLE_TABLIST_HEADERS, "�к� OOC Ẻ��˹��ͧ", str, "���͡", "¡��ԡ");
    return 1;
}

Dialog:CustomOOC(playerid, response, listitem, inputtext[])
{
    if(response) {
        switch(listitem) {
            case 0: { // ��䢢�ͤ���
                Dialog_Show(playerid, EditCustomOOC, DIALOG_STYLE_INPUT, "��Ѻ�� OOC ��ǹ���", "��¹��ͤ�������ͧ��ô�ҹ��ҧ���:", "��Ѻ��", "¡��ԡ");
            }
            case 2: { // ���ͺ
                new text[91], playername[MAX_PLAYER_NAME];
                GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
                format(text, sizeof text, PlayerInfo[playerid][pAkOOC]);

                CE_SendClientMessage(playerid, -1, "%s%s{FFFFFF}: %s", text, playername, "������跴�ͺ��˹��� !!");

                ShowPlayerCustomOOC(playerid);
            }
            default: {
                ShowPlayerCustomOOC(playerid);
            }
        }
    }
	return 1;
}

Dialog:EditCustomOOC(playerid, response, listitem, inputtext[])
{
    if(!response)
        return ShowPlayerCustomOOC(playerid);

    new len = strlen(inputtext);
    if(len >= 90 || len <= 0) {
        new str[128];
        format(str, sizeof str, "{DC143C}ERROR:{FFFFFF} ��������������ͧ����Թ{FFD700} 90 {FFFFFF}����ѡ��\n\n��¹��ͤ�������ͧ��ô�ҹ��ҧ���:");
        CE_Convert(str);
        Dialog_Show(playerid, EditCustomOOC, DIALOG_STYLE_INPUT, "��Ѻ�� OOC ��ǹ���", str, "��Ѻ��", "¡��ԡ");
        return 1;
    }

    format(PlayerInfo[playerid][pAkOOC], 91, "%s ", inputtext);
    return ShowPlayerCustomOOC(playerid);
}