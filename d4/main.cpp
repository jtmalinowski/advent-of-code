#include <cstdio>
#include <string>
using namespace std;

const int byr = 1 << 0;
const int iyr = 1 << 1;
const int eyr = 1 << 2;
const int hgt = 1 << 3;
const int hcl = 1 << 4;
const int ecl = 1 << 5;
const int pid = 1 << 6;
const int cid = 1 << 7;

int features = 0;
int requiredMap = byr | iyr | eyr | hgt | hcl | ecl | pid;

bool isBufferEql(const char val1[], const char val2[]) {
  char idx = 0;
  while (1) {
    if (val1[idx] != val2[idx]) {
      return false;
    }

    if (val1[idx] == '\0' || val2[idx] == '\0') {
      break;
    }

    idx++;
  }
  return true;
}

int main() {
  char c = '\0';
  int count = 0;

  bool isInKey = true;
  bool isInFeat = false;
  char buffer[100];
  int bufferPos = 0;
  char prevC = '\0';

  while (1) {
    char t = getchar();
    if (t == '\r') { continue; } // windows

    prevC = c;
    c = t;
    buffer[bufferPos++] = c;

    if ((prevC == '\n' && c == '\n') || c == EOF) {
      // end of one doc
      if ((features & requiredMap) == requiredMap) {
        count++;
      }
      features = 0;

      if (c == EOF) {
        break;
      }
    }

    if (c == ':') {
      buffer[bufferPos - 1] = '\0'; // remove ':'

      string key = string(buffer);
      if (key.compare("byr") == 0) { features = features | byr; }
      if (key.compare("iyr") == 0) { features = features | iyr; }
      if (key.compare("eyr") == 0) { features = features | eyr; }
      if (key.compare("hgt") == 0) { features = features | hgt; }
      if (key.compare("hcl") == 0) { features = features | hcl; }
      if (key.compare("ecl") == 0) { features = features | ecl; }
      if (key.compare("pid") == 0) { features = features | pid; }
      if (key.compare("cid") == 0) { features = features | cid; }

      buffer[bufferPos = 0] = '\0';
    }

    if (c == ' ' || c == '\n') {
      buffer[bufferPos = 0] = '\0';
    }

  }
  printf("%d\n", count);
  return 0;
}
