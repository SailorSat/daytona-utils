require("model2");	-- Import model2 machine globals

function Init()
end

function Frame()
	-- patch network error counter
	I960_WriteDWord(0x00555214,0x00000000)
end
