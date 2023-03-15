-- Inspired by https://github.com/Optum/kong-service-virtualization
local access = require("kong.plugins.virtual-endpoints.access")
local KongVirtualEndpointsHandler = {
  VERSION = "1.0.0",
  PRIORITY = 1028,
}

function KongVirtualEndpointsHandler:access(config)
  access.execute(config)
end

return KongVirtualEndpointsHandler
