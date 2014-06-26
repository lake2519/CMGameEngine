#ifndef HGL_NETWORK_DIRECT_SOCKET_IO_USER_THREAD_INCLUDE
#define HGL_NETWORK_DIRECT_SOCKET_IO_USER_THREAD_INCLUDE

#include<hgl/network/TCPSocket.h>

#ifdef HGL_NETWORK_SCTP_SUPPORT
#include<hgl/network/SCTPSocket.h>
#endif//HGL_NETWORK_SCTP_SUPPORT

#include<hgl/network/SocketInputStream.h>
#include<hgl/network/SocketOutputStream.h>
#include<hgl/io/DataInputStream.h>
#include<hgl/io/DataOutputStream.h>
#include<hgl/thread/Thread.h>

namespace hgl
{
	using namespace hgl::io;

	namespace network
	{
		template<typename DIS,typename DOS,typename S>
		class DirectSocketIOUserThread:public Thread
		{
			bool IsExitDelete()const{return true;}													///<返回在退出线程时，是否删除本对象

		protected:

			int sock;
			sockaddr_in addr;
			S *s;
			SocketInputStream *sis;
			SocketOutputStream *sos;
			DataInputStream *dis;
			DataOutputStream *dos;

		public:

			bool block;																				///<是否使用阻塞模式
			double block_send_time;																	///<阻塞时间
			double block_recv_time;

			double wait_time;																		///<数据等待时间

		public:

			DirectSocketIOUserThread(int s,const sockaddr_in &sa)
			{
				sock=s;
				addr=sa;

				block=true;
				block_recv_time=1;
				block_send_time=1;

				wait_time=10;
			}

			virtual bool ProcStartThread()
			{
				s=new S(sock,&addr);

				sis=new SocketInputStream(sock);
				sos=new SocketOutputStream(sock);
				dis=new DIS(sis);
				dos=new DOS(sos);

				s->SetBlock(block,block_send_time,block_recv_time);

				return(true);
			}

			virtual ~DirectSocketIOUserThread()
			{
				SAFE_CLEAR(dis);
				SAFE_CLEAR(dos);
				SAFE_CLEAR(sos);
				SAFE_CLEAR(sis);
				SAFE_CLEAR(s);
			}

			virtual bool Update()=0;

			virtual bool Execute()
			{
				int wr=s->WaitRecv(wait_time);

				if(wr<0)return(false);

				if(wr==0)return(true);

				return Update();
			}
		};//class DirectSocketIOUserThread

		typedef DirectSocketIOUserThread<LEDataInputStream,LEDataOutputStream,TCPSocket> LETCPSocketIOUserThread;
		typedef DirectSocketIOUserThread<BEDataInputStream,BEDataOutputStream,TCPSocket> BETCPSocketIOUserThread;
#ifdef HGL_NETWORK_SCTP_SUPPORT
		typedef DirectSocketIOUserThread<LEDataInputStream,LEDataOutputStream,SCTPSocket> LESCTPSocketIOUserThread;
		typedef DirectSocketIOUserThread<BEDataInputStream,BEDataOutputStream,SCTPSocket> BESCTPSocketIOUserThread;
#endif//HGL_NETWORK_SCTP_SUPPORT
	}//namespace network
}//namespace hgl
#endif//HGL_NETWORK_DIRECT_SOCKET_IO_USER_THREAD_INCLUDE