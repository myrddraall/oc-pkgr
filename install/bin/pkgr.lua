local argparse = import('argparse');
import.clearCache();

local parser = argparse("pkgr", "package manager for OpenComputers")

local installCmd = parser:command ("install", "Install a pkgr package from github");
installCmd:argument("package", "the package to checkout eg: 'githubuser/repo'");
installCmd:option('--dest', "specify a path to install the package to"):default('/');
installCmd:option('--lib', "specify a path to where libraries should be installed to"):default('/usr');

local infoCmd = parser:command ("info", "print the info about a package");
infoCmd:argument("package", "the package to checkout eg: 'githubuser/repo'");

local args = parser:parse({...});

if args.info == true then
    local OCPkgr = import("oc-pkgr/OCPkgr");
    local pkgrMan = OCPkgr:new();
    local parts = string.split(args.package, "@", 2);
    local info = pkgrMan:getPackageInfo(parts[1], parts[2]);
    print('');
    print(info);
    print('');
elseif args.install == true then
    local OCPkgr = import("oc-pkgr/OCPkgr");
    local pkgrMan = OCPkgr:new();
    local parts = string.split(args.package, "@", 2);
    pkgrMan:installPackage(parts[1], parts[2], args.lib, args.dest);
end

--
