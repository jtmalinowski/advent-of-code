#include <cstdio>
#include <string>
#include <regex>
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

// byr (Birth Year) - four digits; at least 1920 and at most 2002.
regex regex_byr("^((19[2-9][0-9])|(200[0-2]))$", regex_constants::ECMAScript);

// iyr (Issue Year) - four digits; at least 2010 and at most 2020.
regex regex_iyr("^((201[0-9])|(2020))$", regex_constants::ECMAScript);

// eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
regex regex_eyr("^((202[0-9])|(2030))$", regex_constants::ECMAScript);

// hgt (Height) - a number followed by either cm or in:
// If cm, the number must be at least 150 and at most 193.
// If in, the number must be at least 59 and at most 76.
regex regex_hgt("^((1[5-8][0-9]cm)|(19[0-3]cm)|(59in)|(6[0-9]in)|(7[0-6]in))$", regex_constants::ECMAScript);

// hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
regex regex_hcl("^#[0-9a-f]{6}$", regex_constants::ECMAScript);

// ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
regex regex_ecl("^(amb|blu|brn|gry|grn|hzl|oth)$", regex_constants::ECMAScript);

// pid (Passport ID) - a nine-digit number, including leading zeroes.
regex regex_pid("^[0-9]{9}$", regex_constants::ECMAScript);

int main() {
  char c = '\0';
  int count = 0;

  bool isInKey = true;
  bool isInFeat = false;
  char buffer[100];
  string key;
  int bufferPos = 0;
  char prevC = '\0';

  while (1) {
    char t = getchar();
    if (t == '\r') { continue; } // windows

    prevC = c;
    c = t;
    buffer[bufferPos++] = c;

    if (c == ':') {
      // end of feature
      buffer[--bufferPos] = '\0'; // remove ':'
      key = string(buffer);
      buffer[bufferPos = 0] = '\0';
    }

    if ((c == ' ' || c == '\n' || c == EOF) && !key.empty()) {
      if (bufferPos == 0) continue;

      // end of property
      bufferPos--;
      buffer[bufferPos++] = '\0';
      string value = string(buffer);

      if (key.compare("byr") == 0 && regex_search(value, regex_byr)) { features = features | byr; }
      if (key.compare("iyr") == 0 && regex_search(value, regex_iyr)) { features = features | iyr; }
      if (key.compare("eyr") == 0 && regex_search(value, regex_eyr)) { features = features | eyr; }
      if (key.compare("hgt") == 0 && regex_search(value, regex_hgt)) { features = features | hgt; }
      if (key.compare("hcl") == 0 && regex_search(value, regex_hcl)) { features = features | hcl; }
      if (key.compare("ecl") == 0 && regex_search(value, regex_ecl)) { features = features | ecl; }
      if (key.compare("pid") == 0 && regex_search(value, regex_pid)) { features = features | pid; }

      buffer[bufferPos = 0] = '\0';
      key = string();
      value = string();
    }

    if ((prevC == '\n' && c == '\n') || c == EOF) {
      // end of one doc
      if ((features & requiredMap) == requiredMap) {
        count++;
      }
      features = 0;
      buffer[bufferPos = 0] = '\0';
      printf("\n");

      if (c == EOF) break;
      continue;
    }
  }
  printf("%d\n", count);
  return 0;
}
