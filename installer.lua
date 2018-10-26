local fs = require("filesystem");
local shell = require("shell");
local pkgrJson;

local jsonLibLoaded, jsonLib = pcall(require, "json");

if not jsonLibLoaded then
    fs.makeDirectory("/tmp/oc-pkgr/");
    shell.execute('wget -fq "https://raw.githubusercontent.com/rater193/OpenComputers-1.7.10-Base-Monitor/master/lib/json.lua" "/lib/json.lua"');
    package.loaded["json"] = nil;
    jsonLib = require("json");
end

if fs.exists("./oc-pkgr.json") then
    pkgrJson = "./oc-pkgr.json";
else 
    fs.makeDirectory("/tmp/oc-pkgr/");
    shell.execute('wget -fq "https://raw.githubusercontent.com/myrddraall/oc-pkgr/master/oc-pkgr.json" "/tmp/oc-pkgr/oc-pkgr.json"');
    pkgrJson = "/tmp/oc-pkgr/oc-pkgr.json";
end 

local pkg = "";
local pkgHandle = fs.open(pkgrJson, "r");
local chunk = pkgHandle:read(100);
while chunk  do
    pkg = pkg .. chunk;
    chunk = pkgHandle:read(100);
end
pkgHandle:close();
print(pkg);