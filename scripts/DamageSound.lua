function events.ON_PLAY_SOUND(id, pos, vol, pitch, loop, cat, path)
	
	-- Don't trigger if the sound was played by Figura (prevent potential infinite loop)
	if not path then return end
	
	-- Don't do anything if the user isn't loaded
	if not player:isLoaded() then return end
	
	-- Make sure the sound is (most likely) played by the user
	if (player:getPos() - pos):length() > 0.05 then return end
	
	-- If sound contains ".hurt", play an additional hurt sound along side it
	if id:find(".hurt") then
		return sounds:playSound("entity.squid.hurt", pos, 0.5)
	end
	
	-- If sound contains ".death", play an additional death sound along side it
	if id:find(".death") then
		return sounds:playSound("entity.squid.death", pos, 0.5)
	end
	
end