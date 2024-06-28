# C编译器参数：使用C11标准，生成debug信息，禁止将未初始化的全局变量放入到common段
CFLAGS=-std=c11 -g -fno-common
# 指定C编译器，来构建项目
CC=gcc

# C源文件所在路径
SRC_DIR:=$(abspath ./src/main)
# 所有build文件所在路径
BUILD_DIR:=$(abspath ./build)
#.o文件所在路径	注释一定记得别写在BUILD_DIR:=$(abspath ./build)这些后面，防止路径里会有空格
OBJ_DIR:=$(BUILD_DIR)/obj_dir



# rvcc标签，表示如何构建最终的二进制文件，依赖于main.o文件，没有mian.o文件时会自动推导由rvvc.c生成rvcc.o
rvcc: $(OBJ_DIR)/rvcc.o
	$(CC) -o rvcc $(CFLAGS) $(OBJ_DIR)/rvcc.o

# 从rvcc.c生成rvcc.o的规则， $<:代表当前规则的第一个依赖文件，$@$<:代表当前规则的目标文件
$(OBJ_DIR)/rvcc.o: $(SRC_DIR)/rvcc.c
	$(shell mkdir -p $(BUILD_DIR) $(OBJ_DIR))
	$(CC) -c $< $(CFLAGS) -o $@

# 测试标签，运行测试脚本
test: rvcc
	./scripts/test.sh

# 清理标签，清理所有非源代码文件
clean:
	rm -rf $(BUILD_DIR)
# rm -f rvcc *.o *.s tmp* a.out

# 伪目标，没有实际的依赖文件
.PHONY: test clean
