function class(classname,super)
    local cls = {}

     
    if super then
        for k,v in pairs(super) do
            cls[k] = v
        end
    end

    local function dispose(self)
        if self.isDisposed then return end
        cls.dispose(self)
        rawset(self, "isDisposed", true)
    end

    cls.__cname = classname

    if classname then
        local tlName  = string.split(classname,'.')
        cls.shortName = tlName[#tlName]
    end

    cls.__index = cls
    cls.super = super
    cls.ctor  = cls.ctor or  function()  end
    cls.new = function(...)
        local instance = {}
        setmetatable(instance,cls)
        if instance.ctor then
            instance.ctor(instance,...)
        end
        instance.dispose = dispose 
        return instance
    end
    return cls
end