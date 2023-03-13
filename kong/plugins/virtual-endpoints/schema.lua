-- Inspired by https://github.com/Optum/kong-service-virtualization
local typedefs = require "kong.db.schema.typedefs"
local config_scheme = require("kong.plugins.virtual-endpoints.typedefs.config")

return {
  name = "kong-virtual-endpoints",
  fields = {
    { protocols = typedefs.protocols_http },
    { config = config_scheme }
  },
}
