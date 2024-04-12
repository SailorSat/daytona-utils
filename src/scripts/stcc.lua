require("model2");	-- Import model2 machine globals

function Init()
end

function Frame()
	FixMaster();
end

---

TimeFix = 0;
TimeDelay = 0;

function FixMaster()
	if I960_ReadWord(0x01A10000) == 0x0100 then
		if TimeFix == 0 then
			TimeFix = 1;
			TimeDelay = 240;
			I960_WriteByte(0x01A14000, 0);
		elseif TimeFix == 1 then
			if TimeDelay > 0 then
				TimeDelay = TimeDelay - 1;
			else
				TimeFix = 2;
				TimeDelay = 120;
				I960_WriteByte(0x01A14000, 1);
			end
		elseif TimeFix == 2 then
			if TimeDelay > 0 then
				TimeDelay = TimeDelay - 1;
			else
				TimeFix = 3;
			end
		end
	end
end
