local Schema = require "kong.db.schema"

local request_schema = Schema.define {
  type = "record",
  fields = {
    { methods = { type = "array", elements = { type = "string" }, default = { "*" } } },
  }
}

return request_schema