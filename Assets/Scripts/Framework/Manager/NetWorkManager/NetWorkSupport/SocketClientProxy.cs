using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Threading;
using System.Text;

namespace LuaFramework {
    public class SocketClientProxy{
        private SocketClient socket;
        int slot;
        LuaFunction func = null;

        bool isApplicationQuit = false;

        SocketClient SocketClient {
            get { 
                if (socket == null)
                    socket = new SocketClient(this.slot);
                return socket;                    
            }
        }

        public SocketClientProxy(int slot) {
            this.slot = slot;
            this.socket = new SocketClient(slot);
        }

        public void SetActive(bool active)
        {
            socket.SetActive(active);
        }

        /// <summary>
        /// 
        /// </summary>
        public void Update() {

            while (true)
            {
                byte[] buff = SocketClient.Receive();
                if (buff == null)
                {
                    break;
                }
                CallMethod(Protocal.ReceivedMessage, buff);
            }
			SocketClient.Update();
        }

        /// <summary>
        /// ������������
        /// </summary>
        public void SendConnect(string host, int port, bool noDelay, LuaFunction func)
        {
            if (this.func != null && this.func != func)
            {
                this.func.Dispose();
                this.func = null;
            }
            this.func = func;
            SocketClient.Connect
                
                (host, port, noDelay,
            delegate (bool suc) {
                if (suc)
                {
                    CallMethod(Protocal.Connect, null);
                }
                else
                {
                    CallMethod(Protocal.ConnectFailed, null);
                } 
            },
            delegate () {
                CallMethod(Protocal.Disconnect, null);
            });
        }

        public void CallMethod(int key, byte[] data)
        {
            //Util.CallMethod("Network", "OnSocket", key, new LuaByteBuffer(data));
            //this

            this.func.BeginPCall();
            this.func.Push(key);
            if (data != null) {
                this.func.PushByteBuffer(data);
            }
            this.func.PCall();
            this.func.EndPCall();


        }

        /// <summary>
        /// �Ͽ�����
        /// </summary>
        public void Disconnect()
        {
            SocketClient.Close();
        }

        /// <summary>
        /// ����SOCKET��Ϣ
        /// </summary>
        public void SendMessage(byte[] buffer)
        {
            SocketClient.Send(buffer);
        }

        /// <summary>
        /// ��������
        /// </summary>
        public void OnDestroy() {
            if (isApplicationQuit)
            {
                SocketClient.SwitchToIdle();
            }
            else
            {
                SocketClient.Close();
            }
            
        }

        public void OnApplicationQuit() {
            isApplicationQuit = true;
        }
    }
}