-- Inspired by https://github.com/Optum/kong-service-virtualization
local access = require("kong.plugins.virtual-endpoints.access")
local KongVirtualEndpointsHandler = {
  VERSION = "1.0.0",
  PRIORITY = 3000,
}

function KongVirtualEndpointsHandler:access(config)
  access.execute(config)
end

return KongVirtualEndpointsHandler
