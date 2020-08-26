using FairyGUI;
using System;
using System.Collections;
using System.Collections.Generic;
using UObject = UnityEngine.Object;
using UnityEngine;


namespace LuaFramework
{
    public abstract class ResManagerBase
    {
        static ResManager _instance = null;

        public static ResManagerBase Instance
        {
            get
            {
                if (_instance == null)
                {
                    _instance = new ResManager();
                }
                return _instance;
            }
        }

        public abstract void LoadRes(string relative, Type type, Action<UObject> callback);

        protected string RelativePath2AssetPath(string relativePath)
        {
            return PathConfig.ToBundle_PATH + relativePath;
        }

    }



 //编辑器先使用 UnityEditor.AssetDatabase.LoadAssetAtPath
#if UNITY_EDITOR
    public class ResManager : ResManagerBase
    {
        protected const float delay = 0.1f;
        public override void LoadRes(string relative, Type type, Action<UObject> callback)
        {
            Timers.inst.Add(UnityEngine.Random.Range(0.05f, delay), 1, (time) => {
                string assetpath = RelativePath2AssetPath(relative);
                UObject uo = UnityEditor.AssetDatabase.LoadAssetAtPath(assetpath, type);
                if (uo == null)
                {
                    Log.Print(string.Format("<color=red>Asset Load Error:</color>{0}\n", assetpath));
                }
                callback(uo);
            });  
        }
    }
#else
    public class ResManager : ResManagerBase

    public override void LoadAsset(string relative, Type type, Action<UObject> callback)
    {
    
    }
#endif
}
