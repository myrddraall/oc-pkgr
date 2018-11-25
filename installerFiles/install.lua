local import = require('___import');
local oImport = _G.import;
_G.import = import;

local Class = import('./lib/oop/Class');

print("Hello!");

local class = Class("Test");

_G.import = oImport;