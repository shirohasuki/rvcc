#include <stdio.h>
#include <stdlib.h>

#include <rvcc.h>



int main(int Argc, char **Argv) {
  // 判断传入程序的参数是否为2个，Argv[0]为程序名称，Argv[1]为传入的第一个参数
  if (Argc != 2) {
    // 异常处理，提示参数数量不对。
    error("%s: invalid number of arguments", Argv[0]);
    // 程序返回值不为0时，表示存在错误
  }

  // 解析Argv[1]
  Token *Tok = tokenize(Argv[1]);

  printf("  .globl main\n"); // 声明一个全局main段，同时也是程序入口段
  printf("main:\n"); // main段标签
  printf("  li a0, %d\n", getNumber(Tok));// li为addi别名指令，加载一个立即数到寄存器中.

  Tok = Tok->Next;

  // 解析 (op num)
  while (Tok->Kind != TK_EOF) {
    if (equal(Tok, "+")) {
      Tok = Tok->Next;
      printf("  addi a0, a0, %d\n", getNumber(Tok));
      Tok = Tok->Next;
      continue;
    }

    // 不是+，则判断-
    // 没有subi指令，但是addi支持有符号数，所以直接对num取反
    Tok = skip(Tok, "-");
    printf("  addi a0, a0, -%d\n", getNumber(Tok));
    Tok = Tok->Next;
  }

  printf("  ret\n"); // ret为jalr x0, x1, 0别名指令，用于返回子程序
  return 0;
}
