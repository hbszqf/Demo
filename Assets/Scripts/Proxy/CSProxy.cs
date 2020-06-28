using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaFramework;
using LuaInterface;
using UObject = UnityEngine.Object

public class CSProxy 
{
    public static void LoadRes(string relativePath, LuaFunction func)
    {
        ResManager.Instance.LoadRes(relativePath, typeof(UObject), (obj) =>
        {
            if (obj == null)
            {
                Debug.LogErrorFormat("加载失败:{0}", relativePath);
            }

            if (func != null)
            {
                func.Call(obj);
                func.Dispose();
                func = null;
            }
        });    
    }
}
