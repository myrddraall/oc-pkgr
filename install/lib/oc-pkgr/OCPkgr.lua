local OCPkgrPackageParser = import("./OCPkgrPackageParser");
local GithubRepo = import("git");
local Class = import("oop/Class");


local OCPkgr = Class("OCPkgr");
function OCPkgr:initialize()
    self.packagesLoaded = {};
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


function installPackage(githubPath, version, dest)
    if not self.packagesLoaded[githubPath] then

    end
end

return OCPkgr;