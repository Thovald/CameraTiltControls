local _, Private = ...
Private.main = {}
Private.config = {}
local db

local main = Private.main
local config = Private.config

------------------
-- Main frame
------------------

main.frame = CreateFrame("Frame", "AutoSummonBattlePetFrame")
main.frame:RegisterEvent("ADDON_LOADED")
main.frame:RegisterEvent("PLAYER_LOGIN")
main.frame:RegisterEvent("CVAR_UPDATE")

------------------
-- Applying Settings
------------------
function main.ApplySetting(name)
    if name == "enabled" or name == "all" then
        SetCVar("test_cameraDynamicPitch", db.enabled)

        -- the "CameraKeepCharacterCentered" CVar needs to be disabled for the camera to update.
        -- however, this CVar is also controlled by the "Motion Sickness" setting.
        -- if user disables the camera tilt, we don't want to also disable this setting if user has "Motion Sickness" enabled.
        if not db.enabled then
            local isMotionSicknessEnabled = GetCVar("CameraReduceUnexpectedMovement")
            SetCVar("CameraKeepCharacterCentered", isMotionSicknessEnabled)
            return
        else
            SetCVar("CameraKeepCharacterCentered", false)
        end
    end

    if name == "angle" or name == "all" then
        SetCVar("test_cameraDynamicPitchBaseFovPad", db.angle)
    end

    if name == "angleSkyriding" or name == "all" then
        SetCVar("test_cameraDynamicPitchBaseFovPadFlying", db.angleSkyriding)
    end

    if name == "topDownStrength" or name == "all" then
        SetCVar("test_cameraDynamicPitchBaseFovPadDownScale", db.topDownStrength)
    end
end

function Private:OnProfileChanged()
    db = Private.db.profile
    main.ApplySetting("all")
end

------------------
-- Events
------------------

local function InitDB(addOnName)
    if addOnName ~= "CameraTiltControls" then return end

    local defaults = {
        profile = {
            enabled = true,
            angle = 0.6,
            angleSkyriding = 0.6,
            topDownStrength = 0,
        },
    }

    Private.db = LibStub("AceDB-3.0"):New("CameraTiltControlsDB", defaults, true)

    Private.db.profile.enabled = Private.db.profile.enabled
    db = Private.db.profile

    Private.db.RegisterCallback(Private, "OnProfileChanged", "OnProfileChanged")
    Private.db.RegisterCallback(Private, "OnProfileCopied", "OnProfileChanged")
    Private.db.RegisterCallback(Private, "OnProfileReset", "OnProfileChanged")

    config.RegisterOptions()
end

local function OnLogin()
    UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")
    main.ApplySetting("all")
end

local function OnCVarUpdate(cvar)
    if cvar == "CameraKeepCharacterCentered" then
        main.ApplySetting("enabled")
    end
end

------------------
-- Event Handler
------------------

local eventHandler = {
    ["ADDON_LOADED"] = InitDB,
    ["PLAYER_LOGIN"] = OnLogin,
    ["CVAR_UPDATE"] = OnCVarUpdate,
}

function main.frame:OnEvent(event, ...)
    eventHandler[event](...)
end

main.frame:SetScript("OnEvent", main.frame.OnEvent)
