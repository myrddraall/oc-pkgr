local fs = require("filesystem");
local shell = require("shell");
local OCPkgrFileDownloadUtil = {};

OCPkgrFileDownloadUtil.downloadInstallDependancies = function(package)
    local installDependancies = package.installDependancies;
    if installDependancies then
        for k, v in pairs(installDependancies) do
            local targetPath = fs.path(k);
            fs.makeDirectory(targetPath);
            shell.execute('wget -f "' .. v .. '" "' .. k .. '"');
        end
    end


end


return OCPkgrFileDownloadUtil;