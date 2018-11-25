local mClass = import("./middleclass");


local Properties = {}

function Properties:__index(k)
    local getter = self.class.__instanceDict["get_" .. k];
    if getter ~= nil then
        return getter(self);
    end
end

function Properties:__newindex(k, v)
    local setter = self["set_" .. k];

    if setter ~= nil then
        setter(self, v);
    else
        local getter = self.class.__instanceDict["get_" .. k];
        if getter ~= nil then
            error("Property " .. k .. " is readonly!", 2);
        end
        rawset(self, k, v);
    end
end


local function Class(...)
    local class = mClass(...);
    local args = {...};
    if not args[2] then
        class = class:include(Properties);
    end
    return class;
end

return Class;