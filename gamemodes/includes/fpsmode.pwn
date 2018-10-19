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
        SendClientMessage(playerid,-1,"คุณได้เปิดโหมด FPS แล้ว (พิมพ์อีกครั้งเพื่อปิด)");
        isFPSOn[playerid]=true;
    }
    else
    {
        SetCameraBehindPlayer(playerid);
        DestroyObject(FPSObject[playerid]);
        SendClientMessage(playerid,-1,"คุณได้ปิดโหมด FPS แล้ว !");
        isFPSOn[playerid]=false;
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) { // ถ้าไม่ได้ใช้ y_hook ให้เอาโค้ดด้านล่างไปใส่ใน Callback OnPlayerDisconnect
    if(isFPSOn[playerid]) {
	    DestroyObject(FPSObject[playerid]);
    }
    isFPSOn[playerid]=false;
    return 1;
}
