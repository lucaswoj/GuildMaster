GuildMaster = LibStub("AceAddon-3.0"):NewAddon("GuildMaster", "AceConsole-3.0", "AceEvent-3.0");

local options = {
    name = "GuildMaster",
    handler = GuildMaster,
    type = 'group',
    args = {
        mass = {
            name = "Mass Invite",
            type = "input",
            desc = "Invite unguilded players from the list returned by a /who query.",
            set = "RunMass",
        },
    },
}
    
local m_bMassListening = false;
    
function GuildMaster:OnInitialize()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("GuildMaster", options, {"gmaster"});
end

function GuildMaster:OnEnable()
    self:Print("Guild|cff80ff80Master|r addon enabled.");
    self:RegisterEvent("WHO_LIST_UPDATE");
end

function GuildMaster:OnDisable()
end

function GuildMaster:RunMass(info, params)
    m_bMassListening = true;
    SendWho(params);
end

function GuildMaster:WHO_LIST_UPDATE()
    if (m_bMassListening) then
        self:DispatchInvites();
    end
end
    
function GuildMaster:DispatchInvites()
    local i, n, charname, guildname;
    
    m_bMassListening = false;
    n = GetNumWhoResults();
    
    for i=1,n do
        charname, guildname = GetWhoInfo(i);
        if (guildname == "") then
            GuildInvite(charname);
        end
    end
end