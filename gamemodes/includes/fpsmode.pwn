/*
    เพิ่มเติม: http://forum.script-wise.in.th/viewtopic.php?f=3&t=20
*/
#include <YSI\y_hooks>

new FPSObject[MAX_PLAYERS]; // Credit: Akatah (forum.script-wise.in.th)
new bool:isFPSOn[MAX_PLAYERS];

CMD:fpsmode(playerid, params[]) {
    if(!isFPSOn[playerid])
    {
        FPSObject[playerid] = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0); // สร้าง Object ขึ้นมาและเก็บไว้ที่ FPSObject
        AttachObjectToPlayer(FPSObject[playerid],playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0); // ติด Object จาก FPSObject ไปยังไอดีผู้เล่นที่กดใช้คำสั่ง
        AttachCameraToObject(playerid, FPSObject[playerid]); // ติดมุมมองของกลุ้องผู้เล่นไว้ที่ตัวแปร FPSObject ที่เก็บ Object ที่สร้างไว้
        SendClientMessage(playerid,-1,"คุณได้เปิดโหมด FPS แล้ว (พิมพ์อีกครั้งเพื่อปิด)");
        isFPSOn[playerid]=true;
    }
    else
    {
        SetCameraBehindPlayer(playerid); // ปรับกล้องมาไว้ที่หลังผู้เล่นเหมือนเดิม
        DestroyObject(FPSObject[playerid]); // ลบ Object ที่สร้างทิ้ง
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
