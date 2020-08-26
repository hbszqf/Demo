using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class AppConst 
{

#if FOR_ART
    public const string DynamicAssetPathPrefix = "Assets/ResArt/DynamicArt/";//美术预览读取路径
#else
    public const string DynamicAssetPathPrefix = "Assets/Res/DynamicArt/";//真正程序的读取路径
#endif
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
