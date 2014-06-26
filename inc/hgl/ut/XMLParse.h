#ifndef HGL_XML_PARSE_INCLUDE
#define HGL_XML_PARSE_INCLUDE

#include<hgl/type/BaseString.h>
extern "C"
{
	/**
	* 该XML解晰器使用Expat实现,根据MIT协议取得免费授权,授权协议参见 doc/license/MIT.txt
	* Expat官方网站：http://expat.sourceforge.net/
	*/

	struct XML_ParserStruct;
	typedef struct XML_ParserStruct *XML_Parser;
}

namespace hgl
{
	/**
	* XML解析器(虚拟函数版)<br>
	*/
	class XMLParse
	{
	protected:

		XML_Parser xml;

		virtual void StartParse();

	public:

		virtual void StartElement(const char *,const char **)=0;
		virtual void CharData(const char *,int){};
		virtual void EndElement(const char *){};

	public:

		XMLParse();
		virtual ~XMLParse();

		virtual void Start();
		virtual bool Parse(const char *buf,int len,bool isFin);

		virtual bool ParseFile(const OSString &);
	};//class XMLParse

	/**
	* XML解析器(回调函数版)
	*/
	class XMLParseCB:public XMLParse
	{
	protected:

		virtual void StartParse();

	public:

		DefEvent(void,OnStartElement,(const char *,const char **));
		DefEvent(void,OnCharData,(const char *,int));
		DefEvent(void,OnEndElement,(const char *));

	public:

		XMLParseCB();
		virtual ~XMLParseCB()HGL_DEFAULT_MEMFUNC;
	};//class XMLParseCB

#define XML_START_PARSE(name)	while(*name)	\
								{	\
									const char *flag=*name;++name;	\
									const char *info=*name;++name;

#define XML_END_PARSE()				LOG_ERROR(UTF8String(__FILE__)+u8":"+UTF8String(__LINE__)+u8" can't parse atts \""+UTF8String(flag)+u8"\" , info \""+UTF8String(info)+u8"\".");	\
								}

#define xml_parse_skip(name)		if(hgl::strcmp(flag,#name)==0)continue;else
#define xml_parse_string(name)		if(hgl::strcmp(flag,#name)==0)name=to_u16(info);else
#define xml_parse_string_u8(name)	if(hgl::strcmp(flag,#name)==0)name=info;else
#define xml_parse_int(name)			if(hgl::strcmp(flag,#name)==0)hgl::stoi(info,name);else
#define xml_parse_uint(name)		if(hgl::strcmp(flag,#name)==0)hgl::stou(info,name);else
#define xml_parse_float(name)		if(hgl::strcmp(flag,#name)==0)hgl::stof(info,name);else
#define xml_parse_bool(name)		if(hgl::strcmp(flag,#name)==0)hgl::stob(info,name);else
}//namespace hgl
#endif//HGL_XML_PARSE_INCLUDE