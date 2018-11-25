local fs = require("filesystem");
local shell = require("shell");

fs.makeDirectory("/usr/lib/");

fs.makeDirectory("/usr/lib/oc-pkgr-tmp/");

shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-lib/master/lib/json.lua" "/usr/lib/json.lua"');
package.loaded["json"] = nil;

--shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-pkgr/master/install/lib/oc-pkgr/OCPkgrPackageParser.lua" "/usr/lib/oc-pkgr-tmp/OCPkgrPackageParser.lua"');
shell.execute('cp "./install/lib/oc-pkgr/OCPkgrPackageParser.lua" "/usr/lib/oc-pkgr-tmp/OCPkgrPackageParser.lua"');


--shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-pkgr/master/install/lib/oc-pkgr/OCPkgrFileDownloadUtil.lua" "/usr/lib/oc-pkgr-tmp/OCPkgrFileDownloadUtil.lua"');
shell.execute('cp "./install/lib/oc-pkgr/OCPkgrFileDownloadUtil.lua" "/usr/lib/oc-pkgr-tmp/OCPkgrFileDownloadUtil.lua"');

--shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-pkgr/master/oc-pkgr.json" "/tmp/oc-pkgr.json"');
shell.execute('cp "./oc-pkgr.json" "/tmp/oc-pkgr.json"');

package.loaded["oc-pkgr/OCPkgrPackageParser"] = nil;
local parser = require("oc-pkgr-tmp/OCPkgrPackageParser");
local packageData = parser.parse("/tmp/oc-pkgr.json");

package.loaded["oc-pkgr-tmp/OCPkgrFileDownloadUtil"] = nil;
local dl = require("oc-pkgr-tmp/OCPkgrFileDownloadUtil");
dl.downloadInstallDependancies(packageData);

--[[

    local os = require("os");
    local pkgrJson;
    
    local jsonLibLoaded, jsonLib = pcall(require, "json");
    
    print("Installing oc-pkgr");
    
    if not jsonLibLoaded then
        print("Downloading JSON Lib...");
        fs.makeDirectory("/tmp/oc-pkgr/");
        shell.execute('wget -fq "https://raw.githubusercontent.com/myrddraall/oc-lib/master/lib/json.lua" "/tmp/lib/json.lua"');
        package.loaded["json"] = nil;
        jsonLib = require("json");
        print("done.");
    end
    
    local cwd = shell.resolve("./");
    
    print('cwd: ' .. cwd);
    
    local localPkgrPath = fs.concat(cwd, "oc-pkgr.json");
    
    if fs.exists(localPkgrPath) then
        print("Found local oc-pkgr.json");
        pkgrJson = localPkgrPath;
    else 
        print("Downloading oc-pkgr.json...");
        fs.makeDirectory("/tmp/oc-pkgr/");
        shell.execute('wget -fq "https://raw.githubusercontent.com/myrddraall/oc-pkgr/master/oc-pkgr.json" "/tmp/oc-pkgr/oc-pkgr.json"');
        pkgrJson = "/tmp/oc-pkgr/oc-pkgr.json";
        print("done.");
    end 
    
    local pkg = "";
    local pkgHandle = fs.open(pkgrJson, "r");
    local chunk = pkgHandle:read(100);
    while chunk  do
        pkg = pkg .. chunk;
        chunk = pkgHandle:read(100);
    end
    pkgHandle:close();
    
    
    local pkjObj = jsonLib.decode(pkg);
    
    local installFiles = pkjObj.installFiles;
    --[[
        
        local env = _G;
        print(env);
        for k,v in pairs(env) do
            print(k);
        end
        ]]
        --[[

            
            fs.remove("/tmp/oc-pkgr/install");
            
            for k,v in pairs(installFiles) do
                local localPath = fs.concat(cwd, "installerFiles", k);
                local dir = fs.path(k);
                local name = fs.name(k);
                local tmpDir = fs.concat("/tmp/oc-pkgr/install", dir);
                local tmpPath = fs.concat(tmpDir, name);
                
                
                fs.makeDirectory(tmpDir);
                
                if fs.exists(localPath) then
                    print('Copy ' .. localPath .. ' to ' .. tmpPath);
                    fs.remove(tmpPath);
                    fs.copy(localPath, tmpPath);
                else 
                    print("Downloading " .. k .. "...");
                    shell.execute('wget -fq "' .. v .. '" "' .. tmpPath ..'"');
                    print("done.");
                end
            end
            
            shell.execute('ls -al /tmp/oc-pkgr/install');
            shell.execute('cd /tmp/oc-pkgr/install && ./install');
            ]]