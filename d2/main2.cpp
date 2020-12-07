#include <cstdio>
using namespace std;

int main() {
  int n; scanf("%d", &n);
  int result = 0;

  while (n--) {
    int idx1, idx2, count = 0;
    char c;
    scanf("%d-%d %c: ", &idx1, &idx2, &c);

    char l;
    int idx = 0;
    bool has1stPos = false, has2ndPos = false;
    while (1) {
      char l = getchar();
      idx++;
      
      // printf("c: %c l: %c idx: %d\n", c, l, idx);

      if (l == '\r') {
        continue;
      }

      if (l == '\n' || l == EOF) {
        if (has1stPos != has2ndPos) {
          result++;
        }
        break;
      }

      if (idx == idx1 && l == c) {
        has1stPos = true;
      }
      
      if (idx == idx2 && l == c) {
        has2ndPos = true;
      }
    }
  }
  printf("valid #: %d\n", result);
}
