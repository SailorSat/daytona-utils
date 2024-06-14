require("model2");	-- Import model2 machine globals

function Frame()
	FixMasterState();
end

---

StateDelay = 0;
function FixMasterState()
	if StateDelay == 0x00 then
		if I960_ReadByte(0x01A12000) == 0x00 then
			-- if master
			if I960_ReadByte(0x01A12002) == 0x01 then
				-- if link state 1 (linkup?)
				if I960_ReadByte(0x01A12005) == 0x00 then
					-- if not ready
					if I960_ReadByte(0x00202094) == 0x04 then
						-- if host state 4

						-- check clients!
						AllClientsReady = true;
						for offset = 0x000, 0xE00, 0x1C0
						do
							-- if client
							if I960_ReadByte(0x01A12002 + offset) > 0x02 then
								if I960_ReadByte(0x01A12005 + offset) == 0x01 then
									AllClientsReady = AllClientsReady and true;
								else
									AllClientsReady = AllClientsReady and false;
								end
							end
						end
						
						if AllClientsReady then
							if StateDelay == 0x00 then
								StateDelay = 0x01;
								I960_WriteByte(0x00202094,0);
							end
						end
					end
				end
			end
		else
			-- client
			StateDelay = 0x01;
		end
	end
end
