CXX := g++
UNAME := $(shell uname)
CXXFLAGS := -Wall -Wextra -std=c++11 -O2
ifeq ($(UNAME),Darwin)
	LUA := $(shell brew --prefix lua53)
	CXXFLAGS += -I$(LUA)/include/lua-5.3
	LDFLAGS := -L$(LUA)/lib/ -llua.5.3
else  #linux?
	# The LUA_VER variable selects the appropriate lua version (5.2, 5.3, whatever)
	# example:
	# $ lua -v
	# Lua 5.2.3 Copyright (C) 1994-2013 Lua.org, PUC-Rio
	# $ lua -v |grep -o -E '5.[0-9]'
	# 5.2
	LUA_VER := $(shell ls /usr/include/ | grep lua5)
	LUA_LOC := /usr/include/$(LUA_VER)
	CXXFLAGS += -I$(LUA_LOC)
	LDFLAGS := -l$(LUA_VER) -ldl
endif
BIN := editor

src_files := $(wildcard src/*.cpp)
obj_files := $(patsubst src/%.cpp,obj/%.o,$(src_files))

.PHONY: all clean remake

all: $(BIN)

clean:
	rm -f $(BIN) obj/*.o

remake: clean all


$(BIN): $(obj_files)
	$(CXX) -o $@ $^ $(LDFLAGS)

obj/%.o: src/%.cpp src/*.h
	$(CXX) $(CXXFLAGS) -c -o $@ $(filter src/%.cpp,$^)

