local OCPkgrPackageParser = import("./OCPkgrPackageParser");
local GithubRepo = import("git");

local shell = require("shell");

local fs = require("filesystem");
local Class = import("oop/Class");
local semver = import("semver");

local OCPkgr = Class("OCPkgr");
function OCPkgr:initialize()
    self.packagesDiscovered = {};

end

function OCPkgr:_pkg(packageDataOrPath)
    if type(packageDataOrPath) == "table" then
        return packageDataOrPath;
    else
        return OCPkgrPackageParser.parse(packageDataOrPath);
    end
end

function OCPkgr:installPackageManager(packageDataOrPath, dest);
    local pkg = self:_pkg(packageDataOrPath);
    print("installing oc-pkgr...");
    if pkg.packageDependancies then
        for k, v in pairs(pkg.packageDependancies) do
            self:installPackage(k, v, dest);
        end
    end
end


function OCPkgr:installPackage(githubPath, version, dest)
    version = version or "";
    dest = dest or 'usr';

    local repo = GithubRepo:new(githubPath);
    repo:findVersion(version);
--[[

    local pkgPath = "https://raw.githubusercontent.com/" .. githubPath .."/master/oc-pkgr.json";
    if version ~= "" then
        pkgPath = "https://raw.githubusercontent.com/" .. githubPath .."/" .. version .. "/oc-pkgr.json";
    end
    
    
    local fname = githubPath:gsub("/", "-")
    local targetPath = '/tmp/' .. fname ..  '-oc-pkgr.tmp.json';
    shell.execute('wget -f "' .. pkgPath .. '" "' .. targetPath .. '"');
    
    
    if not fs.exists(targetPath) then 
        print("could not get package file for " .. githubPath .. " #" .. (version or 'master'));
    else 
        local parsed, result = pcall(OCPkgrPackageParser.parse, targetPath);
        if not parsed then
            print("could not get package file for " .. githubPath .. " #" .. (version or 'master'));
        else
            print(result.name);
            
            
        end
        
    end
    
    
    if not self.packagesLoaded[githubPath] then
        
    end
    ]]
end

return OCPkgr;