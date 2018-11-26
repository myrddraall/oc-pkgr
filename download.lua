local fs = require("filesystem");
local shell = require("shell");

fs.makeDirectory("/usr/lib/");

fs.makeDirectory("/usr/lib/oc-pkgr-tmp/");

shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-lib/master/lib/json.lua" "/usr/lib/json.lua"');
package.loaded["json"] = nil;

shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-pkgr/master/install/lib/oc-pkgr/OCPkgrPackageParser.lua" "/usr/lib/oc-pkgr-tmp/OCPkgrPackageParser.lua"');
--shell.execute('cp "./install/lib/oc-pkgr/OCPkgrPackageParser.lua" "/usr/lib/oc-pkgr-tmp/OCPkgrPackageParser.lua"');


shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-pkgr/master/install/lib/oc-pkgr/OCPkgrFileDownloadUtil.lua" "/usr/lib/oc-pkgr-tmp/OCPkgrFileDownloadUtil.lua"');
--shell.execute('cp "./install/lib/oc-pkgr/OCPkgrFileDownloadUtil.lua" "/usr/lib/oc-pkgr-tmp/OCPkgrFileDownloadUtil.lua"');

shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-pkgr/master/install/lib/oc-pkgr/OCPkgr.lua" "/usr/lib/oc-pkgr-tmp/OCPkgr.lua"');

shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-pkgr/master/oc-pkgr.json" "/tmp/oc-pkgr.json"');
--shell.execute('cp "./oc-pkgr.json" "/tmp/oc-pkgr.json"');
shell.execute('wget -f "https://raw.githubusercontent.com/myrddraall/oc-lib/master/bin/copy.lua" "/usr/bin/copy.lua"');

package.loaded["oc-pkgr-tmp/OCPkgrPackageParser"] = nil;
local parser = require("oc-pkgr-tmp/OCPkgrPackageParser");
local packageData = parser.parse("/tmp/oc-pkgr.json");

package.loaded["oc-pkgr-tmp/OCPkgrFileDownloadUtil"] = nil;
local dl = require("oc-pkgr-tmp/OCPkgrFileDownloadUtil");
dl.downloadInstallDependancies(packageData);

require("import");
import.clearCache();

package.loaded["oc-pkgr-tmp/OCPkgr"] = nil;
local OCPkgr = import("oc-pkgr-tmp/OCPkgr");
package.loaded["oc-pkgr-tmp/OCPkgr"] = nil;
local pkgMan = OCPkgr:new();

pkgMan:installPackageManager(packageData);

shell.execute("rm -r /usr/lib/oc-pkgr-tmp");

os.sleep(2);
shell.execute('reboot');