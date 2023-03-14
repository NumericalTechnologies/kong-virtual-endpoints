local Schema = require "kong.db.schema"

local response_schema = Schema.define {
  type = "record",
  fields = {
    { status_code = { type = "number", default = 200 } },
    { content_type = { type = "string", default = "application/json" } },
    { data = { type = "string" } },
    { file_path = { type = "string" } }
  }
}

return response_schema