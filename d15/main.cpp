#include <cstdio>
#include <iostream>
#include <map>
#include <sstream>
using namespace std;

struct langUse { int last; int lastLast; };
map<int,langUse> langs;

int main() {
  char line[100]; scanf("%s", line);
  stringstream langStream(line);
  
  string rawLang; langUse lastUse; int lastCode; 
  for (int i = 1; i <= 30000000; i++) {
    if (getline(langStream, rawLang, ',')) {
      lastCode = stoi(rawLang);
      // printf("raw: %s p: %d\n", rawLang.c_str(), lastCode);
      langUse nextUse = { .last=i, .lastLast=i };
      langs.insert(pair<int,langUse>(lastCode, nextUse));
      lastUse = nextUse;
      // printf("i:%d code:%d last:%d lastlast:%d\n", i, lastCode, lastUse.last, lastUse.lastLast);
      continue;
    }

    int nextCode = lastUse.last - lastUse.lastLast;
    map<int,langUse>::iterator iter; if ( (iter = langs.find(nextCode)) != langs.end()) {
      langUse nextUse = { .last=i, .lastLast = iter->second.last };
      // printf("found code:%d last:%d lastlast:%d\n", nextCode, iter->second.last, iter->second.lastLast);
      langs.erase(nextCode); langs.insert(pair<int,langUse>(nextCode, nextUse));
      lastCode = nextCode; lastUse = nextUse;
    } else {
      langUse nextUse = { .last=i, .lastLast=i };
      langs.insert(pair<int,langUse>(nextCode, nextUse));
      lastCode = nextCode; lastUse = nextUse;
    }

    if (i == 2020) {
      printf("i:%d code:%d last:%d lastlast:%d\n", i, lastCode, lastUse.last, lastUse.lastLast);
    }
    if (i % 1000000 == 0) {
      printf("i:%d code:%d last:%d lastlast:%d\n", i, lastCode, lastUse.last, lastUse.lastLast);
    }
  }
}
