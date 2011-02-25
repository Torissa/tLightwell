tLightwell = LibStub("AceAddon-3.0"):NewAddon("tLightwell")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("tLightwell",true)

local defaults = {
  profile = {
    setting = true,
  }
}

function tLightwell:OnInitialize()
	self.DB = LibStub("AceDB-3.0"):New("tLightwellDB", defaults, true)	
	tLightwell:Optionen()
end


function tLightwell:Optionen()
	local myOptions = {
  	type = "group",
  	args = {
			amessage = {
				name = L["AMESSAGE"],
				desc = L["AMESSAGE_DESC"],
				type = "toggle",
				order = 1,
				set = function(info,val) tLightwellDB.amessage = val end,
				get = function(info) return tLightwellDB.amessage end
				},
			message={
				name = L["MESSAGE"],
				desc = L["MESSAGE_DESC"],
				type = "input",
				order = 3,
				multiline = true,
				width = "full",
				set = function(info,val) tLightwellDB.message = val end,
				get = function(info) return tLightwellDB.message end
			},
			announceTo = {
				name = L["ANNOUNCETO"],
				desc = L["ANNOUNCETO_DESC"],
				type = "select",
				order = 2 ,
				values = {["OFFICER"] = "officers", ["GUILD"] = "guild", ["RAID_WARNING"] = "raidwarning", ["RAID"] = "raid", ["YELL"] = "yell", ["PARTY"] = "party", ["SAY"] = "say", ["WHISPER"] = "whisper",
				["BATTLEGROUND"] = "battleground", ["CHANNEL 5"]= "Channel 5", ["CHANNEL 6"]= "Channel 6", ["CHANNEL 7"]= "Channel 7", ["CHANNEL 8"]= "Channel 8", ["CHANNEL 9"]= "Channel 9", ["smart"]= "smart"},
				set = function(info,val) tLightwellDB.announceTo = val end,
				get = function(info) return tLightwellDB.announceTo end
			}
		}
	};
	
	AceConfig:RegisterOptionsTable("tLightwell", myOptions);
	AceConfigDialog:AddToBlizOptions("tLightwell", "tLightwell");
end

-- Für Test Zwecke
-- GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	-- local id = select(3,self:GetSpell())
	-- if id then
		-- self:AddLine("|cFFCA3C3C"..ID.."|r".." "..id)
		-- self:Show()
	-- end
-- end)

	  
local tLightwell = CreateFrame("Frame", "tLightwell", UIParent)
tLightwell:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
tLightwell:SetScript("OnEvent",function(_,_,_,event,_,unitName,_,_,_,_,spellID)
		if event=="SPELL_SUMMON" and unitName==UnitName("player") and spellID==724 and tLightwellDB.amessage  then 
			SendChatMessage(string.gsub(tLightwellDB.message,"<L>",GetSpellLink(spellID),1), tLightwellDB.announceTo, nil, nil)
		end 
	end)