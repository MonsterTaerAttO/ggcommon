local AvatarUrl = "https://i.imgur.com/wwB6LyY.jpg"

Config = {
  IsConfigured = false
}

Citizen.CreateThread(
  function()
    Config.WebhookUrl = GetConvar("gg_discord_webhook", "false")
    Config.ServerNumber = GetConvar("gg_server_number", "0")

    if (Config.WebhookUrl == "false" or Config.ServerNumber == "0") then
      PrintLog("[Common] Discord webhook URL or server number not set correctly. Skipping Discord logging.^7", "error")
    else
      PrintLog("[Common] Discord logging set up.^7", "info")
      Config.IsConfigured = true
    end
  end
)

function Log(title, message, toDiscord)
  if (toDiscord == true) then
    if (Config.IsConfigured == false) then
      return
    else
      local time = os.date("%d/%m/%Y %H:%M:%S")
      local embed = {
        {
          ["author"] = {
            name = "Gun Game",
            icon_url = "https://i.imgur.com/wwB6LyY.jpg"
          },
          ["color"] = 6908265,
          ["title"] = title,
          ["description"] = message,
          ["footer"] = {
            text = "Server #" .. Config.ServerNumber .. " • Sent " .. time .. ""
          }
        }
      }
      PerformHttpRequest(
        Config.WebhookUrl,
        function(err, text, headers)
        end,
        "POST",
        json.encode({username = "GG Logger", embeds = embed, avatar_url = AvatarUrl}),
        {["Content-Type"] = "application/json"}
      )
    end
  end

  PrintLog("" .. title .. " " .. message)
end

function PrintLog(message, color)
  local time = os.date("%d/%m/%Y %H:%M:%S")
  if (not color) then
    color = ""
  elseif (color == "error") then
    color = "^1"
  elseif (color == "info") then
    color = "^2"
  else
    color = ""
  end
  print(color .. "[" .. time .. "] " .. message .. "^7")
end

function Screenshot(player)
  if (player == 0 or player == nil) then
    return
  end

  local identifiers = GetPlayerIdentifiers(player)
  local license = 0

  for k, v in pairs(identifiers) do
    if string.sub(v, 1, string.len("license:")) == "license:" then
      license = string.sub(v, string.len("license:") + 1)
      break
    end
  end

  local name = "screenshots/ss-" .. license .. "-" .. os.time(os.date("!*t")) .. ".jpg"

  exports["screenshot-basic"]:requestClientScreenshot(
    player,
    {fileName = name},
    function(err, data)
      if err ~= false then
        print("err", err)
        Log(
          "Screenshot",
          "**Status:** Error \n**Player:** " .. license .. "\n**Filepath:** " .. name .. "\n**Error:** " .. err .. "",
          true
        )
      else
        print("^3[Common] Saved screenshot of " .. license .. " to " .. name .. "^7")
        Log("Screenshot", "**Status:** Saved \n**Player:** " .. license .. "\n**Filepath:** " .. name .. "", true)
      end
    end
  )
end

AddEventHandler(
  "playerDropped",
  function(reason)
    local _source = source
    local name = GetPlayerName(_source)
    if
      reason ~= "Disconnected." and reason ~= "Reconnecting" and reason ~= "Quit." and reason ~= "Exiting" and
        reason ~= "Connecting to another server." and
        reason ~= "Timed out after 60 seconds." and
        string.find(reason, "banned") == nil
     then
      Log("Game Crash by " .. name, reason, true)
    end
  end
)
