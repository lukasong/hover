Shader "Luka/Personal/Hover"
{
	Properties
	{
		//Info
		[Space(20)]
		[Header(Thank you for using my shader)]
		_Love ("<3", Float ) = 100.0

		//Textures
		[Space(20)]
		[Header(Texture Options)]
		_MainTex ("Main Texture", 2D) = "white" {}
		[MaterialToggle] _ToggleColorTint ("Allow Color Tint", Float ) = 0
		_ColorTint("Texture Color Tint", Color) = (1,1,1,1)

		//Hovering Options
		[Space(20)]
		[Header(Hovering Options)]
		[MaterialToggle] _ToggleYHover ("Disable Vertical Hover", Float ) = 1
		_HoverRange ("Hover Range", Range(0,1)) = 1
		_HoverSpeed ("Hover Speed", Range(0, 10)) = 1

		//Organization and infomoration :sunglasses:
		[Space(40)]
		[Header(Other Hovering Options)]
		_OtherHoverInfo ("They are kind of weird, but I thought I'd include them :)", Float) = 0


		//Horizonal Hover Options (Not Sure Why You Would Want This?)
		[Space(20)]
		[Header(Horizontal Hovering Options)]
		[MaterialToggle] _ToggleXHover ("Enable Horizontal Hover", Float ) = 0
		_XHoverRange ("Horizontal Hover Range", Range(0,1)) = 1
		_XHoverSpeed ("Horizontal Hover Speed", Range(0, 10)) = 1

		//Length Hover Options (Not Sure Why You Would Want This? x2 but i guess it can make some neat stuff)
		[Space(20)]
		[Header(Length Hovering Options)]
		[MaterialToggle] _ToggleZHover ("Enable Length Hover", Float ) = 0
		_ZHoverInfo ("This is broken. It will cause the object to blink. :'(", Float) = 0
		_ZHoverRange ("Length Hover Range", Range(0,1)) = 1
		_ZHoverSpeed ("Length Hover Speed", Range(0, 10)) = 1

		//Organization and infomoration :sunglasses:
		[Space(40)]
		[Header(Other EXPERIMENTAL Options)]
		_OtherHoverInfo ("Just some neat things I found while playing around with this cx", Float) = 0

		//Fake Size Options
		[Space(20)]
		[Header(Length Hovering Options)]
		[MaterialToggle] _ToggleWValue ("Enable Fake Size", Float ) = 0
		[MaterialToggle] _ToggleWAnimate ("Disable Autoanimate Fake Size", Float ) = 0
		_WGrowRange ("Growth Range", Range(0,1)) = 1
		_WGrowSpeed ("Growth Speed", Range(0, 10)) = 1
		_WGrowSize ("Grow Size (For Manual Animation)", Range(0, 10)) = 0

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _HoverRange;
			float _HoverSpeed;
			float _XHoverRange;
			float _XHoverSpeed;
			float _ZHoverRange;
			float _ZHoverSpeed;
			float _WGrowRange;
			float _WGrowSpeed;
			float _WGrowSize;
			fixed _ToggleYHover;
			fixed _ToggleXHover;
			fixed _ToggleZHover;
			fixed _ToggleWValue;
			fixed _ToggleWAnimate;

			float4 _ColorTint;
			fixed _ToggleColorTint;
			
			v2f vert (appdata v)
			{
				//looking through the shader to try an grab the hover code to add to another shader?
					//this is basically it in this vert
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				//grabbing the object's world pos again
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				//applying the hover 
				if(_ToggleYHover == 1){
					o.vertex.y += sin(_Time.w * _HoverSpeed) * (_HoverRange*10);
				}

				//applying all of the other weird "hovers"
				if(_ToggleXHover){
					o.vertex.x += sin(_Time.w * _XHoverSpeed) * (_XHoverRange*10);
				}

				if(_ToggleZHover){
					o.vertex.z += sin(_Time.w * _ZHoverSpeed) * (_ZHoverRange*10);
				}

				//changing the vertexs' w which i guess is like scale
				if(_ToggleWValue == 1 && _ToggleWAnimate == 0){
					o.vertex.w += sin(_Time.w * _WGrowSpeed) * (_WGrowRange*10);
				}else if(_ToggleWValue == 1&& _ToggleWAnimate == 1){
					o.vertex.w += (-(_WGrowSize));
				}

				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				//custom color check, about all thats needed to be done in the frag part
				fixed4 col;
				if(_ToggleColorTint == 0){
					col = tex2D(_MainTex, i.uv);
				}else{
					col = tex2D(_MainTex, i.uv) + _ColorTint;
				}

				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
