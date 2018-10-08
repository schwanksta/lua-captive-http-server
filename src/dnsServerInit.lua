local dns_ip = ...

local s = net.createUDPSocket();
s:on("receive", function(con, req, port, ip)
    local ix = 13
    while req:byte(ix) > 0  do
        ix = ix + 1 + req:byte(ix)
    end

    if "\0\1" == req:sub(ix + 1, ix + 2) then
        local id, nr, query, check, class = struct.unpack("c2xxc2xxxxxxc"..(ix-12).."i2c2", req)
        if id then
            con:send(port, ip, id .. "\129\128" .. nr .. "\0\1\0\0\0\0" .. query .. "\0\1" .. 
                                class .. "\192\12\0\1" .. class .. "\0\0\0\218\0\4" .. dns_ip)
        end
    end
end)

s:on("sent", function(con)
    con:close()
    con:listen(53)
end)

s:listen(53)

return s
