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
  int waypointX = 10, waypointY = -1;
  while (!cin.eof()) {
    getline(std::cin, line);
    
    char direction; int len; sscanf(line.c_str(), "%c%d", &direction, &len);
    // printf("%c %d\n", direction, len);

    if (direction == 'L' || direction == 'R') {
      while (len > 0) {
        int lastWayX = waypointX;
        int lastWayY = waypointY;

        len -= 90;
        waypointX = lastWayY * (direction == 'L' ? 1 : -1);
        waypointY = lastWayX * (direction == 'L' ? -1 : 1);
      }
    } else if (direction == 'F') {
      posX += len * waypointX;
      posY += len * waypointY;
    } else if (direction == 'E') {
      waypointX += len;
    } else if (direction == 'W') {
      waypointX -= len;
    } else if (direction == 'N') {
      waypointY -= len;
    } else if (direction == 'S') {
      waypointY += len;
    }

    printf("pos: %d %d waypoint: %d %d\n", posX, posY, waypointX, waypointY);
  }

  printf("manhattan dist %d\n", abs(posX) + abs(posY));
}
