local base = import(".base")
local M = class(..., base)


function M:OnEnter()
    CorUtil.StartCor(function(corUtil)
        --Network.Disconnect()
        
    end)
end







return M