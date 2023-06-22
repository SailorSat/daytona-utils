require("model2");	-- Import model2 machine globals

function Init()
	-- patch comm board logic for master
	Patch_Network();
end

function Patch_Network()
	Romset_PatchDWord(0, 0x4f344, 0x82A83000);
	Romset_PatchDWord(0, 0x4f348, 0x00500000);	-- stob    g5,0x1a14000
	Romset_PatchDWord(0, 0x4f34c, 0x0A000000);	-- ret
end
-- 7713C 01 master / 02 slave/ 00 relay (use G5)

function PostDraw()
	if I960_ReadByte(0x00500000) > 0x01 then
		I960_WriteByte(0x00500000, I960_ReadByte(0x00500000) - 1);
		if I960_ReadByte(0x00500000) == 0x20 then
			if I960_ReadByte(0x01A10001) == 0x01 then
				I960_WriteByte(0x01A14000, 0x0);
			else
				I960_WriteByte(0x00500000, 0x00);
			end
		end
		if I960_ReadByte(0x00500000) == 0x01 then
			I960_WriteByte(0x00500000, 0x0);
			I960_WriteByte(0x01A14000, 0x1);
		end
	end
	if I960_ReadByte(0x00500000) == 0x01 then
		I960_WriteByte(0x00500000, 0xff);
	end
	I960_WriteByte(0x00513230,0x00);
end
