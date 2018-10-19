/*
    ระบบนี้ทำงานร่วมกับ...

    [PLUGIN] 
    - CEFix: https://github.com/aktah/SAMP-CEFix/releases

    [INCLUDE]
    - easyDialog: https://forum.sa-mp.com/showthread.php?t=475838
    - PAWN.CMD: (อาจใช้ zcmd แทนได้หรือแก้ไขให้อยู่ใน OnPlayerCommandText มีเวลาว่าง ๆ จะมาเขียนเผื่อไว้ให้)

    จริงๆสามารถดัดแปลงเองได้ไม่จำเป็นต้องมีทุกอย่างตามด้านบน

    ** ยกเว้น Plugin CEFix ขาดไม่ได้เลยมันเป็น Highlight ของระบบนี้ !

    CE_Convert // แปลงข้อความให้ตรงกับสี (ไม่ควรเรียกใช้กับตัวแปรโดยตรงอาจทำให้สีเคลื่อน แนะนำให้สร้างตัวแปร String ขึ้นมาใหม่ดังตัวอย่างด้านล่าง)


    ** หมายเหตุ ล่าสุดเปลี่ยนมาใช้ CE_AUTO แปลงสีอัตโนมัติ
*/

CMD:customooc(playerid, params[]) {
    ShowPlayerCustomOOC(playerid);
    return 1;
}

CMD:ooc(playerid, params[]) {

	if(isnull(params)) // ตรวจสอบว่า parameter ที่ส่งมามีข้อมูลไหม อาจใช้ strlen(params) แทนกันได้
	{
		SendClientMessage(playerid, -1, "วิธีใช้: /ooc [ข้อความ]");
		return 1;
	}
    new string[144], text[91], playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
    format(text, sizeof text, PlayerInfo[playerid][pAkOOC]);

    format(string, sizeof string, "%s%s:{FFFFFF} %s", text, playername, params);

    foreach(new i : Player) { // ลูปหาผู้เล่นทั้งหมด หรือใช้ for ก็ได้หากไม่มี foreach
        SendClientMessage(i, -1, string);
    }
    return 1;
}
alias:ooc("o");

ShowPlayerCustomOOC(playerid) {
    new str[144], text[90 + MAX_PLAYER_NAME + 1], num_color, playername[MAX_PLAYER_NAME];
    
    GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
    format(text, sizeof text, "%s%s", PlayerInfo[playerid][pAkOOC], playername);
    num_color = CE_CountTag(text);
    format(str, sizeof str, "เมนู\tรายละเอียด\nข้อความ\t%s\nจำนวนสี\t%d\nทดสอบ\t", text, num_color);
    Dialog_Show(playerid, CustomOOC, DIALOG_STYLE_TABLIST_HEADERS, "ระบบ OOC แบบกำหนดเอง", str, "เลือก", "ยกเลิก");
    return 1;
}

Dialog:CustomOOC(playerid, response, listitem, inputtext[])
{
    if(response) {
        switch(listitem) {
            case 0: { // แก้ไขข้อความ
                Dialog_Show(playerid, EditCustomOOC, DIALOG_STYLE_INPUT, "ปรับแต่ง OOC ส่วนตัว", "เขียนข้อความที่ต้องการด้านล่างนี้:", "ปรับแต่ง", "ยกเลิก");
            }
            case 2: { // ทดสอบ
                new text[91], playername[MAX_PLAYER_NAME];
                GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
                format(text, sizeof text, PlayerInfo[playerid][pAkOOC]);

                SendClientMessage(playerid, -1, "%s%s:{FFFFFF} %s", text, playername, "ฮัลโหล่ทดสอบสีหน่อย !!");

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
    if(len >= 90) {
        Dialog_Show(playerid, EditCustomOOC, DIALOG_STYLE_INPUT, "ปรับแต่ง OOC ส่วนตัว", "{DC143C}ERROR:{FFFFFF} ความยาวโดยรวมต้องไม่เกิน{FFD700} 90 {FFFFFF}ตัวอักษร\n\nเขียนข้อความที่ต้องการด้านล่างนี้:", "ปรับแต่ง", "ยกเลิก");
        return 1;
    }
    if(len) {
        format(PlayerInfo[playerid][pAkOOC], 91, "%s ", inputtext);
    }
    else {
        PlayerInfo[playerid][pAkOOC][0] = '\0';
    }
    return ShowPlayerCustomOOC(playerid);
}