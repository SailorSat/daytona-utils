require("model2");	-- Import model2 machine globals

function Init()
	Patch_Master();
end

function Patch_Master()
	-- A1 - jump to out patched init
	Romset_PatchDWord(0, 0xC64F4, 0x09031B0C);	-- CALL 0x000F8000

	-- A2 - set g2
	Romset_PatchDWord(0, 0xF8000, 0x5C901E01);	-- MOV g2,0x1

	-- A2 - write to memory
	Romset_PatchDWord(0, 0xF8004, 0x82903000);
	Romset_PatchDWord(0, 0xF8008, 0x01A10001);	-- STOB g2,0x1a10001

	-- A3 - enable comm board
	Romset_PatchDWord(0, 0xF800c, 0x82903000);
	Romset_PatchDWord(0, 0xF8010, 0x01A14000);	-- STOB g2,0x1a14000

	-- A4 - return
	Romset_PatchDWord(0, 0xF8014, 0x0A000000);  -- RET
end
