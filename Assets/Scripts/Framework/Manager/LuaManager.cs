using UnityEngine;
using System.Collections;
using LuaInterface;
using System.Threading;
using System.IO;
using System;

namespace LuaFramework {
    public class LuaManager : Manager {
        public LuaState lua;
        protected LuaLooper loop = null;
        protected bool isInitLuaOk = false;

        // Use this for initialization
        void Awake() {
            enabled = false;
            new LuaResLoader();
            lua = new LuaState();
            this.OpenLibs();
            lua.LuaSetTop(0);

            LuaBinder.Bind(lua);
            DelegateFactory.Init();
            LuaCoroutine.Register(lua, this);

            this.InitStart();
        }

        public void OnDestroy()
        {
            LuaFunction main = lua.GetFunction("Main.ReleaseMain");
            if (main!=null)
            {
                main.Call();
                main.Dispose();
                main = null;
            }
            this.Close();
        }


        public  void InitStart()
        {
            if (Application.isEditor && !AppConst.LuaBundleMode)
            {
                InitLuaPath();
                this.lua.Start();
                this.StartMain();
            }
            else
            {
                InitLuaBundle(() =>
                {
                    this.lua.Start();
                    this.StartMain();
                });
            }

            ////加载字体
            //ResTool2.Instance.LoadAsset("Common/font.ttf", typeof(UnityEngine.Object), (obj) =>
            //{
            //    Font font = obj as Font;
            //    if (font == null) {
            //        return;
            //    }

            //    var dynamicFont = new FairyGUI.DynamicFont(FairyGUI.UIConfig.defaultFont, font);
            //    var baseFont = FairyGUI.FontManager.GetFont(FairyGUI.UIConfig.defaultFont);
            //    if (baseFont != null)
            //    {
            //        FairyGUI.FontManager.UnregisterFont(baseFont);
            //    }

            //    FairyGUI.FontManager.RegisterFont(dynamicFont, FairyGUI.UIConfig.defaultFont);
            //});



        }

        public void StartMain()
        {
            //
            //JsonConfig.GetInstance().InitLua();

            //执行LuaProxy.StartMain
            lua.DoFile("Main.lua");
            LuaFunction main = lua.GetFunction("StartMain");
            main.Call();
            main.Dispose();
            main = null;
            enabled = true;
            isInitLuaOk = true;

            //启动LuaLooper
            loop = gameObject.AddComponent<LuaLooper>();
            loop.luaState = lua;

            Debug.Log("初始化lua完成 调用mian脚本");
        }

        public bool IsInitLuaOk()
        {
            return isInitLuaOk;
        }

        /// <summary>
        /// 初始化Lua代码加载路径
        /// </summary>
        void InitLuaPath()
        {
            lua.AddSearchPath(AppConst.LuaRoot);
            lua.AddSearchPath(AppConst.ToLuaRoot);
        }

       

        /// <summary>
        /// 初始化LuaBundle
        /// </summary>
        void InitLuaBundle(System.Action callback)
        {   
            //string   path = PathConfig.DataPath + PathConfig.CheckAndGetMixPath(AppConst.LuaFileBundleName + AppConst.ExtName);

            //AssetBundle ab = null;
            //if (PathConfig.GetIsMix())
            //{

            //    ab = AssetBundle.LoadFromMemory(Util.DecryptByByte(File.ReadAllBytes(path), VersionInfo.GetChannelInPackage()));
            //}
            //else
            //{
            //    ab = AssetBundle.LoadFromFile(path);
            //}
            
            //LuaFileUtils.Instance.AddSearchBundle(ab);
            //callback();
        }

        /// <summary>
        /// 初始化加载第三方库
        /// </summary>
        void OpenLibs()
        {
            //lua.OpenLibs(LuaDLL.luaopen_pb);      
            //lua.OpenLibs(LuaDLL.luaopen_sproto_core);
            //lua.OpenLibs(LuaDLL.luaopen_lpeg);
            //lua.OpenLibs(LuaDLL.luaopen_bit);
            //lua.OpenLibs(LuaDLL.luaopen_socket_core);
#if UNITY_STANDALONE_OSX || UNITY_EDITOR_OSX
            lua.OpenLibs(LuaDLL.luaopen_bit);
#endif
            //struct
            lua.OpenLibs(LuaDLL.luaopen_struct);

            //protobuf_c
           // lua.OpenLibs(LuaDLL.luaopen_protobuf_c);

            //cjson
            lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
            lua.OpenLibs(LuaDLL.luaopen_cjson);
            lua.LuaSetField(-2, "cjson");
            lua.OpenLibs(LuaDLL.luaopen_cjson_safe);
            lua.LuaSetField(-2, "cjson.safe");

#if UNITY_EDITOR
            //snapShot
            //lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
            //lua.OpenLibs(LuaDLL.luaopen_snapshot);
            //lua.LuaSetField(-2, "snapshot");
#endif


#if UNITY_EDITOR

            //if (LuaConst.openLuaSocket)
            //{
            //    OpenLuaSocket();
            //}
#endif
        }

        // Update is called once per frame
        public object CallFunction(string funcName, params object[] args) {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null) {
                func.BeginPCall();
                if (args != null)
                {
                    for (int i = 0; i < args.Length; i++)
                    {
                        func.PushGeneric(args[i]);
                    }
                }
                func.PCall();
                object ret1 = func.CheckValue<object>();
                func.EndPCall();
                return ret1;
            }
            return null;
        }

        public void LuaGC() {
            lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
        }

        public void Close() {
            if (loop != null)
            {
                loop.Destroy();
                loop = null;
            }

            lua.Dispose();
            lua = null;
        }



        public static int LuaOpen_Socket_Core(IntPtr L)
        {
            return LuaDLL.luaopen_socket_core(L);
        }

        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        public static int LuaOpen_Mime_Core(IntPtr L)
        {
            return LuaDLL.luaopen_mime_core(L);
        }

        public void OpenLuaSocket()
        {

            lua.BeginPreLoad();
            lua.RegFunction("socket.core", LuaOpen_Socket_Core);
            lua.RegFunction("mime.core", LuaOpen_Mime_Core);
            lua.EndPreLoad();
        }
    }

   
}