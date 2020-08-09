local function KerberosListener()
    local listener = Listener.new(nil, 'kerberos')
    -- Field extractors
    local getCNameString = Field.new('kerberos.CNameString')
    --
    local hosts = {}
    local users = {}

    function listener.packet(pinfo, tvb, tapinfo)
        local CNameString = getCNameString()
        if CNameString then
            CNameString = string.upper(tostring(CNameString))
            local last = string.len(CNameString)
            local isHost = (string.sub(CNameString,
                                       last,
                                       last) == '$')
            if isHost and hosts[CNameString] == nil then
                hosts[CNameString] = true
            elseif not isHost and users[CNameString] == nil then
                users[CNameString] = true
            end
        end
    end

    function listener.draw()
        print('HOSTS:')
        for host, _ in pairs(hosts) do
            print(host)
        end
        print('USERS:')
        for user, _ in pairs(users) do
            print(user)
        end
    end
end


KerberosListener()