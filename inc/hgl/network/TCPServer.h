#ifndef HGL_TCP_SERVER_INCLUDE
#define HGL_TCP_SERVER_INCLUDE

#include<hgl/network/AcceptServer.h>
namespace hgl
{
	namespace network
	{
		/**
		* TCPServer是对应TCP连接处理的通用服务器端
		*/
		class TCPServer:public AcceptServer															///TCP服务器端实现基类
		{
			int	CreateServerSocket() HGL_OVERRIDE final;												///<创建一个服务器用Socket
		};//class TCPServer
	}//namespace network

	using namespace network;
}//namespace hgl
#endif//HGL_TCP_SERVER_INCLUDE