using UnityEngine;
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using LuaFramework;
using LuaInterface;
//using System.Collections.Concurrent;


public class SocketClient
{
    enum State
    {
        Idle = 1,  //空闲
        TryConnect = 2,  //将连接
        Connected = 3,      //已连接
    }

    /// <summary>
    /// 头长度
    /// </summary>
    const int headSize = 4;

    /// <summary>
    /// Tcp客户端
    /// </summary>
    private TcpClient client = null;
    /// <summary>
    /// Tcp客户端的流
    /// </summary>
    private NetworkStream stream = null;

    /// <summary>
    /// 当前状态
    /// </summary>
    private State state = State.Idle;

    /// <summary>
    /// 写线程
    /// </summary>
    private Thread writeThread = null;
    /// <summary>
    /// 读线程
    /// </summary>
    private Thread readThread = null;

    /// <summary>
    /// 开始连接的时间
    /// </summary>
    private float startTime = 0;

    /// <summary>
    /// 连接回调
    /// </summary>
    private Action<bool> connectCallback = null;

    /// <summary>
    /// 断线回调
    /// </summary>
    private Action disconnectCallback = null;

    //byte[] sendBuff = new byte[64*1024];

    /// <summary>
    /// 读取的数据队列
    /// </summary>
    private ConcurrentByteArrayQueue readQueue = new ConcurrentByteArrayQueue();

    /// <summary>
    /// 写入的数据队列
    /// </summary>
    public ConcurrentByteArrayQueue writeQueue = new ConcurrentByteArrayQueue();

    int slot;
    public SocketClient(int slot)
    {
        this.slot = slot;
    }

    private int active = 1;
    /// <summary>
    /// 设置是否生效
    /// </summary>
    /// <param name="active"></param>
    public void SetActive(bool active)
    {
        this.active = active ? 1 : 0;
    }

    /// <summary>
    /// 连接服务器
    /// </summary>
    public void Connect(string host, int port, bool noDelay, Action<bool> callback, Action dis)
    {

        Debug.Assert(state == State.Idle);
        if (state != State.Idle)
        {
            return;
        }

        state = State.TryConnect;
        startTime = Time.time;
        connectCallback = callback;
        disconnectCallback = dis;


        IPAddress[] address = null;
        AddressFamily family = AddressFamily.InterNetwork;
        if (CSProxy.GetIsShenHe())
        {
            address = Dns.GetHostAddresses(host);
            if (address.Length <= 0)
            {
                family = AddressFamily.InterNetwork;
            }
            else
            {
                if (address[0].AddressFamily == AddressFamily.InterNetworkV6)
                {
                    //Debug.Log("SocketClient.Connect InterNetworkV6");
                    family = AddressFamily.InterNetworkV6;
                }
            }
        }
        
        client = null;
        client = new TcpClient(family);
        client.SendTimeout = 0;
        client.ReceiveTimeout =0;
        client.NoDelay = noDelay;

        client.SendBufferSize = 65536;
        client.Client.SendBufferSize = 65536;
        client.ReceiveBufferSize = 65536;
        client.Client.ReceiveBufferSize = 65536;

        //client.BeginConnect(host,port);
        //client.
        TcpClient localClient = client;
        var loom = Loom.Current;
        if (family == AddressFamily.InterNetwork)
        {
            client.BeginConnect(host, port, delegate (IAsyncResult asr)
            {
                //中止连接请求
                localClient.EndConnect(asr);

                Loom.QueueOnMainThread(() =>
                {
                    if (localClient != client)
                    {
                        return;
                    }

                    bool suc = client.Connected;
                    //连接成功
                    OnConnect(suc);
                    //回调
                    callback(suc);


                });
            }, null);
        }
        else
        {
            client.BeginConnect(address, port, delegate (IAsyncResult asr)
            {
                //中止连接请求
                localClient.EndConnect(asr);

                Loom.QueueOnMainThread(() =>
                {
                    if (localClient != client)
                    {
                        return;
                    }

                    bool suc = client.Connected;
                    //连接成功
                    OnConnect(suc);
                    //回调
                    callback(suc);


                });
            }, null);
        }
        

    }

    /// <summary>
    /// 发送数据
    /// </summary>
    public void Send(byte[] body)
    {
        if (state == State.Connected)
        {
            writeQueue.Enqueue(body);
        }
    }

    /// <summary>
    /// 接收数据
    /// </summary>
    /// <returns></returns>
    public byte[] Receive()
    {
        if (readQueue.Count == 0)
        {
            return null;
        }
        return readQueue.Dequeue();
    }

    /// <summary>
    /// 关闭socket
    /// </summary>
    public void Close()
    {
        if (state == State.TryConnect  )
        {
            SwitchToIdle();
            connectCallback(false);
            return;
        }
        if (state == State.Connected && client.Client.Connected == true)
        {
            SwitchToIdle();
            disconnectCallback();
            return;
        }
    }


    public void Update()
    {
        if (state == State.TryConnect)
        {
            bool idle = false;
            if( Time.time - startTime > 10 )
            {
                idle = true;
            }

            if (Application.internetReachability == NetworkReachability.NotReachable)
            {
                idle = true;
            }

            if (idle)
            {
                SwitchToIdle();
                connectCallback(false);
            }
            
        }

        if ( state == State.Connected  )
        {
            bool idle = false;
            if (client.Connected == false)
            {
                idle = true;
            }
            if (idle)
            {
                SwitchToIdle();
                //回调
                this.disconnectCallback();
            }
            
        }
    }

    public void SwitchToIdle() {
        //清空相关数据
        if (client != null)
        {
            try
            {
                client.Close();
            }
            catch (Exception)
            {
            }
        }

        //等待线程退出
        /*
        if (writeThread != null)
        {
            writeThread.Join();
        }

        if (readThread != null) {
            readThread.Join();
        }
        */
        
        client = null;
        writeThread = null;
        readThread = null;
        readQueue.Clear();
        writeQueue.Clear();

        readQueue = new ConcurrentByteArrayQueue();
        writeQueue = new ConcurrentByteArrayQueue();
        //切换状态
        state = State.Idle;
        

    }

    private void OnConnect(bool suc)
    {
        if (!suc)
        {
            client = null;
            stream = null;
            state = State.Idle;
            return;

        }

        //状态
        state = State.Connected;

        //启动读写线程
        writeThread = new Thread(new ParameterizedThreadStart(WriteAction));
        readThread = new Thread(new ParameterizedThreadStart(ReadAction));
        writeThread.Start(writeQueue);
        readThread.Start(readQueue);
    }

    /// <summary>
    /// 主线程中打印
    /// </summary>
    /// <param name="obj"></param>
    void PrintOnMainThread(object obj)
    {
        Loom.QueueOnMainThread(() =>
        {
            Log.Print(obj);
        });
    }


    /// <summary>
    /// 写线程
    /// </summary>
    private void WriteAction(object queue)
    {
        string excption = "";
        try
        {
            var writeQueue = queue as ConcurrentByteArrayQueue;
            WriteActionInner(writeQueue);
        }
        catch (Exception e)
        {

            //PrintOnMainThread(e.ToString());
            excption = e.ToString();
        }

        PrintOnMainThread(string.Format("Socket:{0} Exit WriteAction :{1}", this.slot, excption));
    }

    /// <summary>
    /// 写线程
    /// </summary>
    private void WriteActionInner(ConcurrentByteArrayQueue writeQueue)
    {
        NetworkStream stream = client.GetStream();
        TcpClient localClient = client;
        byte[] head = new byte[1024];
        

        long ticks = DateTime.Now.Ticks;

        var queue = writeQueue;
        while (true)
        {            
            byte[] body = queue.Dequeue();

            //没数据 
            if (body == null)
            {

                //退出
                if (localClient.Connected == false)
                {
                    return;
                }

                //等待15ms
                this.Sleep(15);

                continue;
            }

            
            while (head.Length < body.Length + headSize)
            {
                head = new byte[head.Length + 1024];
            }

            //有数据
            Int2ByteArray(body.Length, head);


            Array.Copy(body, 0, head, headSize, body.Length);

            if (!WriteBuff(head, body.Length + headSize))
            {
                return;
            }

            //Thread.VolatileWrite(ref this.writeTimes, times);
            //Thread.VolatileWrite(ref this.writeSize, Thread.VolatileRead(ref this.writeSize) + body.Length + 4);
            //if (!WriteBuff(body))
            {
            //    return;
            }

            
        }
    }

    private bool WriteBuff(byte[] buff, int length = 0)
    {
        int total = length;
        if (total == 0)
        {
            total = buff.Length;
        }
        
        int left = total;
        Socket socket = this.client.Client;
        while (left > 0)
        {
            int readed = socket.Send(buff, total - left, left, SocketFlags.None);
            left -= readed;
            if (readed < 1 && socket.Connected == false)
            {
                return false;
            }
        }
        return true;
    }

    /// <summary>
    /// 读线程
    /// </summary>
    private void ReadAction(object queue)
    {
        string excption = "";
        try
        {
            var writeQueue = queue as ConcurrentByteArrayQueue;
            ReadActionInner(writeQueue);
        }
        catch (Exception e)
        {
            excption = e.ToString();
            //PrintOnMainThread(e.ToString());
        }

        //PrintOnMainThread("Exit ReadAction");
        PrintOnMainThread(string.Format("Socket:{0} Exit ReadAction : {1} ", this.slot, excption));
    }

    /// <summary>
    /// 读线程
    /// </summary>
    private void ReadActionInner(ConcurrentByteArrayQueue readQueue)
    {
        Thread.Sleep(100);
        byte[] head = new byte[headSize];
        NetworkStream stream = client.GetStream();
        
        TcpClient localClient = client;

        var queue = readQueue;
        while (true)
        {
            //读取头信息
            int bodySize = 0;
            {
                if (!ReadBuff(head))
                {
                    return;
                }

                //计算bodySize
                bodySize = ByteArray2Int(head);
            }

            //读取具体数据
            {
                byte[] body = new byte[bodySize];
                if (!ReadBuff(body))
                {
                    return;
                }

                queue.Enqueue(body);

                //long newTick = DateTime.Now.Ticks;
                //PrintOnMainThread("read:" + bodySize  + ", " + (newTick - ticks));
                //ticks = newTick;
            }
        }
    }

    void Sleep(int ms) {

        int active = Thread.VolatileRead(ref this.active);
        if (active != 0)
        {
            Thread.Sleep(ms);
        }
        else
        {
            Thread.Sleep(ms * 10);
        }
    }

    bool ReadBuff(byte[] buff)
    {
        int total = buff.Length;
        int left = total;
        while (left > 0)
        {
            int readed = client.Client.Receive(buff, total - left, left, SocketFlags.None);
            left -= readed;

            if (readed < 1 && client.Connected == false)
            {
                return false;
            }
            if (left > 0)
            {
                this.Sleep(15);
            }
        }

        return true;

    }


    /// <summary>
    /// byte数组转int值
    /// </summary>
    private int ByteArray2Int(byte[] data)
    {
        int length = 0;
        //int temp = 0;
        //for (int i = 3; i >= 0; --i)
        //{
        //    temp = (int)(data[i]) - 28;
        //    length += (int)(temp * Mathf.Pow(100, 3 - i));
        //}

        length = (int)(((data[0] & 0xFF) << 24) | ((data[1] & 0xFF) << 16)
            | ((data[2] & 0xFF) << 8) | (data[3] & 0xFF));
        return length;
    }

    /// <summary>
    /// int值转byte数组
    /// </summary>
    private void Int2ByteArray(int number, byte[] allLen)
    {

        //int temp = number;
        //int maxIndex = 4;
        //for (int i = 1; i <= 4; i++)
        //{
        //    if (temp > 0)
        //    {
        //        allLen[--maxIndex] = (byte)(temp % 100 + 28);
        //        temp = temp / 100;
        //    }
        //    else
        //    {
        //        allLen[--maxIndex] = 28;
        //    }
        //}
        allLen[0] = (byte)(number >> 24 & 0xFF);
        allLen[1] = (byte)(number >> 16 & 0xFF);
        allLen[2] = (byte)(number >> 8 & 0xFF);
        allLen[3] = (byte)(number & 0xFF);
    }



}
