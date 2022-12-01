#include <cstdio>
#include <cstdlib>
#include <tuple>
using namespace std;

char boardA[40000];
char boardB[40000];

bool taken(char *board, int x, int y, int diffX, int diffY, int X, int Y) {
  int idx = x + y * X + diffX + diffY * X;
  if (idx < 0 || idx >= Y * X) { return false; }
  if (x + diffX >= X) { return false; }
  if (x + diffX < 0) { return false; }
  if (y + diffY >= Y) { return false; }
  if (y + diffY < 0) { return false; }

  if (*(board + idx) == '.') {
    return taken(board, x + diffX, y + diffY, diffX, diffY, X, Y);
  }

  return *(board + idx) == '#';
}

int countAdj(char *board, int x, int y, int X, int Y) {
  int res = 0;
  if (taken(board, x, y, -1, -1, X, Y)) { res++; }
  if (taken(board, x, y, -1,  0, X, Y)) { res++; }
  if (taken(board, x, y, -1,  1, X, Y)) { res++; }
  if (taken(board, x, y,  0, -1, X, Y)) { res++; }
  if (taken(board, x, y,  0,  1, X, Y)) { res++; }
  if (taken(board, x, y,  1, -1, X, Y)) { res++; }
  if (taken(board, x, y,  1,  0, X, Y)) { res++; }
  if (taken(board, x, y,  1,  1, X, Y)) { res++; }
  return res;
}

void swap(pair<char*,char*> &boards) {
  char *t = boards.first;
  boards.first = boards.second;
  boards.second = t;
}

int main() {
  int X, Y; scanf ("%d %d", &X, &Y);

  for(int y = 0; y < Y; y++) {
    char line[200]; scanf("%s", line);
    for(int x = 0; x < X; x++) {
      boardA[x + y * X] = line[x];
    }
  }

  char *_boardA = &boardA[0];
  pair<char*,char*> boards = pair<char*,char*>(boardA, boardB);
  bool stable = false;
  while (!stable) {
    stable = true;
    for(int y = 0; y < Y; y++) {
      for(int x = 0; x < X; x++) {
        int idx = x + y * X;
        if (boards.first[idx] == 'L' && countAdj(boards.first, x, y, X, Y) == 0) {
          boards.second[idx] = '#'; stable = false;
        } else if (boards.first[idx] == '#' && countAdj(boards.first, x, y, X, Y) >= 5) {
          boards.second[idx] = 'L'; stable = false;
        } else {
          boards.second[idx] = boards.first[idx];
        }
      }
    }
    swap(boards);
  }

  int occupied = 0;
  for(int y = 0; y < Y; y++) {
    for(int x = 0; x < X; x++) {
      int idx = x + y * X;
      if (boards.first[idx] == '#') { occupied++; }
    }
  }
  printf("occupied: %d\n", occupied);
}
