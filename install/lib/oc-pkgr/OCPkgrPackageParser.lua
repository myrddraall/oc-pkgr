local fs = require("filesystem");
local json = require("json");
local OCPkgrPackageParser = {};


OCPkgrPackageParser.parse = function(fileName)
    checkArg(1, fileName, "string");
    if not fs.exists(fileName) then
        error("File not found '" .. fileName .."'", 2);
    end

    local fh = fs.open(fileName, "r");
    if fh then
        local filecontent = fh:read(fs.size(fileName));
        fh:close();
        return json.decode(filecontent);
    end

end

return OCPkgrPackageParser;
