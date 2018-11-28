require("model2");	-- Import model2 machine globals

function Init()
	-- patch inputs (for forcing time attack mode etc.) and enable special inputs (if special type cabinet selected)
	Patch_Inputs();

	-- reroute lamp data
	Patch_LampOutputs();
end

function Patch_Inputs()
	-- A1 - jump to out patched init
	Romset_PatchDWord(0, 0x017B8, 0x0903E7C8);	-- CALL 0x0003FF80

	-- A2 - set default mask
	Romset_PatchDWord(0, 0x3FF80, 0x8C8000FF);	-- LDA g0,0xFF

	-- A3 - store default mask
	Romset_PatchDWord(0, 0x3FF84, 0x82803000);
	Romset_PatchDWord(0, 0x3FF88, 0x00500820);	-- STOB g0,0x00500820
	Romset_PatchDWord(0, 0x3FF8C, 0x82803000);
	Romset_PatchDWord(0, 0x3FF90, 0x00500821);	-- STOB g0,0x00500821

	-- A4 - restore register
	Romset_PatchDWord(0, 0x3FF94, 0x5C801E00);	-- MOV g0,0x00

	-- A5 - return
	Romset_PatchDWord(0, 0x3FF98, 0x0A000000);  -- RET


	-- B1 - disable old read and jump to our patched read
	Romset_PatchDWord(0, 0x1E4E0, 0x5CA01E00);	-- MOV g4,0x00 (NOOP?)
	Romset_PatchDWord(0, 0x1E4E4, 0x09021A5C);	-- CALL 0x0003FF40

	-- B2 - read io port
	Romset_PatchDWord(0, 0x3FF40, 0x80A83000);
	Romset_PatchDWord(0, 0x3FF44, 0x01C00010);	-- LDOB g5,0x01C00010

	-- B3 - read patched mask
	Romset_PatchDWord(0, 0x3FF48, 0x80B83000);
	Romset_PatchDWord(0, 0x3FF4C, 0x00500820);	-- LDOB g7,0x00500820

	-- B4 - and em
	Romset_PatchDWord(0, 0x3FF50, 0x58ADC095);	-- AND g5,g7,g5

	-- B5 - return
	Romset_PatchDWord(0, 0x3FF54, 0x0A000000);  -- RET


	-- C1 - disable old read and jump to our patched read
	Romset_PatchDWord(0, 0x1E504, 0x5CA01E00);	-- MOV g4,0x00 (NOOP?)
	Romset_PatchDWord(0, 0x1E508, 0x090219F8);	-- CALL 0x0003FF00

	-- C2 - read io port
	Romset_PatchDWord(0, 0x3FF00, 0x80A03000);
	Romset_PatchDWord(0, 0x3FF04, 0x01C00012);	-- LDOB g4,0x01C00012

	-- C3 - read patched mask
	Romset_PatchDWord(0, 0x3FF08, 0x80B83000);
	Romset_PatchDWord(0, 0x3FF0C, 0x00500821);	-- LDOB g7,0x00500821

	-- C4 - and em
	Romset_PatchDWord(0, 0x3FF10, 0x58A50097);	-- AND g4,g4,g7

	-- C5 - restore old mask
	Romset_PatchDWord(0, 0x3FF14, 0x8CB800FF);	-- LDA g7,0xff

	-- C6 - return
	Romset_PatchDWord(0, 0x3FF18, 0x0A000000);  -- RET
end

function Patch_LampOutputs()
	-- reroute 0x01C0001E to 0x00500824
	for offset = 0x00000000, 0x0003FFFF, 4 do
		if Romset_ReadDWord(0, offset) == 0x01C0001E then
			Romset_PatchDWord(0, offset, 0x00500824);
			local opcode = offset - 1;
			if Romset_ReadByte(0, opcode) == 0x80 then
				Romset_PatchByte(0, opcode, 0x90)	-- replace LDOB with LD
			end
			if Romset_ReadByte(0, opcode) == 0x82 then
				Romset_PatchByte(0, opcode, 0x92)	-- replace STOB with ST
			end
		end
	end
end