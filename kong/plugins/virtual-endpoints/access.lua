-- Inspired by https://github.com/Optum/kong-service-virtualization
local _M = {}
local kong = kong

local function array_contains(array, value_to_find)
  if type(array) ~= "table" then 
    kong.log.err("An array is expected." .. " Got: " .. array) 
    return false
  end

  for _, value in ipairs(array) do
    if value == value_to_find then return true end
  end

  return false
end

local function respond_virtually(response_config)
  if (response_config.data == nil and response_config.file_path == nil) then
    return kong.response.exit(500, { message = "config.data or config.file_path must be defined." })
  end

  ngx.header["Content-Type"] = response_config.content_type

  if (response_config.data) then
    return kong.response.exit(response_config.status_code, response_config.data, {['Content-Type'] = response_config.content_type})
  elseif (response_config.file_path) then
    local file = io.open(response_config.file_path, "rb")
    if (file == nil) then
      return kong.response.exit(500, { message = "Cannot find file at " .. response_config.file_path })
    end

    local current = file:seek()      -- get current position
    local size = file:seek("end")    -- get file size
    file:seek("set", current)        -- restore position

    local data = file:read("*all")
    return kong.response.exit(response_config.status_code, data, {['Content-Type'] = response_config.content_type, ['Content-Length'] = size})
  end
end

function _M.execute(config)
  local endpoints = config.endpoints
  for index, endpoint in ipairs(endpoints) do
    local request_config = endpoint.request
    local response_config = endpoint.response
    local methods = request_config.methods

    if (array_contains(methods, "*") or array_contains(methods, ngx.req.get_method())) then
      return respond_virtually(response_config)
    end
  end

  return kong.response.exit(404, { message = "None of the endpoints matched." })
end

return _M
