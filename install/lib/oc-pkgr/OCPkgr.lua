local OCPkgrPackageParser = import("./OCPkgrPackageParser");
local GithubRepo = import("git");

local shell = require("shell");

local fs = require("filesystem");
local Class = import("oop/Class");
local semver = import("semver");
local json = import("json");

local transfer = import("tools/transfer")

local OCPkgr = Class("OCPkgr");
function OCPkgr:initialize()
    
end

function OCPkgr:_pkg(packageDataOrPath)
    if type(packageDataOrPath) == "table" then
        return packageDataOrPath;
    else
        return OCPkgrPackageParser.parse(packageDataOrPath);
    end
end

function OCPkgr:installPackageManager(packageDataOrPath, dest);
    self.packagesDiscovered = {};
    self.filesDiscovered = {};
    local pkg = self:_pkg(packageDataOrPath);
    self:discoverPackages(pkg.githubrepo, pkg.version);
--[[

    
    print("installing oc-pkgr...");
    
    if pkg.fileDependancies then
        for k, v in pairs(pkg.fileDependancies) do
            self.filesDiscovered[k] = v;
        end
    end
    
    if pkg.packageDependancies then
        for k, v in pairs(pkg.packageDependancies) do
            self:discoverPackages(k, v);
        end
    end
    ]]
    self:_doInstall(dest);
end

function OCPkgr:_doInstall(dest)

    for d, s in pairs(self.filesDiscovered) do
        shell.execute('wget -f "' .. s .. '" "' .. d .. '"');
    end
    
    for pkgName, info  in pairs(self.packagesDiscovered) do
        local tmpPath = "/usr/oc-pkgr/tmp/packages/" .. pkgName .. '/' .. info.sha;
        fs.makeDirectory(tmpPath);
        local repo = GithubRepo:new(pkgName);
        repo:checkout(tmpPath, info.sha);
        local pkg = self:_pkg(tmpPath .. '/oc-pkgr.json');
        print("Installing " .. pkgName .. "...");
        if pkg.install then
            for d,s in pairs(pkg.install) do
                
                local copyFrom = tmpPath .. '/' .. s;

                local copyTo;
                if d:sub(1,1) == '/' then 
                    copyTo = d;
                else 
                    copyTo = dest .. '/' .. d;
                end

                local toPath = fs.path(copyTo);
                local toName = fs.name(copyTo);
                if copyTo:sub(string.len(copyTo)) == '/' then
                    toPath = toPath .. '/' .. toName;
                end 

                fs.makeDirectory(toPath);

                local cpCmd = 'cp -r -f ' .. copyFrom ..' ' .. copyTo;
                print(cpCmd);
                shell.execute(cpCmd);
            end
        end
        print("");
    end
    shell.execute("rm -r /usr/oc-pkgr/tmp/packages/");
end

function OCPkgr:discoverPackages(githubPath, version)
    local repo = GithubRepo:new(githubPath);
    local versionInfo = repo:findVersion(version);
    if not versionInfo then
        error("Could not find " .. githubPath .. " " .. version);
    end

    local currentVersionInfo = self.packagesDiscovered[githubPath];
    local newFound = false;
    if currentVersionInfo == nil then
        self.packagesDiscovered[githubPath] = versionInfo;
        newFound = true;
    else
        local curFirst = tostring(currentVersionInfo.version):sub(1,1);
        local newFirst = tostring(versionInfo.version):sub(1,1);

        if tostring(versionInfo.version) == '@latest' then
            self.packagesDiscovered[githubPath] = versionInfo;
            newFound = true;
        elseif curFirst ~= '#' and newFirst == '#' then
            self.packagesDiscovered[githubPath] = versionInfo;
            newFound = true;
        elseif  curFirst ~= '#' and newFirst ~= '#' then
            if newFirst > curFirst then
                self.packagesDiscovered[githubPath] = versionInfo;
                newFound = true;
            end
        end
    end
    if newFound then
        local info = self.packagesDiscovered[githubPath];
        local s, pkgFile = pcall(repo.getFile, repo, info.sha, "oc-pkgr.json");

        if s then
            local pkg = json.decode(pkgFile);
            local pkgDeps = pkg.packageDependancies;
            if pkgDeps then
                for k, v in pairs(pkgDeps) do
                    self:discoverPackages(k, v);
                end
            end
            local fileDeps = pkg.fileDependancies;
            if fileDeps then
                for k, v in pairs(fileDeps) do
                    self.filesDiscovered[k] = v;
                end
            end
        end
        
    end
end

return OCPkgr;