-- Inspired by https://github.com/NumericalTechnologies/kong-service-virtualization
local typedefs = require "kong.db.schema.typedefs"

return {
  name = "kong-virtual-endpoints",
  fields = {
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { virtual_tests = { type = "string", required = true }, },
    }, }, },
  },
}
