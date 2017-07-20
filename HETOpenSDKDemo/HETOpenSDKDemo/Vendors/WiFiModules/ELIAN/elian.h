#ifndef _ELIAN_H_
#define _ELIAN_H_

#if defined(WIN32) || defined(WINAPI_FAMILY)

#ifdef ELIAN_EXPORTS
#define ELIAN_API __declspec(dllexport)
#else
#define ELIAN_API __declspec(dllimport)
#endif

#else

#define ELIAN_API

#endif  //WIN32

enum etype_id {
	TYPE_ID_BEGIN = 0x0,
	TYPE_ID_AM,
	TYPE_ID_SSID,
	TYPE_ID_PWD,
	TYPE_ID_USER,
	TYPE_ID_PMK,
	TYPE_ID_CUST = 0x7F,
	TYPE_ID_MAX = 0xFF
};

//flag
#define ELIAN_SEND_V1	0x01
#define ELIAN_SEND_V4	0x02

#ifdef __cplusplus
extern "C" {
#endif

//return context on success, NULL on fail
ELIAN_API void elianGetVersion(int *protoVersion, int *libVersion);
ELIAN_API void *elianNew(const char *key, int keylen, const unsigned char *target, unsigned int flag);
ELIAN_API int elianSetInterval(void *context, int usec);   //set send interval, in microsec
ELIAN_API int elianPut(void *context, enum etype_id id, char *buf, int len);
ELIAN_API int elianStart(void *context);
ELIAN_API void elianStop(void *context);
ELIAN_API void elianDestroy(void *context);

#ifdef __cplusplus
};
#endif

#endif

