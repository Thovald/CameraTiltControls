local _, Private = ...
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("CameraTiltControls")

local config = Private.config

function config.RegisterOptions()
    local options = {
        type = "group",
        name = "Camera Tilt Controls",
        childGroups = "tab",
        args = {
            tab_settings = {
                type = "group",
                name = L["tabName_settings"],
                order = 10,
                args = {
                    descr_slashCommands = {
                        type = "description",
                        name = "|cFFFFD100" .. L["description_slashCommands"] .. "|r",
                        fontSize = "medium",
                        order = 5,
                    },
                    space_slashCommands = {
                        type = "description",
                        name = "|n",
                        width = "full",
                        fontSize = "large",
                        order = 6,
                    },
                    descr_main = {
                        type = "description",
                        name = L["description_main"],
                        fontSize = "medium",
                        order = 10,
                    },
                    space_main = {
                        type = "description",
                        name = "|n",
                        width = "full",
                        fontSize = "large",
                        order = 11,
                    },
                    toggle_enable = {
                        type = "toggle",
                        name = L["checkboxName_enable"],
                        desc = L["checkboxDescr_enable"] ,
                        get = function() return Private.db.profile.enabled end,
                        set = function(_, val)
                                Private.db.profile.enabled = val
                                Private.main.ApplySetting("enabled")
                            end,
                        order = 20,
                    },
                    space_enable = {
                        type = "description",
                        name = "",
                        width = 2,
                        order = 30,
                    },
                    slider_angle = {
                        type = "range",
                        name = L["sliderName_angle"],
                        desc = L["sliderDescr_angle"],
                        min = 0.01,
                        max = 0.99,
                        step = 0.01,
                        get = function() return Private.db.profile.angle end,
                        set = function(_, val)
                                Private.db.profile.angle = val
                                Private.main.ApplySetting("angle")
                            end,
                        width = 1.5,
                        order = 40,
                    },
                    slider_angleSkyriding = {
                        type = "range",
                        name = L["sliderName_angleSkyriding"],
                        desc = L["sliderDescr_angleSkyriding"],
                        min = 0.01,
                        max = 0.99,
                        step = 0.01,
                        get = function() return Private.db.profile.angleSkyriding end,
                        set = function(_, val)
                                Private.db.profile.angleSkyriding = val
                                Private.main.ApplySetting("angleSkyriding")
                            end,
                        width = 1.5,
                        order = 50,
                    },
                    slider_topDownStrength = {
                        type = "range",
                        name = L["sliderName_topDownStrength"],
                        desc = L["sliderDescr_topDownStrength"],
                        min = 0,
                        max = 1,
                        step = 0.01,
                        get = function() return Private.db.profile.topDownStrength end,
                        set = function(_, val)
                                Private.db.profile.topDownStrength = val
                                Private.main.ApplySetting("topDownStrength")
                            end,
                        width = 3,
                        order = 60,
                    },
                },
            },

            profiles = AceDBOptions:GetOptionsTable(Private.db),
        },

    }

AceConfig:RegisterOptionsTable("CameraTiltControls", options)
AceConfigDialog:AddToBlizOptions("CameraTiltControls", "Camera Tilt Controls")

SLASH_CAMERATILT1 = "/cameratilt"
SLASH_CAMERATILT2 = "/cameratiltcontrols"
SLASH_CAMERATILT3 = "/ctc"
SlashCmdList["CAMERATILT"] = function()
    if AceConfigDialog.OpenFrames["CameraTiltControls"] then
        AceConfigDialog:Close("CameraTiltControls")
    else
        AceConfigDialog:Open("CameraTiltControls")
    end
end

-- To make it resizable and set size:
AceConfigDialog:SetDefaultSize("CameraTiltControls", 600, 400)

end