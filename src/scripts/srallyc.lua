require("model2");	-- Import model2 machine globals

function Init()
	--Patch_DisableMaster();
end

function Patch_DisableMaster()
	Romset_PatchDWord(0, 0x0000C7A4, 0x5CA81E00); -- mov g5,0x00
end

function Frame()
	FixTimeLeft();
end

---

TimeLast = 0;
TimeNow = 0;
TimeDelay = 0;

function FixTimeLeft()
	TimeNow = I960_ReadWord(0x20B0B0)
	
	if (TimeNow > TimeLast) then
		if (TimeDelay == 0) then
			TimeDelay = 60;
		else
			I960_WriteWord(0x20B0B0, TimeLast);
			TimeNow = TimeLast;
		end
	end
	if (TimeDelay > 0) then
		TimeDelay = TimeDelay - 1;
	end

	TimeLast = TimeNow;
end