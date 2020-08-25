using UnityEngine;
using System.Collections;
using LuaFramework;

public class StartUpCommand : ControllerCommand {

    public override void Execute(IMessage message) {
        //-----------------关联命令-----------------------
        //AppFacade.Instance.RegisterCommand(NotiConst.DISPATCH_MESSAGE, typeof(SocketCommand));

        //-----------------初始化管理器-----------------------
        AppFacade.Instance.AddManager<LuaManager>();
        AppFacade.Instance.AddManager<NetworkManager>();

    }
}