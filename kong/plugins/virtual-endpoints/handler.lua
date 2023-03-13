-- Inspired by https://github.com/Optum/kong-service-virtualization
local access = require("kong.plugins.virtual-endpoints.access")
local KongServiceVirtualizationHandler = {}

KongServiceVirtualizationHandler.PRIORITY = 3000 --Execute before logging plugins and such as to not impact their real metrics
KongServiceVirtualizationHandler.VERSION = "0.3"

function KongServiceVirtualizationHandler:access(conf)
  access.execute(conf)
end

return KongServiceVirtualizationHandler
