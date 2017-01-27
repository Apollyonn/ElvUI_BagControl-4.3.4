local E, L, V, P, G = unpack(ElvUI);
local B = E:GetModule("Bags")
local MyPlugin = E:NewModule("BagControl", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0");

local EP = LibStub("LibElvUIPlugin-1.0")
local addonName, addonTable = ...

P["BagControl"] = {
	["Enabled"] = true,
	["Open"] = {
		["Mail"] = true,
		["Vendor"] = true,
		["Bank"] = true,
		["GB"] = true,
		["AH"] = true,
		["VS"] = true,
		["TS"] = true,
		["Trade"] = true
	},
	["Close"] = {
		["Mail"] = true,
		["Vendor"] = true,
		["Bank"] = true,
		["GB"] = true,
		["AH"] = true,
		["VS"] = true,
		["TS"] = true,
		["Trade"] = true
	}
}

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

function MyPlugin:InsertOptions()
	E.Options.args.bags.args.BagControl = {
		order = 8,
		type = "group",
		name = L["Bag Control"],
		disabled = function() return not E.bags; end,
		get = function(info) return E.db.BagControl[ info[#info] ] end,
		set = function(info, value) E.db.BagControl[ info[#info] ] = value; end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Bag Control"]
			},
			Enabled = {
				order = 2,
				type = "toggle",
				name = L["Enable"],
				set = function(info, value) E.db.BagControl[ info[#info] ] = value; MyPlugin:Update() end
			},
			Open = {
				order = 3,
				type = "group",
				name = L["Open bags when the following windows open:"],
				guiInline = true,
				disabled = function() return not E.db.BagControl.Enabled end,
				get = function(info) return E.db.BagControl.Open[ info[#info] ] end,
				set = function(info, value) E.db.BagControl.Open[ info[#info] ] = value; end,
				args = {
					Mail = {
						order = 1,
						type = "toggle",
						name = L["Mailbox"]
					},
					Vendor = {
						order = 2,
						type = "toggle",
						name = L["Merchant"]
					},
					Bank = {
						order = 3,
						type = "toggle",
						name = L["Bank"]
					},
					GB = {
						order = 4,
						type = "toggle",
						name = L["Guild Bank"]
					},
					AH = {
						order = 5,
						type = "toggle",
						name = L["Auction House"]
					},
					VS = {
						order = 6,
						type = "toggle",
						name = L["Void Storage"]
					},
					TS = {
						order = 7,
						type = "toggle",
						name = L["Crafting"]
					},
					Trade = {
						order = 8,
						type = "toggle",
						name = L["Trade with Player"]
					}
				}
			},
			Close = {
				order = 4,
				type = "group",
				name = L["Close bags when the following windows close:"],
				guiInline = true,
				disabled = function() return not E.db.BagControl.Enabled end,
				get = function(info) return E.db.BagControl.Close[ info[#info] ] end,
				set = function(info, value) E.db.BagControl.Close[ info[#info] ] = value; end,
				args = {
					Mail = {
						order = 1,
						type = "toggle",
						name = L["Mailbox"]
					},
					Vendor = {
						order = 2,
						type = "toggle",
						name = L["Merchant"]
					},
					Bank = {
						order = 3,
						type = "toggle",
						name = L["Bank"]
					},
					GB = {
						order = 4,
						type = "toggle",
						name = L["Guild Bank"]
					},
					AH = {
						order = 5,
						type = "toggle",
						name = L["Auction House"]
					},
					VS = {
						order = 6,
						type = "toggle",
						name = L["Void Storage"]
					},
					TS = {
						order = 7,
						type = "toggle",
						name = L["Crafting"]
					},
					Trade = {
						order = 8,
						type = "toggle",
						name = L["Trade with Player"]
					}
				}
			}
		}
	}
end

local function EventHandler(self, event, ...)
	if(not E.bags) then return end

	if(OpenEvents[event]) then
		if(event == "BANKFRAME_OPENED") then
			B:OpenBank()
			if(not E.db.BagControl.Open[OpenEvents[event]]) then
				B.BagFrame:Hide()
			end
			return
		elseif(E.db.BagControl.Open[OpenEvents[event]]) then
			B:OpenBags()
			return
		else
			B:CloseBags()
			return
		end
	elseif(CloseEvents[event]) then
		if(E.db.BagControl.Close[CloseEvents[event]]) then
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

function MyPlugin:Update()
	if E.db.BagControl.Enabled and not eventsRegistered then
		RegisterMyEvents()
	elseif not E.db.BagControl.Enabled and eventsRegistered then
		UnregisterMyEvents()
	end
end

function MyPlugin:Initialize()
	EP:RegisterPlugin(addonName, MyPlugin.InsertOptions)
	MyPlugin:Update()
end

E:RegisterModule(MyPlugin:GetName())