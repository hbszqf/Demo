using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

//如果第一次请求失败，会使用阿里云httpDNS再次请求
namespace Assets._Scripts.Network
{
    enum RequireState
    {
        //第一默认使用http请求
        Http,
        //开始使用httpdns请求
        HttpDns,
        //等待一秒后再重试httpdns
        Waiting,
        //不再去请求
        End
    }

    public enum HttpDnsState
    {
        Sucess,
        Fail,
        Cancel
    }

    class MyWWW : CustomYieldInstruction
    {
        public WWW www;
        string url;

        RequireState state = RequireState.Http;
        double time = 0;
        int times = 0;

        public MyWWW(string url)
        {
            this.url = url;
            www = new WWW(url);
        }

        public void Dispose()
        {
            state = RequireState.Http;
            time = 0;
            times = 0;
            www.Dispose();
        }

        public override bool keepWaiting
        {
            get
            {
                // 先用HTTP请求
                if (state == RequireState.Http)
                {
                    if (!www.isDone)
                    {
                        return true;
                    }

                    if (www.error != null)
                    {
                        state = RequireState.HttpDns;
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                // 使用httpdns去请求
                else if (state == RequireState.HttpDns)
                {
                    times++;
                    //重复五次后还没有获取到就不获取了
                    if (times > 5 )
                    {
                        state = RequireState.End;
                    }
                    else
                    {
                        HttpDnsState httpDnsState;
                        string urlIp = GetTargetUrlByHttpDnsAsync(url, out httpDnsState);
                        if (httpDnsState == HttpDnsState.Sucess || httpDnsState == HttpDnsState.Cancel)
                        {
                            www = new WWW(urlIp);
                            state = RequireState.End;
                        }
                        else
                        {
                            time = GetTimestamp();
                            state = RequireState.Waiting;
                        }
                    }
                    return true;
                }
                // 间隔一秒后再重试httpdns
                else if (state == RequireState.Waiting)
                {
                    if (GetTimestamp() - time > 1000)
                    {
                        state = RequireState.HttpDns;
                    }
                    return true;
                }
                // 无论请求是否成功都返回结果退出协程
                else if (state == RequireState.End)
                {
                    if (www.isDone)
                        return false;
                    else
                        return true;
                }
                else
                {
                    return false;
                }
            }
        }

        //获取当前时间戳
        double GetTimestamp()
        {
            TimeSpan ts = System.DateTime.Now - new DateTime(1970, 1, 1);
            return ts.TotalMilliseconds;
        }

        public static string GetTargetUrlByHttpDnsAsync(string url, out HttpDnsState httpDnsState)
        {

            try
            {
                string urlIp = "";
                bool pos = url.StartsWith("http");
                if (!pos)
                {
                    url = "http://" + url; //缺少HTTP前缀无法请求
                }

                string[] s1Array = url.Split('/');
                string[] s2Array = s1Array[2].Split(':');
                //前缀 + 2个斜杠 + 域名
                string sUrl = url.Substring(0, s1Array[0].Length + 2 + s2Array[0].Length);
                string targetUrl ="";
                object[] obj = { sUrl };




#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN
            targetUrl = null;
#elif UNITY_ANDROID
            targetUrl = new AndroidJavaClass("com.youai.biwu2.JavaComponentStaticWrap.JavaCompStaticWrap").CallStatic<string>("ComponentHttpDns_getTargetUrlAsync", obj);
#elif  UNITY_IPHONE
            targetUrl = null;
#endif

                string newUrl = "";
                httpDnsState = HttpDnsState.Cancel;
                if (string.IsNullOrEmpty(targetUrl))
                {
                    httpDnsState = HttpDnsState.Cancel;
                    newUrl = url;
                }
                else
                {
                    if (sUrl.Equals(targetUrl))
                    {
                        httpDnsState = HttpDnsState.Fail;
                    }
                    else
                    {
                        httpDnsState = HttpDnsState.Sucess;
                    }
                    newUrl = url.Replace(sUrl, targetUrl);
                }
                return newUrl;
            }
            catch (Exception)
            {
                httpDnsState = HttpDnsState.Cancel;
                return url;
            }
           
        }
    }
}
