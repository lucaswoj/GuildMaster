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
        bl = {
            name = "Print Blacklist",
            type = "execute",
            desc = "Print blacklist.",
            func = "PrintBlacklist",
        },
        ba = {
            name = "Blacklist Add",
            type = "input",
            desc = "Add a player to the blacklist.",
            set = "BlacklistAdd",
        },
        br = {
            name = "Blacklist Remove",
            type = "input",
            desc = "Remove a player from the blacklist.",
            set = "BlacklistRemove",
        },
    },
}

local defaults = {
    realm = {
        blacklist = {},
    },
}
    
local m_bMassListening = false;
    
function GuildMaster:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("GuildMasterDB", defaults, "Default");
    
    LibStub("AceConfig-3.0"):RegisterOptionsTable("GuildMaster", options, {"gmaster"});
end

function GuildMaster:OnEnable()
    self:Print("Guild|cff80ff80Master|r addon enabled.");
    self:RegisterEvent("WHO_LIST_UPDATE");
end

function GuildMaster:OnDisable()
end

-- Mass invite functions
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

-- Mass invite blacklist functions
function GuildMaster:BlacklistIndex(name)
    for i, entry in ipairs(self.db.blacklist) do
        if (entry == name) then
            return i;
        end
    end
    
    return nil;
end

function GuildMaster:PrintBlacklist()
    for i, entry in ipairs(self.db.blacklist) do
        self:Print(entry);
    end
end

function GuildMaster:BlacklistAdd(info, params)
    if (self:BlacklistIndex(params) ~= nil) then
        self:Print(params .. " is already on the blacklist.");
        return;
    end
    
    table.insert(self.db.blacklist, params);
end

function GuildMaster:BlacklistRemove(info, params)
    local index = self:BlacklistIndex(params);
    if (index == nil) then
        self:Print(params .. " is not on the blacklist.");
        return;
    end

    table.remove(self.db.blacklist, index);
end
