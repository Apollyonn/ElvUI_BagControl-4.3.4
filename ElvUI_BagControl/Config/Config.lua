local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)
local BC = E:GetModule("BagControl")

function BC:InsertOptions()
	local ACD = E.Libs.AceConfigDialog

	if not E.Options.args.elvuiPlugins then
		E.Options.args.elvuiPlugins = {
			order = 50,
			type = "group",
			name = "|cffff7000E|r|cffe5e3e3lvUI |r|cffff7000P|r|cffe5e3e3lugins|r",
			args = {}
		}
	end

	E.Options.args.elvuiPlugins.args.bagControl = {
		type = "group",
		childGroups = "tab",
		name = "|cffff7000B|r|cffe5e3e3ag |r|cffff7000C|r|cffe5e3e3ontrol|r",
		get = function(info) return E.db.BagControl[info[#info]] end,
		set = function(info, value) E.db.BagControl[info[#info]] = value end,
		args = {
			Enabled = {
				order = 1,
				type = "toggle",
				name = L["ENABLE"],
				set = function(info, value) E.db.BagControl[info[#info]] = value BC:Update() end,
				disabled = function() return not E.Bags.Initialized end
			},
			Open = {
				order = 2,
				type = "group",
				name = L["Open bags when the following windows open:"],
				guiInline = true,
				get = function(info) return E.db.BagControl.Open[info[#info]] end,
				set = function(info, value) E.db.BagControl.Open[info[#info]] = value end,
				disabled = function() return not E.Bags.Initialized or not E.db.BagControl.Enabled end,
				args = {
					Mail = {
						order = 1,
						type = "toggle",
						name = L["MAIL_LABEL"]
					},
					Vendor = {
						order = 2,
						type = "toggle",
						name = L["MERCHANT"]
					},
					Bank = {
						order = 3,
						type = "toggle",
						name = L["Bank"]
					},
					GB = {
						order = 4,
						type = "toggle",
						name = L["GUILD_BANK"]
					},
					AH = {
						order = 5,
						type = "toggle",
						name = L["AUCTIONS"]
					},
					VS = {
						order = 6,
						type = "toggle",
						name = L["VOID_STORAGE"]
					},
					TS = {
						order = 7,
						type = "toggle",
						name = L["TRADESKILLS"]
					},
					Trade = {
						order = 8,
						type = "toggle",
						name = L["TRADE"]
					}
				}
			},
			Close = {
				order = 3,
				type = "group",
				name = L["Close bags when the following windows close:"],
				guiInline = true,
				get = function(info) return E.db.BagControl.Close[info[#info]] end,
				set = function(info, value) E.db.BagControl.Close[info[#info]] = value end,
				disabled = function() return not E.Bags.Initialized or not E.db.BagControl.Enabled end,
				args = {
					Mail = {
						order = 1,
						type = "toggle",
						name = L["MAIL_LABEL"]
					},
					Vendor = {
						order = 2,
						type = "toggle",
						name = L["MERCHANT"]
					},
					Bank = {
						order = 3,
						type = "toggle",
						name = L["Bank"]
					},
					GB = {
						order = 4,
						type = "toggle",
						name = L["GUILD_BANK"]
					},
					AH = {
						order = 5,
						type = "toggle",
						name = L["AUCTIONS"]
					},
					VS = {
						order = 6,
						type = "toggle",
						name = L["VOID_STORAGE"]
					},
					TS = {
						order = 7,
						type = "toggle",
						name = L["TRADESKILLS"]
					},
					Trade = {
						order = 8,
						type = "toggle",
						name = L["TRADE"]
					}
				}
			}
		}
	}
end