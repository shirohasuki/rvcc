#ifndef _TOKENIZE_H_
#define _TOKENIZE_H_

#include <stdbool.h>

// 为每个终结符都设置种类来表示
typedef enum {
  TK_PUNCT, // 操作符如： + -
  TK_NUM,   // 数字
  TK_EOF,   // 文件终止符，即文件的最后
} TokenKind;

// 终结符结构体
typedef struct Token Token;
struct Token {
  TokenKind Kind; // 种类
  Token *Next;    // 指向下一终结符
  int Val;        // 值
  char *Loc;      // 在解析的字符串内的位置
  int Len;        // 长度
};

// 输出错误信息
void error(char *Fmt, ...);
// 判断Tok的值是否等于指定值
bool equal(Token *Tok, char *Str);
// 跳过指定的Str
Token *skip(Token *Tok, char *Str);
// 返回TK_NUM的值
int getNumber(Token *Tok); 
// 生成新的Token
Token *newToken(TokenKind Kind, char *Start, char *End);
// 终结符解析
Token *tokenize(char *P);


#endif
