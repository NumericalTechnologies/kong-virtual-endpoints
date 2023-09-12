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

local function respond_with_file(file_path, status_code, content_type)
  local file = io.open(file_path, "rb")
  if (file == nil) then
    return kong.response.exit(500, { message = "Cannot find file at " .. file_path })
  end

  local current = file:seek()      -- get current position
  local size = file:seek("end")    -- get file size
  file:seek("set", current)        -- restore position

  local data = file:read("*all")
  return kong.response.exit(status_code, data, {['Content-Type'] = content_type, ['Content-Length'] = size})
end

local function respond_virtually(response_config)
  if (response_config.data == nil and response_config.file_path == nil and response_config.file_match == nil) then
    return kong.response.exit(500, { message = "config.data or config.file_path or config.file_match must be defined." })
  end

  if (response_config.data) then
    return kong.response.exit(response_config.status_code, response_config.data, {['Content-Type'] = response_config.content_type})
  elseif (response_config.file_path) then
    return respond_with_file(response_config.file_path, response_config.status_code, response_config.content_type)
  elseif (response_config.file_match) then
    local file_match = response_config.file_match
    local path = kong.request.get_path()

    local request_path_prefix_to_remove = file_match.request_path_prefix_to_remove
    if (request_path_prefix_to_remove) then
      local start_of_prefix, end_of_prefix = string.find(path, request_path_prefix_to_remove)
      local found = start_of_prefix <= end_of_prefix
      local has_path_after_prefix = end_of_prefix and end_of_prefix + 1 <= string.len(path)
      if (found and has_path_after_prefix) then
        path = string.sub(path, end_of_prefix + 1)
      end
    end

    local target_path_prefix_to_add = file_match.target_path_prefix_to_add
    if (target_path_prefix_to_add) then
      path = target_path_prefix_to_add .. path
    end

    return respond_with_file(path, response_config.status_code, response_config.content_type)
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
