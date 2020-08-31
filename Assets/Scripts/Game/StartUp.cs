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
        GRoot.inst.SetContentScaleFactor(1280, 720);
        uiPackage = UIPackage.AddPackage(AppConst.FairyGUIEditorOutPut+ "启动界面");
        com = uiPackage.CreateObject("组件_更新界面") as GComponent;
        GRoot.inst.AddChild(com);
        com.sortingOrder = 10000;
        ToFull3(com);
        com.Center();
        
        StartCoroutine(ExTract());

    }


    //模拟解压过程
    IEnumerator ExTract()

    {
        GTextField tips = this.com.GetChild("tips") as GTextField;
        tips.text = "模拟解压过程";
        GProgressBar progress = this.com.GetChild("progress") as GProgressBar;
        progress.max = 100;
        progress.value = 0;
        for (int i = 0; i < 4; i++)
        {
            Debug.Log(" i ===" + i);
            yield return new WaitForSeconds(0.3f);
            int temp = (i+1) * 100 / 4;
            Debug.Log("temp===" + temp);
            progress.value = temp;


        }
        yield return StartCoroutine(HotFix());

        //yield return null;
    }
    //模拟增量过程
    IEnumerator HotFix()
    {
        GTextField tips = this.com.GetChild("tips") as GTextField;
        tips.text = "模拟增量过程";

        GProgressBar progress = this.com.GetChild("progress") as GProgressBar;
        progress.max = 100;
        for (int i = 0; i < 10; i++)
        {
            yield return new WaitForSeconds(0.25f);
            progress.value = (i + 1) * 100 / 10;

        }
        yield return StartCoroutine(ShowLoginUI());
    }

    IEnumerator ShowLoginUI()
    {
        AppFacade.Instance.StartUp(gameObject);
        yield return null;
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
