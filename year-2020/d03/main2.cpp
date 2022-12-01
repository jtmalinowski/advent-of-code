#include <cstdio>
using namespace std;

int Y, X; 
char rows[1000][100];

int check(int diffX, int diffY) {
  int posX = 0, posY = 0;
  int count = 0;
  for (int y = 0; y < Y; y++) {
    for (int x = 0; x < X; x++) {
      if (x == posX && y == posY) {
        if (rows[y][x] == '#') {
          count++;
        }

        posX = (posX + diffX) % X;
        posY = posY + diffY;
      }
    }
  }
  return count;
}

int main() {
  scanf("%d %d\n", &Y, &X);
  int posX = 0;
  int count = 0;
  for (int y = 0; y < Y; y++) {
    scanf("%s", rows[y]);
  }

  printf("%d\n", check(1, 1) * check(3, 1) * check(5, 1) * check(7, 1) * check(1, 2));
}
