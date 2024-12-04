Shader "ERB/Particles/Rasengan"
{
	Properties
	{
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_MainTex("Main Tex", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		[HDR]_Color("Color", Color) = (1,1,1,1)
		_Rotationspeed("Rotation speed", Float) = -0.25
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}


	Category 
	{
		SubShader
		{
			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
					
				};
				
				
				#if UNITY_VERSION >= 560
				UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
				#else
				uniform sampler2D_float _CameraDepthTexture;
				#endif

				//Don't delete this comment
				// uniform sampler2D_float _CameraDepthTexture;

				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform float _InvFade;
				uniform float _Rotationspeed;
				uniform sampler2D _Noise;
				uniform float4 _Noise_ST;
				uniform float4 _Color;

				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float2 uv0_MainTex = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					float mulTime158 = _Time.y * _Rotationspeed;
					float cos146 = cos( mulTime158 );
					float sin146 = sin( mulTime158 );
					float2 rotator146 = mul( uv0_MainTex - float2( 0.5,0.5 ) , float2x2( cos146 , -sin146 , sin146 , cos146 )) + float2( 0.5,0.5 );
					float2 uv_Noise = i.texcoord.xy * _Noise_ST.xy + _Noise_ST.zw;
					float4 uv0_Noise = i.texcoord;
					uv0_Noise.xy = i.texcoord.xy * _Noise_ST.xy + _Noise_ST.zw;
					float4 tex2DNode105 = tex2D( _MainTex, ( rotator146 + ( tex2D( _Noise, uv_Noise ).r * uv0_Noise.z ) ) );
					float4 appendResult148 = (float4(( tex2DNode105 * i.color * _Color ).rgb , ( tex2DNode105.a * i.color.a * _Color.a )));
					

					fixed4 col = appendResult148;
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	
	
	
}
/*ASEBEGIN
Version=17000
7;85;1906;948;1668.947;190.1203;1.854802;True;False
Node;AmplifyShaderEditor.RangedFloatNode;157;-854.8086,500.4481;Float;False;Property;_Rotationspeed;Rotation speed;3;0;Create;True;0;0;False;0;-0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-580.3825,334.563;Float;False;0;105;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-734.4557,860.2206;Float;False;0;14;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-548.3333,657.4077;Float;True;Property;_Noise;Noise;1;0;Create;True;0;0;False;0;9d5bd3e81391d5a4f9def3a9fcabc0ce;9d5bd3e81391d5a4f9def3a9fcabc0ce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;158;-508.446,496.4735;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-89.61018,814.7477;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;146;-238.1433,428.6666;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;25;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;85.02625,505.8586;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;152;375.5088,941.7037;Float;False;Property;_Color;Color;2;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;105;318.4346,571.2703;Float;True;Property;_MainTex;Main Tex;0;0;Create;True;0;0;False;0;b7e2df001a2a3e24fbf3df00e846deba;b7e2df001a2a3e24fbf3df00e846deba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;149;408.2717,767.4752;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;686.4969,783.8215;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;672.4969,587.8215;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-83.44931,1020.525;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2.1,2.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;164;196.5942,1000.28;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;163;72.9756,1023.066;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;148;854.2529,592.6112;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;161;-225.8557,988.5092;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;162;-450.6568,984.646;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;145;1014.865,591.0731;Float;False;True;2;Float;;0;11;ERB/Particles/Rasengan;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;True;True;True;True;False;0;False;-1;False;True;2;False;-1;True;3;False;-1;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;0;False;False;False;False;False;False;False;False;False;False;True;0;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;158;0;157;0
WireConnection;153;0;14;1
WireConnection;153;1;29;3
WireConnection;146;0;106;0
WireConnection;146;2;158;0
WireConnection;156;0;146;0
WireConnection;156;1;153;0
WireConnection;105;1;156;0
WireConnection;151;0;105;4
WireConnection;151;1;149;4
WireConnection;151;2;152;4
WireConnection;150;0;105;0
WireConnection;150;1;149;0
WireConnection;150;2;152;0
WireConnection;167;0;161;0
WireConnection;164;0;163;0
WireConnection;163;0;167;0
WireConnection;148;0;150;0
WireConnection;148;3;151;0
WireConnection;161;0;162;0
WireConnection;162;0;29;0
WireConnection;145;0;148;0
ASEEND*/
//CHKSM=75E5B660848F12FF4875A48B91567767224322E6