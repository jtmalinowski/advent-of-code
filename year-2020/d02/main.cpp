#include <cstdio>
using namespace std;

int main() {
  int n; scanf("%d", &n);
  int result = 0;

  while (n--) {
    int min, max, count = 0;
    char c;
    scanf("%d-%d %c:", &min, &max, &c);

    char l;
    while (1) {
      char l = getchar();

      if (l == c) {
        count++;
      }
      
      if (l == '\r') {
        continue;
      }

      if (l == '\n' || l == EOF) {
        if (count <= max && count >= min) {
          result++;
          printf("success %d-%d %d\n", min, max, count);
        }
        break;
      }
    }
  }
  printf("valid #: %d\n", result);
}
