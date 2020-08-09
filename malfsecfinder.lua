local function SmbListener()
    -- Field extractors
    local listener     = Listener.new(nil, 'smb')
    local getSmbCmd    = Field.new('smb.cmd')
    local getMalformed = Field.new('_ws.malformed')
    local getSrc       = Field.new('ip.src')
    local getDest      = Field.new('ip.dst')
    --
    local malfTransSecReqFound = false
    local malfCount = 0
    local malfConns = {}
    
    function listener.packet(pinfo, tvb, tapinfo)
        -- 0xa1: NT Trans Secondary
        if(tostring(getSmbCmd()) == tostring(0xa1)) then
            if(getMalformed()) then
                malfTransSecReqFound = true
                malfCount = malfCount+1
                malfConns[malfCount] = string.format('%s -> %s',
                                                     tostring(getSrc()),
                                                     tostring(getDest()))
            end
        end
    end

    function listener.draw()
	if malfTransSecReqFound then
            print(string.format('%i malformed NT Trans Secondary Request(s) found.', malfCount))
            print('Connection(s):')
            for i, conn in ipairs(malfConns) do
                print(conn)
            end
        else
            print('No malformed NT Trans Secondary Request found.')
        end        
    end
end

SmbListener()