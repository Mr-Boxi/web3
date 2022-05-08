package main

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/sha1"
	"crypto/x509"
	"encoding/pem"
	"os"
)

/// 椭圆曲线加密
// 生成密钥对
func GenerateEccKey() {
	// 1.使用ecdsa生成密钥对
	privateKey, err := ecdsa.GenerateKey(elliptic.P224(), rand.Reader)
	if err != nil {
		panic(err)
	}

	// 2.将私钥写入磁盘
	// -x509序列化
	derText, err := x509.MarshalECPrivateKey(privateKey)
	if err != nil {
		panic(err)
	}
	// -将字符串写入pem.Block结构体中
	block := pem.Block{
		Type:  "ecc private key",
		Bytes: derText,
	}

	// - 使用pem编码
	file, err := os.Create("eccPrivate.pem")
	if err != nil {
		panic(err)
	}
	pem.Encode(file, &block)
	file.Close()

	// 3.将公钥写入字符串
	// -从私钥中得到公钥
	publicKey := privateKey.PublicKey

	// -x509进行序列化
	pubText, err := x509.MarshalPKIXPublicKey(&publicKey) //注意传地址
	if err != nil {
		panic(err)
	}

	// -将字符串写入pem.Block结构体中
	pubblock := pem.Block{
		Type:  "ecc public key",
		Bytes: pubText,
	}

	// -pem编码
	pubfile, err := os.Create("eccPublic.pem")
	if err != nil {
		panic(err)
	}
	pem.Encode(pubfile, &pubblock)
	pubfile.Close()
}

// 使用私钥签名
func ECCSignature(data []byte) (rText, sText []byte) {
	// 1.打开私钥文件，将内容读出来
	file, err := os.Open("eccPrivate.pem")
	if err != nil {
		panic(err)
	}
	info, err := file.Stat()
	if err != nil {
		panic(err)
	}
	buf := make([]byte, info.Size())
	file.Read(buf)
	file.Close()

	// 2.pem解码
	block, _ := pem.Decode(buf)

	// 3.x509还原
	privateKey, err := x509.ParseECPrivateKey(block.Bytes)
	if err != nil {
		panic(err)
	}

	// 4.对数据进行哈希
	hashText := sha1.Sum(data)

	// 5.进行数字签名
	r, s, err := ecdsa.Sign(rand.Reader, privateKey, hashText[:])
	if err != nil {
		panic(err)
	}

	// 6 r,s 的值进行格式化 -> []byte
	rText, err = r.MarshalText()
	if err != nil {
		panic(err)
	}
	sText, err = s.MarshalText()
	if err != nil {
		panic(err)
	}
	return
}

// ECC 验证
func ECCVerify(plainText, rText, sText []byte, pubFile string) bool {

	return true
}

func main() {
	GenerateEccKey()
}
