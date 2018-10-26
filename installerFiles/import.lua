local function import(module)
    if module:sub(1, 1) == "." then
      local fs = require("filesystem")
      local basePath = fs.path(debug.getinfo(3).source:sub(2))
      module = fs.concat(basePath, module)
    end
    local imported;
    if module:sub(1, 1) == "/" then
      local oPath = package.path;
      package.path = "?.lua"
      imported = require(module)
      package.path = oPath
    else
      imported = require(module)
    end
    if importDevMode.enabled then
      package.loaded[module] = nil
    end
    return imported
  end

  return import;