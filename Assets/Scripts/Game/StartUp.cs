using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FairyGUI;

public class StartUp : MonoBehaviour
{
    UIPackage uiPackage = null;
    GComponent com;



    // Start is called before the first frame update
    void Start()
    {
        InitView();
    }

    void InitView()
    {
        GRoot.inst.SetContentScaleFactor(1146, 640);
        uiPackage = UIPackage.AddPackage(AppConst.FairyGUIEditorOutPut+ "启动界面");
        com = uiPackage.CreateObject("组件_更新界面") as GComponent;
        GRoot.inst.AddChild(com);
        com.sortingOrder = 10000;
        ToFull3(com);

        com.Center();
    }

    void OnDestroy()
    {
        com.Dispose();
        com = null;
        if (UIPackage.GetById(uiPackage.id) != null)
        {
            UIPackage.RemovePackage(uiPackage.id);
        }
        uiPackage = null;
    }

    // 对应gobjectProxy的ToFull3
    void ToFull3(GComponent com)
    {
        var size = GRoot.inst.size;
        com.size = GRoot.inst.size;
    }

    
}
