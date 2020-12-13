#include <cstdio>
#include <iostream>
using namespace std;

int nums[1100];
int buf[100];

void nop() {}
int compare (const void * a, const void * b) { return ( *(int*)a - *(int*)b ); }
void cpy (int* from, int* to, int len) { while(len--) { to[len] = from[len]; } }

int main() {
  int N, SEGLEN; scanf("%d %d", &N, &SEGLEN);
  for (int i = 0; i < N; i++) { scanf("%d", nums + i);}

  int n = SEGLEN;
  for (; n < N;) {
    cpy(nums + n - SEGLEN, buf, SEGLEN);
    qsort(buf, SEGLEN, sizeof(int), compare);
    for (int l = 0, h = SEGLEN - 1;;) {
      // printf("n: %d, num[n]: %d, l: %d (%d), h: %d (%d)\n", n, nums[n], l, buf[l], h, buf[h]);
      int sum = buf[l] + buf[h];
      
      if (l == h) {
        goto notfoundsum;
      }

      if (sum == nums[n]) {
        goto foundsum;
      }

      if (sum > nums[n]) { h--; continue; }
      if (sum < nums[n]) { l++; continue; }
    }
  foundsum:
    n++;
  }
notfoundsum:
  printf("stop at idx: %d num: %d\n", n, nums[n]);

  int invalidTarget = nums[n];
  for (int i = 0; i < N - 1; i++) {
    int sum = 0, j = i;
    while (sum < invalidTarget && j < N) { 
      sum += nums[j];
      if (sum == invalidTarget) {
        printf("invalid checksum is %d at %d - %d\n", nums[i] + nums[j - 1], i, j);
        return 0;
      }
      j++;
    }
  }
  return 0;
}
