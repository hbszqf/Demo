Log = import(".Log")

if UnityEngine.Debug.isDebugBuild then
    --普通打印
    Log.Print:SetIsEnable(false):SetColor("#23A8FF")
    Log.QF:SetIsEnable(true):SetColor("Purple")  
end

