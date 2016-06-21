﻿#include <hgl/LogInfo.h>
#include <hgl/network/UdpSocket.h>
#include <string.h>

#if HGL_OS != HGL_OS_Windows
#include<netinet/udplite.h>
#endif//HGL_OS != HGL_OS_Windows

// #ifndef IPPROTO_UDPLITE
// #define IPPROTO_UDPLITE     136
// #endif

// #ifndef UDPLITE_SEND_CSCOV
// #define UDPLITE_SEND_CSCOV  10
// #endif
//
// #ifndef UDPLITE_RECV_CSCOV
// #define UDPLITE_RECV_CSCOV  11
// #endif
//--------------------------------------------------------------------------------------------------
namespace hgl
{
	namespace network
	{
		/**
		* 创建一个UDPLite连接，使用指定的IP地址和端口
		* @param addr 地址
		* @return true 创建服务器成功
		* @return false 创建服务器失败
		*/
		bool UDPLiteSocket::Create(const IPAddress *addr)
		{
            if(!addr)RETURN_FALSE;

            if(addr->GetSocketType()!=SOCK_DGRAM)RETURN_FALSE;
            if(addr->GetProtocol()!=IPPROTO_UDPLITE)RETURN_FALSE;

			if(!CreateSocket(addr->GetFamily(),SOCK_DGRAM,IPPROTO_UDPLITE))
				RETURN_FALSE;

			socket_protocols=IPPROTO_UDPLITE;

            if(!addr->Bind(ThisSocket))
			{
				hgl::CloseSocket(ThisSocket);
				return(false);
			}

			SetBlock(false);
			return(true);
		}

		/**
		* 创建一个UDPLite连接
		*/
		bool UDPLiteSocket::Create(int family)
		{
            if(family!=AF_INET&&family!=AF_INET6)RETURN_FALSE;

			if((ThisSocket=socket(family,SOCK_DGRAM,IPPROTO_UDPLITE))<0)
			{
				LOG_ERROR(U16_TEXT("创建UDPLiteSocket失败！errno:")+UTF16String(GetLastSocketError()));
				return(false);
			}

			socket_protocols=IPPROTO_UDPLITE;

			SetBlock(false);
			return(true);
		}

        void UDPLiteSocket::SetChecksumCoverage(int send_val,int recv_val)
        {
            if(ThisSocket==-1)return;

            setsockopt(ThisSocket, SOL_UDPLITE, UDPLITE_SEND_CSCOV, &send_val, sizeof(int));
            setsockopt(ThisSocket, SOL_UDPLITE, UDPLITE_RECV_CSCOV, &recv_val, sizeof(int));
        }
	}//namespace network
}//namespace hgl
