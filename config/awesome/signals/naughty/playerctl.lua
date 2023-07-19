local naughty = require("naughty")
local playerctl = require("modules").bling.signal.playerctl.lib()

playerctl:connect_signal("metadata", function(_, title, artist, album_path, _, new, player_name)
    if new == true then
        naughty.notify({ title = "Playerctl  " .. player_name, text = title .. " by " .. artist, image = album_path })
    end
end)
