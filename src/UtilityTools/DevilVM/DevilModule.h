#ifndef HGL_DEVIL_SCRIPT_MODULE_INCLUDE
#define HGL_DEVIL_SCRIPT_MODULE_INCLUDE

#include<hgl/script/DevilVM.h>
#include<hgl/type/IndexData.h>
#include<hgl/type/StringList.h>
#include"DevilCommand.h"
#include"DevilFunc.h"
#include"DevilEnum.h"
namespace hgl
{
	class DevilScriptModule:public DevilModule
	{
		IndexObject<UTF16String,DevilPropertyMap>  	prop_map;		//属性映射表
		IndexObject<UTF16String,DevilFuncMap> 		func_map;		//函数映射表
		IndexObject<UTF16String,DevilFunc>			script_func;	//脚本函数表
		IndexObject<UTF16String,DevilEnum>			enum_map;		//枚举映射表

	private:

		bool _MapFunc(const char16_t *,void *,void *);

	public:	//内部属性

		UTF16StringList string_list;									//字符串列表

	public:	//内部方法

		DevilFunc *GetScriptFunc(const UTF16String &);
		DevilFuncMap *GetFuncMap(const UTF16String &);
		DevilPropertyMap *GetPropertyMap(const UTF16String &);

	public:

		bool MapProperty(const char16_t *,void *);
		bool MapFunc(const char16_t *,void *);
//		bool MapFunc(void *,const char16_t *,void *);
		bool MapFunc(const char16_t *,void *,void *);

		bool AddEnum(const char16_t *,DevilEnum *);

		bool AddScript(const char16_t *,int=-1);

		void Clear();

	public:	//Debug接口

	#ifdef _DEBUG
		void LogPropertyList();
		void LogMapFuncList();
		void LogScriptFuncList();
	#endif//_DEBUG
	};//HGL_DEVIL_SCRIPT_MODULE_INCLUDE
}//namespace hgl
#endif//HGL_DEVIL_SCRIPT_MODULE_INCLUDE