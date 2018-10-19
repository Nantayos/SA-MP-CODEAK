/*

*/
#include <YSI\y_hooks>

new FPSObject[MAX_PLAYERS]; // Credit: Akatah (forum.script-wise.in.th)
new bool:isFPSOn[MAX_PLAYERS];

CMD:fpsmode(playerid, params[]) {
    if(!isFPSOn[playerid])
    {
        FPSObject[playerid] = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        AttachObjectToPlayer(FPSObject[playerid],playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
        AttachCameraToObject(playerid, FPSObject[playerid]);
        SendClientMessage(playerid,-1,"�س���Դ���� FPS ���� (������ա�������ͻԴ)");
        isFPSOn[playerid]=true;
    }
    else
    {
        SetCameraBehindPlayer(playerid);
        DestroyObject(FPSObject[playerid]);
        SendClientMessage(playerid,-1,"�س��Դ���� FPS ���� !");
        isFPSOn[playerid]=false;
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) { // ���������� y_hook �������鴴�ҹ��ҧ����� Callback OnPlayerDisconnect
    if(isFPSOn[playerid]) {
	    DestroyObject(FPSObject[playerid]);
    }
    isFPSOn[playerid]=false;
    return 1;
}
