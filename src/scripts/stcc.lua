require("model2");	-- Import model2 machine globals

function Init()
	Patch_Master();
	--Patch_DisableMaster();
end

function Patch_Master()
	-- A1 - jump to out patched init
	Romset_PatchDWord(0, 0x770E4, 0x09010F1C);	-- CALL 0x00088000

	-- A2 - set g6
	Romset_PatchDWord(0, 0x88000, 0x5CB01E01);	-- MOV g6,0x1

	-- A2 - write to memory
	Romset_PatchDWord(0, 0x88004, 0x82B03000);
	Romset_PatchDWord(0, 0x88008, 0x01A10001);	-- STOB g6,0x1a10001

	-- A3 - enable comm board
	Romset_PatchDWord(0, 0x8800c, 0x82B03000);
	Romset_PatchDWord(0, 0x88010, 0x01A14000);	-- STOB g6,0x1a14000

	-- A4 - return
	Romset_PatchDWord(0, 0x88014, 0x0A000000);  -- RET
end

function Patch_DisableMaster()
	Romset_PatchDWord(0, 0x00077138, 0x01A14002);
end
