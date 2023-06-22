require("model2");	-- Import model2 machine globals

function Init()
	Patch_CommsHack();
end

function Patch_Comms()
	-- A1 - jump to out patched config
	Romset_PatchDWord(0, 0x00077134, 0x09017ECC);	-- call    0008f000

	-- A2 - disable comm board now
	Romset_PatchDWord(0, 0x0008F000, 0x82A83000);
	Romset_PatchDWord(0, 0x0008F004, 0x01A14000);	-- stob    g5,0x01A14000

	-- A3 - config comm board as before
	Romset_PatchDWord(0, 0x0008F008, 0x82A03000);
	Romset_PatchDWord(0, 0x0008F00C, 0x01A10001);	-- stob    g4,0x01A10001

	-- A4 - return
	Romset_PatchDWord(0, 0x0008F010, 0x0A000000);	-- ret

	-- A5 - restore G5
	Romset_PatchDWord(0, 0x00077138, 0x8CA80000);	-- lda     0x0,g5



	-- B1 - jump to out patched check
	Romset_PatchDWord(0, 0x00076EB0, 0x09017150);	-- call    0008e000

	-- B2 - hijack g14 to read status
	Romset_PatchDWord(0, 0x0008E000, 0x80F03000);
	Romset_PatchDWord(0, 0x0008E004, 0x01A14000);	-- ldob    0x1a14000,g14

	-- B3 - check bit 0, jump if set
	Romset_PatchDWord(0, 0x0008E008, 0x3007A008);	-- bbc     0,g14,0x0008E010

	-- B4 - return
	Romset_PatchDWord(0, 0x0008E00C, 0x0A000000);	-- ret

	-- B5 - hijack g14
	Romset_PatchDWord(0, 0x0008E010, 0x5CF01E01);	-- mov     1,g14

	-- B6 - enable comm board now
	Romset_PatchDWord(0, 0x0008E014, 0x82F03000);
	Romset_PatchDWord(0, 0x0008E018, 0x01A14000);	-- stob    g14,0x01A14000

	-- B7 - return
	Romset_PatchDWord(0, 0x0008E01C, 0x0A000000);	-- ret

	-- B8 - restore G14
	Romset_PatchDWord(0, 0x00076EB4, 0x5CF01E00);	-- mov     0,g14
end

function Patch_CommsHack()
	-- A1 - jump to out patched config
	Romset_PatchDWord(0, 0x77134, 0x09017ECC);	-- call    0008f000

	-- A2 - disable comm board now
	Romset_PatchDWord(0, 0x8F000, 0x82A83000);
	Romset_PatchDWord(0, 0x8F004, 0x01A14000);	-- stob    g5,0x01A14000

	-- A3 - config comm board as before
	Romset_PatchDWord(0, 0x8F008, 0x82A03000);
	Romset_PatchDWord(0, 0x8F00C, 0x01A10001);	-- stob    g4,0x01A10001

	-- A4 - override G5
	Romset_PatchDWord(0, 0x8f010, 0x8CA80001);	-- lda     0x1,g5

	-- A5 - set patch byte
	Romset_PatchDWord(0, 0x8F014, 0x82A83000);
	Romset_PatchDWord(0, 0x8F018, 0x00500000);	-- stob    g5,0x00500000

	-- A6 - return
	Romset_PatchDWord(0, 0x8F01C, 0x0A000000);	-- ret

	-- A7 - restore G5
	Romset_PatchDWord(0, 0x77138, 0x8CA80000);	-- lda     0x0,g5
end

function PostDraw()
	if I960_ReadByte(0x00500000) == 0x01 then
		I960_WriteByte(0x00500000, 0x0);
		I960_WriteByte(0x01A14000, 0x1);
	end
	Video_DrawText(8, 8,  "01A14000 " .. HEX8(I960_ReadByte(0x01A14000)), 0xFFFFFF);
	Video_DrawText(8, 20,  "01A14002 " .. HEX8(I960_ReadByte(0x01A14002)), 0xFFFFFF);
	Video_DrawText(8, 32,  "01A10001 " .. HEX8(I960_ReadByte(0x01A10001)), 0xFFFFFF);
	Video_DrawText(8, 44,  "01A10000 " .. HEX8(I960_ReadByte(0x01A10000)), 0xFFFFFF);
	if Input_IsKeyPressed(0x3E) == 0x1 then
		I960_WriteByte(0x01A14000, 0x0);
	end
	if Input_IsKeyPressed(0x3F) == 0x1 then
		I960_WriteByte(0x01A14000, 0x1);
	end
end
