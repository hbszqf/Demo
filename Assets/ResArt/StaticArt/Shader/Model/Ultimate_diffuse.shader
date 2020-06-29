Shader "Customer/Model/Ultimate_diffuse" {
	Properties 
	{
	    _MainTex ("Base (RGB)", 2D) = "white" {}
	    
	    _RampTex ("明暗过渡图", 2D) = "gray" {}
        _SColor ("暗面颜色", Color) = (0.0,0.0,0.0,1)
		_LColor ("亮面颜色", Color) = (0.5,0.5,0.5,1)

		_RimColor("边缘光颜色", Color) = (0.26,0.19,0.16,0.0)
        _RimPower("边缘光锐度", Range(0.5, 20.0)) = 3.0
        _RimIntensity ("边缘光强度", Range(0, 5.0)) = 1.0
        _ViewDirAdjust ("边缘光方向调整(x,y)", Vector) = (0, 0, 0, 0)
		_InverseLight ("反冲方向", Vector) = (0, 0, 0, 0)

		_Burn ("Burn", Range(1,7)) = 1.0
		_DiffIntensity ("基本明暗强度", Range(0, 5.0)) = 1.0

		[HideInInspector]_BlinkColor("闪白颜色", Color) = (0, 0, 0, 0)
	}

	SubShader 
	{
	    Tags { "RenderType"="Opaque" }
	    LOD 150
		
		Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}

		CGPROGRAM
		#pragma surface surf NPR noforwardadd noshadow nolightmap

		sampler2D _MainTex;

		sampler2D _RampTex;
		half4 _LColor;
		half4 _SColor;

		fixed4 _RimColor;
        float _RimPower;
        half4 _ViewDirAdjust;
        half4 _InverseLight;

        half _RimIntensity;
        
		half _Burn;
		half _DiffIntensity;

		fixed4 _BlinkColor;

		struct Input 
		{
		    float2 uv_MainTex;
		};

		inline fixed4 LightingNPR (SurfaceOutput s, half3 viewDir, UnityGI gi)
		{
			// diffuse
			half diff = max(0, dot(s.Normal, gi.light.dir));

			half3 ramp = tex2D(_RampTex, half2(diff, diff)).rgb;
			ramp = lerp(_SColor, _LColor, ramp);
			half3 diffFactor = ramp * _DiffIntensity;

 			// rim
			half3 vd = viewDir;
            vd.xy += _ViewDirAdjust.xy;
            
            fixed inverseVal = 1.0 - saturate((dot(normalize(_InverseLight.xyz), s.Normal)));
            
          	float rim_term = 1.0 - saturate(abs(dot(normalize(vd), s.Normal)));
            rim_term = pow(rim_term, _RimPower);
            half3 rimFactor = _RimColor.rgb * rim_term * _RimIntensity * inverseVal;

            fixed4 c = (fixed4)0;
            c.rgb = (diffFactor + rimFactor) * gi.light.color * s.Albedo;

            #ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
		        c.rgb += s.Albedo * gi.indirect.diffuse;
		    #endif
            return c;
		}

		inline void LightingNPR_GI (
			    SurfaceOutput s,
			    UnityGIInput data,
			    inout UnityGI gi)
		{
		    gi = UnityGlobalIllumination (data, 1.0, s.Normal);
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
		    fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
		    o.Albedo = (1 - _BlinkColor.a) * tex.rgb * _Burn + _BlinkColor;
		    o.Alpha = tex.a;
		}
		ENDCG
	}

	FallBack "Biwu2/Public/MobileDiffuse"
}
