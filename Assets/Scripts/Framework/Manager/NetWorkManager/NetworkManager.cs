using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Threading;
using System.Text;

namespace LuaFramework
{
    public class NetworkManager : Manager
    {

        Dictionary<int, SocketClientProxy> socketClientProxyDict = new Dictionary<int, SocketClientProxy>();
        private SocketClientProxy GetSocketClientProxy(int slot)
        {
            if (!socketClientProxyDict.ContainsKey(slot))
            {
                var proxy = new SocketClientProxy(slot);
                proxy.SetActive(_quickMode);
                socketClientProxyDict.Add(slot, proxy);
            }
            return socketClientProxyDict[slot];
        }

        /// <summary>
        /// 如果 不是 快速模式, socket上没有数据时候, 线程会至少休眠100ms
        /// </summary>
        [SerializeField]
        private bool _quickMode = true;
        public bool QuickMode
        {
            get
            {
                return _quickMode;
            }
            set
            {
                _quickMode = value;
                foreach (var item in socketClientProxyDict)
                {
                    item.Value.SetActive(value);
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        void Update()
        {

            foreach (var item in socketClientProxyDict)
            {
                item.Value.Update();
            }

        }

        /// <summary>
        /// 析构函数
        /// </summary>
        void OnDestroy()
        {
            foreach (var item in socketClientProxyDict)
            {
                item.Value.OnDestroy();
            }
        }

        private void OnApplicationQuit()
        {
            foreach (var item in socketClientProxyDict)
            {
                item.Value.OnApplicationQuit();
            }
        }

        /// <summary>
        /// 发送链接请求
        /// </summary>
        public void SendConnect(string host, int port, bool noDelay, LuaFunction func, int slot = 0)
        {
            SocketClientProxy proxy = GetSocketClientProxy(slot);
            proxy.SendConnect(host, port, noDelay, func);
        }





        /// <summary>
        /// 断开连接
        /// </summary>
        public void Disconnect(int slot = 0)
        {
            SocketClientProxy proxy = GetSocketClientProxy(slot);
            proxy.Disconnect();
        }

        /// <summary>
        /// 发送SOCKET消息
        /// </summary>
        public void SendMessage(byte[] buffer, int slot = 0)
        {
            SocketClientProxy proxy = GetSocketClientProxy(slot);
            proxy.SendMessage(buffer);
        }

        /// <summary>
        /// 统计接口
        /// </summary>
        public void RecordLogEvent(string url, WWWForm dataForm)
        {
            //Debug.Log(System.Text.Encoding.UTF8.GetString(dataForm.data));
            StartCoroutine(SendRequest(url, dataForm));
        }

        /// <summary>
        /// 发送数据请求给后台
        /// </summary>
        IEnumerator SendRequest(string url, WWWForm dataForm)
        {
            WWW www = new WWW(url, dataForm);
            yield return www;
            if (www.error != null)
            {
                Debug.Log("请求HTTP失败：" + www.error);
            }
            else
            {

            }
            www.Dispose();
            yield break;
        }

    }
}