﻿#include<hgl/graph/Texture.h>

namespace hgl
{
	namespace graph
	{
		Texture::Texture()
		{
			index=type=video_format=0;

			bitmap_data=0;

			min_filter=mag_filter=HGL_FILTER_LINEAR;
		}
	}//namespace graph
}//namespace hgl
