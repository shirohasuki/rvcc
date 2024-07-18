# 指定C编译器，来构建项目
CC=gcc

# C编译器参数：使用C11标准，生成debug信息，禁止将未初始化的全局变量放入到common段
CFLAGS=-std=c11 -g -fno-common
LDFLAGS=

SRC_DIR:=$(abspath ./src)
# C源文件所在路径
CSRC_DIR:=$(SRC_DIR)/main
# 所有build文件所在路径
BUILD_DIR:=$(abspath ./build)
#.o文件所在路径	注释一定记得别写在BUILD_DIR:=$(abspath ./build)这些后面，防止路径里会有空格
OBJ_DIR:=$(BUILD_DIR)/obj_dir

CSRCS = $(shell find $(CSRC_DIR) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
# patsubst匹配替换所有.c为.o
OBJS:=$(patsubst $(CSRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(CSRCS))

INC_PATH=$(abspath ./include)
INCFLAGS=$(addprefix -I, $(INC_PATH))
CFLAGS+=$(INCFLAGS) -ggdb3 


# 综合各个.o生成rvcc可执行文件的规则
rvcc: $(OBJS)
	@echo + LD $@
	@$(CC) -o $@ $(CFLAGS) $(LDFLAGS) $(OBJS)

# 从各个.c生成各种.o的规则， $<:代表当前规则的第一个依赖文件，$@:代表当前规则的目标文件
$(OBJ_DIR)/%.o: $(CSRC_DIR)/%.c
	@echo + CC $<
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@ 

# 测试标签，运行测试脚本
test: rvcc
	$(SRC_DIR)/test/test.sh

# 清理标签，清理所有非源代码文件
clean:
	rm -rf $(BUILD_DIR) rvcc

# 伪目标，没有实际的依赖文件
.PHONY: rvcc test clean
