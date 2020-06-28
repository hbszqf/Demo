using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class AppConst 
{
    public const string DynamicAssetPathPrefix = "Assets/Res/Dynamic/";//读取Dynamic Asset的文件路径前缀
    public const string FairyGUIEditorOutPut =   DynamicAssetPathPrefix + "FairyGUI/";//读取Dynamic Asset的文件路径前缀
    static public  bool LuaBundleMode = false;    // 是否使用luaab


    public static string FrameworkRoot
    {
        get
        {
            return Application.dataPath + "/3rd/tolua";
        }
    }


    public static string LuaRoot
    {
        get
        {
            return Application.dataPath + "/Lua";
        }
    }

    public static string ToLuaRoot
    {
        get
        {
            return FrameworkRoot + "/ToLua/Lua";
        }
    }
}
