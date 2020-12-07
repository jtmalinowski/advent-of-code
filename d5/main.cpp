#include <cstdio>
using namespace std;

const int SEATS_NO = 128;
const int ROW_LEN = 8;

bool taken[SEATS_NO][ROW_LEN]; 

int main() {
  for (int i = 0; i < SEATS_NO; i++) { 
    for (int j = 0; j < ROW_LEN; j++) {
      taken[i][j] = false; 
    } 
  }
  int N; scanf("%d", &N);
  int maxId = -1;

  while(N--) {
    char line[20]; scanf("%s", line);

    int slo = 0, shi = 127;
    for (int i = 0; i < 7; i++) {
      if (line[i] == 'F') {
        shi = slo + ((shi - slo) / 2);
      }
      if (line[i] == 'B') {
        slo = shi - ((shi - slo) / 2);
      }
    }

    int rlo = 0, rhi = 7;
    for (int i = 7; i < 7 + 3; i++) {
      if (line[i] == 'L') {
        rhi = rlo + ((rhi - rlo) / 2);
      }
      if (line[i] == 'R') {
        rlo = rhi - ((rhi - rlo) / 2);
      }
    }

    if (slo != shi || rhi != rlo) {
      printf("FATAL %d %d %d %d\n", slo, shi, rlo, rhi);
    }

    int id = 8 * slo + rlo;
    maxId = id > maxId ? id : maxId;

    taken[slo][rlo] = true;
  }

  printf("max: %d\n", maxId);

  for (int i = 0; i < SEATS_NO; i++) { 
    for (int j = 1; j < ROW_LEN - 1; j++) {
      if (!taken[i][j] && taken[i][j - 1] && taken[i][j + 1]) {
        printf("possible: %d %d %d\n", i, j, i * 8 + j);
      }
    } 
  }

  return 0;
}
