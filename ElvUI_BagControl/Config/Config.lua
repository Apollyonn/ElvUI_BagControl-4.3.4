local E, _, V, P, G = unpack(ElvUI)
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale or "enUS")
local BC = E:GetModule("BagControl")

local format = string.format

local function ColorizeSettingName(settingName)
	return format("|cff1784d1%s|r", settingName)
end

function BC:InsertOptions()
	local ACD = E.Libs.AceConfigDialog

	if not E.Options.args.elvuiPlugins then
		E.Options.args.elvuiPlugins = {
			order = 50,
			type = "group",
			name = "|cffff7000E|r|cffe5e3e3lvUI |r|cffff7000P|r|cffe5e3e3lugins|r",
			args = {
				header = {
					order = 0,
					type = "header",
					name = "|cffff7000E|r|cffe5e3e3lvUI |r|cffff7000P|r|cffe5e3e3lugins|r"
				},
				bagControlShortcut = {
					type = "execute",
					name = ColorizeSettingName(L["Bag Control"]),
					func = function()
						if IsAddOnLoaded("ElvUI_OptionsUI") then
							ACD:SelectGroup("ElvUI", "elvuiPlugins", "bagControl")
						end
					end
				}
			}
		}
	elseif not E.Options.args.elvuiPlugins.args.bagControlShortcut then
		E.Options.args.elvuiPlugins.args.bagControlShortcut = {
			type = "execute",
			name = ColorizeSettingName(L["Bag Control"]),
			func = function()
				if IsAddOnLoaded("ElvUI_OptionsUI") then
					ACD:SelectGroup("ElvUI", "elvuiPlugins", "bagControl")
				end
			end
		}
	end

	E.Options.args.elvuiPlugins.args.bagControl = {
		type = "group",
		childGroups = "tab",
		name = ColorizeSettingName(L["Bag Control"]),
		get = function(info) return E.db.BagControl[info[#info]] end,
		set = function(info, value) E.db.BagControl[info[#info]] = value end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Bag Control"]
			},
			Enabled = {
				order = 2,
				type = "toggle",
				name = L["ENABLE"],
				set = function(info, value) E.db.BagControl[info[#info]] = value BC:Update() end,
				disabled = function() return not E.Bags.Initialized end
			},
			Open = {
				order = 3,
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
				order = 4,
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