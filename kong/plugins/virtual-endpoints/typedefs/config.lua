local Schema = require "kong.db.schema"
local request_scheme = require("kong.plugins.virtual-endpoints.typedefs.request")
local response_scheme = require("kong.plugins.virtual-endpoints.typedefs.response")

local config_schema = Schema.define {
  type = "record",
  fields = {
    {
      endpoints = {
        type = "array",
        elements = {
          type = "record",
          fields = {
            { request = request_scheme },
            { response = response_scheme }
          }
        },
        required = true
      }
    }
  },
}

return config_schema