﻿#ifndef HGL_GRAPH_SCENE_GLOBAL_STATE_INCLUDE
#define HGL_GRAPH_SCENE_GLOBAL_STATE_INCLUDE

#include<hgl/graph/SkyLight.h>
namespace hgl
{
	namespace graph
	{
		/**
		* 光源类型
		*/
		enum LightType
		{
			ltNone=0,			///<起始定义，无意义

			ltPoint,			///<点光源
			ltDirection,		///<方向光

			ltEnd				///<结束定义，无意义
		};//enum LightType

		/**
		* 灯光
		*/
		struct Light
		{
			LightType	type;			///<光源类型

			bool		enabled;		///<是否开启
		};//struct Light

		/**
		* 点光源
		*/
		struct PointLight:public Light
		{
			Vector3f	position;				///<光源位置

			Vector4f	ambient;
			Vector4f	specular;
			Vector4f	diffuse;

			Vector3f	attenuation;			//constant,linear,quadratic
		};//struct PointLight

		/**
		* 场景全局状态
		*/
		class GlobalSceneState
		{
			//SkyLight sky_light;													///<天空光照

			bool lighting;														///<是否开启光照

			int light_number;													///<光源数量

			Light **light_list;													///<光源列表

		public:

			GlobalSceneState();
			virtual ~GlobalSceneState();

			//SkyLight *		GetSkyLight	()		{return sky_light;}				///<取得天空灯光

			virtual void	SetLighting	(bool l){lighting=l;}					///<设置全局光照
			virtual void	SetMaxLight	(int);									///<设置最大灯光数

			virtual Light *	GetLight	(int);									///<取得指定灯光
			virtual void	OpenLight	(int);									///<开启指定灯光
			virtual void	CloseLight	(int);									///<关闭指定灯光
		};//class GlobalState
	}//namespace graph
}//namespace hgl
#endif//HGL_GRAPH_SCENE_GLOBAL_STATE_INCLUDE