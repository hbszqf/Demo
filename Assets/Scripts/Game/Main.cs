using System.Collections;
using System.Collections.Generic;
using System.Net;
using UnityEngine;
using UnityEngine.Networking;

public class Main : MonoBehaviour
{
    // Start is called before the first frame update

    //Inti SomeThing
    IEnumerator Start()
    {
        Debug.Log("开始异步操作1");
        UnityWebRequest www = new UnityWebRequest("https://www.baidu.com/");
        yield return www;
        Debug.Log("完成异步操作1");





     

    }

}
