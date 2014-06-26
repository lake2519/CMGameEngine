﻿#include<hgl/graph/Camera.h>
namespace hgl
{
	namespace graph
	{
		/**
		* 后移
		* @param step 走的距离(以当前到视点的距离为1)
		*/
		void WalkerCamera::Backward(float step)
		{
			Vector3f off(center-eye);

			Vector3f right=cross(off,upvector);

			Vector3f dist=cross(right,upvector)*step;

			eye+=dist;
			center+=dist;
		}

		/**
		* 向上
		* @param step 走的距离(以当前到视点的距离为1)
		*/
		void WalkerCamera::Up(float step)
		{
			float len=length(eye,center)*step;

			Vector3f off=upvector*len;

			eye+=off;
			center=off;
		}

		/**
		* 右移
		* @param step 走的距离(以当前到视点的距离为1)
		*/
		void WalkerCamera::Right(float step)
		{
			Vector3f off(center-eye);

			Vector3f dist=cross(off,upvector)*step;

			eye+=dist;
			center+=dist;
		}

		void WalkerCamera::UpRotate(float ang)
		{
			Vector3f off(center-eye);								//算出以眼为中心的向量

			Vector3f axis=cross(off,upvector);						//使用叉积求出垂直向量做为旋转轴

			normalize(axis);

			Vector4f new_off=Vector4f(off,1.0f)*rotate(-ang,axis);

			center=eye+Vector3f(new_off[0],new_off[1],new_off[2]);
		}

		void WalkerCamera::RightRotate(float ang)
		{
			Vector4f off(center-eye,1.0f);							//算出偏移向量

			Vector4f new_off=off*rotate(ang,upvector);				//以上向轴为旋转轴

			center=eye+Vector3f(new_off[0],new_off[1],new_off[2]);
		}

		void WalkerCamera::CenterUpRotate(float ang)
		{
			Vector3f off(eye-center);								//算出偏移向量

			Vector3f axis=cross(off,upvector);						//使用叉积求出垂直向量做为旋转轴

			normalize(axis);										//CML必须做这一步，不解

			Vector4f new_off=Vector4f(off,1.0f)*rotate(-ang,axis);

			eye=center+Vector3f(new_off[0],new_off[1],new_off[2]);
		}

		void WalkerCamera::CenterRightRotate(float ang)
		{
			Vector4f off(eye-center,1.0f);							//算出偏移向量

			Vector4f new_off=off*rotate(ang,upvector);

			eye=center+Vector3f(new_off[0],new_off[1],new_off[2]);
		}

		void WalkerCamera::Distance(float pos)
		{
			eye=center+(eye-center)*pos;
		}
	}//namespace graph
}//namespace hgl