-- Inspired by https://github.com/Optum/kong-service-virtualization
local Schema = require "kong.db.schema"
local typedefs = require "kong.db.schema.typedefs"

local request_schema = Schema.define {
  type = "record",
  fields = {
    { methods = { type = "array", elements = { type = "string" }, default = { "*" } } },
  }
}

local response_schema = Schema.define {
  type = "record",
  fields = {
    { status_code = { type = "number", default = 200 } },
    { content_type = { type = "string", default = "application/json" } },
    { data = { type = "string" } },
    { file_path = { type = "string" } },
    { 
      file_match = {
        type = "record",
        fields = {
          { request_path_prefix_to_remove = { type = "string" } },
          { target_path_prefix_to_add = { type = "string" } },
        }
      }
    }
  }
}

local config_schema = Schema.define {
  type = "record",
  fields = {
    {
      endpoints = {
        type = "array",
        elements = {
          type = "record",
          fields = {
            { request = request_schema },
            { response = response_schema }
          }
        },
        required = true
      }
    }
  },
}

return {
  name = "kong-virtual-endpoints",
  fields = {
    { protocols = typedefs.protocols_http },
    { config = config_schema }
  },
}
