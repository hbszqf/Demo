using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using LuaFramework;

public class View : Manager, IView {
    public virtual void OnMessage(IMessage message) {
    }
}
