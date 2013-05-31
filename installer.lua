local args = { ... }

local url = "https://raw.github.com/Yevano/swarm-api/master"

local file_list = {
    slave = { 
        "apis/include",
        "swarm/slave/Navigation.lua",
        "swarm/slave/NetManager.lua",
        "swarm/slave/Swarm.lua",
        "swarm/slave/ThreadPool.lua",
        "swarm/slave/Util.lua",
        "swarm/slave/Vector.lua"
    },

    master = {
        "apis/include",
        "swarm/master/Hook.lua",
        "swarm/master/NetManager.lua",
        "swarm/master/Swarm.lua",
        "swarm/master/ThreadPool.lua",
        "swarm/master/Turtle.lua",
        "swarm/master/Util.lua"
    }
}

function download(url, destination)
    local res = http.get(url)
    if url then
        local file = io.open(destination, "w")
        if file then
            file:write(res.readAll())
            file:close()
        else
            error("Could not open file: " .. destination)
        end
    else
        error("Could not retrieve: " .. url)
    end
end

function main(args)
    if #args < 1 then return false end
    local type = args[1]
    if type ~= "master" and type ~= "slave" then return false end

    fs.makeDir("/apis")
    fs.makeDir("/swarm")
    fs.makeDir("/swarm/" .. type)

    for _, file in pairs(file_list[type]) do
        print("Downloading: " .. "/" .. file)
        download(url .. "/" .. type .. "/" .. file, "/" .. file)
    end

    return true
end

if not main(args) then
    print("Usage: installer <master/slave>")
end