function GuildMaster_OnLoad()
    SlashCmdList["GUILDMASTER"] = GuildMasterCmdLine;
    SLASH_GUILDMASTER1 = "/gmaster";
    print("Guild|cff80ff80Master|r addon operational.");
end

function GuildMaster_OnEvent(self, event, ...)
    if event == "WHO_LIST_UPDATE" then
        GuildMaster_DispatchInvites();
    end
end

function GuildMasterCmdLine(params, editbox)
    this:RegisterEvent("WHO_LIST_UPDATE");
    this:SetScript("OnEvent", GuildMaster_OnEvent);
    SendWho(params);
end

function GuildMaster_DispatchInvites()
    local i, n, charname, guildname;
    
    this:UnregisterAllEvents();
    n = GetNumWhoResults();
    
    for i=1,n do
        charname, guildname = GetWhoInfo(i);
        if (guildname == "") then
            GuildInvite(charname);
        end
    end
end
