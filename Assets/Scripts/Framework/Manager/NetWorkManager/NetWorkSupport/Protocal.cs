
namespace LuaFramework {
    public class Protocal {
        ///BUILD TABLE
        public const int Connect = 101;         //连接服务器
        public const int ConnectFailed = 105;   //连接服务器失败
        public const int Exception = 102;       //异常掉线
        public const int Disconnect = 103;      //正常断线  
        public const int ReceivedMessage = 104; //正常接收网络消息
    }
}