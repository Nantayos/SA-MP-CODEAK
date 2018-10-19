/*
    �������: http://forum.script-wise.in.th/viewtopic.php?f=3&t=20
*/
#include <YSI\y_hooks>

new FPSObject[MAX_PLAYERS]; // Credit: Akatah (forum.script-wise.in.th)
new bool:isFPSOn[MAX_PLAYERS];

CMD:fpsmode(playerid, params[]) {
    if(!isFPSOn[playerid])
    {
        FPSObject[playerid] = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0); // ���ҧ Object ��������������� FPSObject
        AttachObjectToPlayer(FPSObject[playerid],playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0); // �Դ Object �ҡ FPSObject ��ѧ�ʹռ����蹷�衴������
        AttachCameraToObject(playerid, FPSObject[playerid]); // �Դ����ͧ�ͧ����ͧ��������������� FPSObject ����� Object ������ҧ���
        SendClientMessage(playerid,-1,"�س���Դ���� FPS ���� (������ա�������ͻԴ)");
        isFPSOn[playerid]=true;
    }
    else
    {
        SetCameraBehindPlayer(playerid); // ��Ѻ���ͧ���������ѧ����������͹���
        DestroyObject(FPSObject[playerid]); // ź Object ������ҧ���
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
