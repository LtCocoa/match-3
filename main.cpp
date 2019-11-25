#include <iostream>
extern "C" {
    #include "lua.h"
    #include "lauxlib.h"
    #include "lualib.h"
}
#include "LuaBridge/LuaBridge.h"
#include "vector"
#include <unistd.h>

using namespace luabridge;

lua_State* L;

void init() {
    L = luaL_newstate();
    luaL_dofile(L, "board.lua");
    luaL_openlibs(L);
    lua_pcall(L, 0, 0, 0);

    LuaRef initBoard = getGlobal(L, "initBoard");
    initBoard();
}

void dump() {
    system("clear");
    LuaRef board = getGlobal(L, "board");
    std::string letter = "";
    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            switch (board[i+1][j+1].cast<int>())
            {
            case 1:
                letter = "A";
                break;
            case 2:
                letter = "B";
                break;
            case 3:
                letter = "C";
                break;
            case 4:
                letter = "D";
                break;
            case 5:
                letter = "E";
                break;
            case 6:
                letter = "F";
                break;
            default:
                break;
            }
            std::cout<<letter<<" ";
        }
        std::cout<<std::endl;
    }
    std::cout<<std::endl;
}

void move(int x, int y, int direction) {
    LuaRef moveL = getGlobal(L, "move");
    moveL(x,y,direction);
}

void mainLoop() {
    std::string playerInput = "";

    while (true) {
        LuaRef checkMatches = getGlobal(L, "checkMatches");

        while (checkMatches().cast<int>() > 0) {
            dump();
            sleep(1);
        }

        dump();
        std::cout<<"Enter command"<<std::endl;
        std::cin>>playerInput;

        if (playerInput[0] == 'q') {
            return;
        }

        if (playerInput.size() != 4) {
            std::cout<<"Wrong command format!"<<std::endl;
            sleep(2);
            continue;
        }

        if (playerInput[0] != 'm') {
            std::cout<<"Wrong command!"<<std::endl;
            sleep(2);
            continue;
        }

        int x = playerInput[1] - '0';
        int y = playerInput[2] - '0';
        int direction = -1;

        switch (playerInput[3]) {
        case 'u':
            direction = 1;
            break;
        case 'd':
            direction = 2;
            break;
        case 'l':
            direction = 3;
            break;
        case 'r':
            direction = 4;
            break;        
        default:
            direction = -1;
            break;
        }

        move(x, y, direction);
    }
}

int main() {
    init();
    mainLoop();
}