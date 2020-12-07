#include <cstdio>
using namespace std;

char row[1000];

int main() {
  int Y, X; scanf("%d %d\n", &Y, &X);
  int posX = 0;
  int count = 0;
  for (int y = 0; y < Y; y++) {
    scanf("%s", row);
    for (int x = 0; x < X; x++) {
      if (x == posX && row[x] == '#') {
        count++;
      }
    }
    posX = (posX + 3) % X;
  }

  printf("%d\n", count);
}
