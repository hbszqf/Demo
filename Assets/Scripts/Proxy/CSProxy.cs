﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaFramework;
using LuaInterface;
using UObject = UnityEngine.Object;
using System.IO;

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
                func.Call(GameObject.Instantiate<Object>(obj));
                //func.Call(obj);
                func.Dispose();
                func = null;
            }
        });    
    }

    public static bool GetIsShenHe()
    {
        return false;
    }
    public static void LoadScene()
    { 
    
    }


    //发送数据
    public static void SendNetMessage(byte[] strBuffer, int slot = 0)
    {
        NetworkManager netManager = AppFacade.Instance.GetManager<NetworkManager>();

        netManager.SendMessage(strBuffer, slot);
    }

    //请求连接
    public static void SendNetConnect(string host, int port, bool noDelay, LuaFunction func, int slot = 0)
    {
        NetworkManager netManager = AppFacade.Instance.GetManager<NetworkManager>();
        netManager.SendConnect(host, port, noDelay, func, slot);
    }

    public static void NetDisconnect(int slot = 0)
    {
        NetworkManager netManager = AppFacade.Instance.GetManager<NetworkManager>();
        netManager.Disconnect(slot);
    }

    public static string PbPath
    {
#if UNITY_EDITOR 
        get { return Application.dataPath + "/" + "ResArt" + "/DynamicArt/Protobuf"; }
#else
        get { return DataPath + "Protobuf"; }
#endif
    }

    static public LuaByteBuffer LoadFile(string path)
    {
        //if (false)
        //{
        //    byte[] ba = File.ReadAllBytes(path);
        //    return new LuaByteBuffer(Util.DecryptByByte(ba, VersionInfo.GetChannelInPackage()));
        //}
        //else
        //{
        //    return new LuaByteBuffer(File.ReadAllBytes(path));
        //}
        return new LuaByteBuffer(File.ReadAllBytes(path));
    }
}
