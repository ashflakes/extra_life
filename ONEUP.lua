local playerGUID = UnitGUID("player")
local MSG_PLAYER_SOULSTONED = "You gained an extra life!"

RAID_NOTICE_DEFAULT_HOLD_TIME = 5.0;
RAID_NOTICE_FADE_IN_TIME = 0.2;
RAID_NOTICE_FADE_OUT_TIME = 3.0;

local f = CreateFrame("Frame",nil,UIParent)
f:SetFrameStrata("BACKGROUND")
f:SetWidth(64) -- Set these to whatever height/width is needed 
f:SetHeight(64) -- for your Texture
	
FadingFrame_OnLoad(f);
FadingFrame_SetFadeInTime(f, 0.2);
FadingFrame_SetHoldTime(f, 5.0);
FadingFrame_SetFadeOutTime(f, 3.0);

local t = f:CreateTexture(nil,"BACKGROUND")
t:SetTexture("Interface\\AddOns\\ONEUP\\icon.tga")
t:SetAllPoints(f)
f.texture = t

f:SetPoint("TOP",0,-170)

f.elapsed = 0.125 -- run the update code 8 times per second
f:SetScript("OnUpdate", function(self, elapsed)
	self:OnUpdate(fr, elapsed)
end)

function f:OnUpdate(fr, elapsed)


    self.elapsed = self.elapsed - elapsed
    if self.elapsed > 0 then 
		return 
	end
    self.elapsed = 0.125
	FadingFrame_OnUpdate(f)
end

local ONEUP = CreateFrame("Frame")
ONEUP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
ONEUP:SetScript("OnEvent", function(self, event)
	-- pass a variable number of arguments
	self:OnEvent(event, CombatLogGetCurrentEventInfo())
end)

function ONEUP:OnEvent(event, ...)
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, mellanspel, spellName = ...
	
	if subevent == "SPELL_CAST_SUCCESS" and spellName == "Soulstone Resurrection" and destGUID == playerGUID then
			FadingFrame_Show(f)
			PlaySoundFile("Interface\\AddOns\\ONEUP\\1UP.ogg")
			RaidNotice_AddMessage(RaidBossEmoteFrame, MSG_PLAYER_SOULSTONED, { r = 181, g = 178,b = 161, sticky = 0, flashTab = false, flashTabOnGeneral = false })
	end
end