local E, L, V, P, G = unpack(ElvUI)
local BC = E:NewModule("BagControl", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local B = E:GetModule("Bags")
local EP = E.Libs.EP

local addonName = ...

local OpenEvents = {
	["MAIL_SHOW"] = "Mail",
	["MERCHANT_SHOW"] = "Vendor",
	["BANKFRAME_OPENED"] = "Bank",
	["GUILDBANKFRAME_OPENED"] = "GB",
	["AUCTION_HOUSE_SHOW"] = "AH",
	["VOID_STORAGE_OPEN"] = "VS",
	["TRADE_SKILL_SHOW"] = "TS",
	["TRADE_SHOW"] = "Trade"
}

local CloseEvents = {
	["MAIL_CLOSED"] = "Mail",
	["MERCHANT_CLOSED"] = "Vendor",
	["BANKFRAME_CLOSED"] = "Bank",
	["GUILDBANKFRAME_CLOSED"] = "GB",
	["AUCTION_HOUSE_CLOSED"] = "AH",
	["VOID_STORAGE_CLOSE"] = "VS",
	["TRADE_SKILL_CLOSE"] = "TS",
	["TRADE_CLOSED"] = "Trade"
}

local function EventHandler(_, event, ...)
	if not E.Bags.Initialized then return end

	if OpenEvents[event] then
		if event == "BANKFRAME_OPENED" then
			B:OpenBank()
			if not E.db.BagControl.Open[OpenEvents[event]] then
				B.BagFrame:Hide()
			end
			return
		elseif E.db.BagControl.Open[OpenEvents[event]] then
			B:OpenBags()
			return
		else
			B:CloseBags()
			return
		end
	elseif CloseEvents[event] then
		if E.db.BagControl.Close[CloseEvents[event]] then
			B:CloseBags()
			return
		else
			B:OpenBags()
			return
		end
	end
end

local EventFrame = CreateFrame("Frame")
EventFrame:SetScript("OnEvent", EventHandler)

local eventsRegistered = false
local function RegisterMyEvents()
	for event in pairs(OpenEvents) do
		EventFrame:RegisterEvent(event)
	end

	for event in pairs(CloseEvents) do
		EventFrame:RegisterEvent(event)
	end

	eventsRegistered = true
end

local function UnregisterMyEvents()
	for event in pairs(OpenEvents) do
		EventFrame:UnregisterEvent(event)
	end

	for event in pairs(CloseEvents) do
		EventFrame:UnregisterEvent(event)
	end

	eventsRegistered = false
end

function BC:Update()
	if E.db.BagControl.Enabled and not eventsRegistered then
		RegisterMyEvents()
	elseif not E.db.BagControl.Enabled and eventsRegistered then
		UnregisterMyEvents()
	end
end

function BC:Initialize()
	EP:RegisterPlugin(addonName, self.InsertOptions)

	BC:Update()
end

local function InitializeCallback()
	BC:Initialize()
end

E:RegisterModule(BC:GetName(), InitializeCallback)