#include <iostream>
#include <iterator>
#include <cstdlib>
#include <string>
using namespace std;

char directions[] = { 'N', 'E', 'S', 'W' };

int main() {
  string line;

  char shipDirectionIdx = 1; // 'E'
  int posX = 0, posY = 0;
  while (!cin.eof()) {
    getline(std::cin, line);
    
    char direction; int len; sscanf(line.c_str(), "%c%d", &direction, &len);
    // printf("%c %d\n", direction, len);

    if (direction == 'L' || direction == 'R') {
      int step = direction == 'L' ? -1 : 1;
      shipDirectionIdx += (len / 90) * step;
      shipDirectionIdx = shipDirectionIdx % 4; // no of directions
      shipDirectionIdx = shipDirectionIdx < 0 ? shipDirectionIdx + 4 : shipDirectionIdx;
      // printf("new direction %c\n", directions[shipDirectionIdx]);
      continue;
    }

    if (direction == 'F') {
      direction = directions[shipDirectionIdx];
    }

    if (direction == 'E') {
      posX += len;
    } else if (direction == 'W') {
      posX -= len;
    } else if (direction == 'N') {
      posY -= len;
    } else if (direction == 'S') {
      posY += len;
    }
  }

  printf("manhattan dist %d\n", abs(posX) + abs(posY));
}
