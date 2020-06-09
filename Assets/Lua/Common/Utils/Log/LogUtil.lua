Log = import(".Log")

if UnityEngine.Debug.isDebugBuild then
     --普通打印
    Log.Print:SetIsEnable(true):SetColor("#23A8FF")
    Log.QF:SetIsEnable(false):SetColor("orange")  
end

