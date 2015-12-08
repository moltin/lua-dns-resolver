--- DNS Parser
-- @author Israel Sotomayor israel@moltin.com

local resolver = require "resty.dns.resolver"

local Dns = {}
Dns.__index = Dns

setmetatable(Dns, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function Dns:getResolver()
    return self._resolver
end

function Dns:setResolver(resolver)
    self._resolver = resolver
end

function Dns:resolve(url)
    if url then
        local answers, err = self._resolver:query(url)
        if answers then
            return answers
        end
    end
    return false
end

function Dns:getIp(url)
    local answers = self:resolve(url)
    if answers then
        for i, ans in ipairs(answers) do
            if ans.name == url then
                return ans.address
            end
        end
    end
    return answer
end


function Dns.new(args)
    local instance = {}
    setmetatable(instance, Dns)
    local r, err = resolver:new{
        nameservers = args or {"8.8.8.8", {"8.8.4.4", 53} },
        retrans = 5,  -- 5 retransmissions on receive timeout
        timeout = 2000,  -- 2 sec
    }
    instance._resolver = r
    return instance
end

return Dns