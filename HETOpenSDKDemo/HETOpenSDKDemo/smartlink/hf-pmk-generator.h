#ifndef HF_PMK_GENERATE
#define HF_PMK_GENERATE

typedef unsigned long size_t;
typedef unsigned char u8;
typedef unsigned int u32;

int pbkdf2_sha1(const char *passphrase, const char *ssid, size_t ssid_len, int iterations, u8 *buf, size_t buflen);
//void forTest();

#endif