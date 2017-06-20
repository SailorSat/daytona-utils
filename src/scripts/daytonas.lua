require("model2");	-- Import model2 machine globals

function Init()
	-- enable special inputs (only usefull if special type cabinet selected)
	Patch_SpecialInputs();
	
	-- reroute lamp data
	Patch_LampOutputs();
	
	-- reroute drive data
	Patch_DriveOutputs();
end

function Patch_SpecialInputs()
	-- A1 - first, disable old read
	Romset_PatchDWord(0, 0x1E504, 0x5CA01E00);	-- MOV g4,0x00 (NOOP?)
	
	-- A2 - now jump to our patched read
	Romset_PatchDWord(0, 0x1E508, 0x090219F8);	-- CALL 0x0003FF00

	-- A3 - read io port
	Romset_PatchDWord(0, 0x3FF00, 0x80A03000);
	Romset_PatchDWord(0, 0x3FF04, 0x01C00012);	-- LDOB g4,0x01C00012

	-- A4 - read patched mask
	Romset_PatchDWord(0, 0x3FF08, 0x80B83000);
	Romset_PatchDWord(0, 0x3FF0C, 0x00500820);	-- LDOB g7,0x00500820

	-- A5 - and em
	Romset_PatchDWord(0, 0x3FF10, 0x58A50097);	-- AND g4,g4,g7

	-- A6 - restore old mask
	Romset_PatchDWord(0, 0x3FF14, 0x8CB800FF);	-- LDA g7,0xff

	-- A7 - return
	Romset_PatchDWord(0, 0x3FF18, 0x0A000000);  -- RET
	
	-- B1 - jump to out patched init
	Romset_PatchDWord(0, 0x017B8, 0x0903E7C8);	-- CALL 0x0003FF80
	
	-- B2 - set default mask
	Romset_PatchDWord(0, 0x3FF80, 0x8C8000FF);	-- LDA g0,0xFF

	-- B3 - store default mask
	Romset_PatchDWord(0, 0x3FF84, 0x82803000);
	Romset_PatchDWord(0, 0x3FF88, 0x00500820);	-- STOB g0,0x00500820

	-- B4 - restore register
	Romset_PatchDWord(0, 0x3FF8C, 0x5C801E00);	-- MOV g0,0x00
	
	-- B5 - return
	Romset_PatchDWord(0, 0x3FF90, 0x0A000000);  -- RET
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

function Patch_DriveOutputs()
	-- reroute 0x01C00022 to 0x00500828
	for offset = 0x00000000, 0x0003FFFF, 4 do
		if Romset_ReadDWord(0, offset) == 0x01C00022 then
			Romset_PatchDWord(0, offset, 0x00500828);
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