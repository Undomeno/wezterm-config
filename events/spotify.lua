local wez = require "wezterm"
local utilities = require "events.utilities"

local M = {}

local last_update = 0
local stored_playback = ""

-- format spotify playback, to handle max_width nicely
local format_playback = function(pb, max_width)
  if not pb or #pb <= 0 then
    return ""
  end

  if #pb <= max_width then
    return pb
  end

  -- split on " - "
  local track, artist = pb:match "^(.-) %- (.+)$"
  if not artist or not track then
    return pb:sub(1, max_width)
  end

  -- get artist before first ","
  local artist_match = artist:match "([^,]+)"
  if not artist_match then
    return pb:sub(1, max_width)
  end

  local pb_main_artist = artist_match .. " - " .. track
  if #pb_main_artist <= max_width then
    return pb_main_artist
  end

  -- fallback, return track name (trimmed to max width)
  return track:sub(1, max_width)
end

-- gets the currently playing song from spotify
M.get_currently_playing = function(max_width, throttle)
  if utilities._wait(throttle, last_update) then
    return stored_playback
  end

  -- Check if we're in a context where we can run child processes
  local success, result = pcall(function()
    -- fetch playback using spotify-tui
    local home = os.getenv("HOME")
    if not home then
      return ""
    end

    local spt_path = "~/.cargo/bin/spotify_player"
    -- Check if the file exists before trying to run it
    local file = io.open(spt_path, "r")
    if not file then
      return ""
    end
    file:close()

    local success, pb, stderr = wez.run_child_process { spt_path, "get", "key", "playback" }
    if not success then
      if stderr then
        wez.log_error("Spotify error: " .. stderr)
      end
      return ""
    end
    return utilities._spt_parse(pb or "")
  end)

  if not success then
    -- If there was an error, just return empty string
    return ""
  end

  local res = format_playback(result, max_width)
  stored_playback = res
  last_update = os.time()

  return res
end

return M
