#include <stdio.h>

char firstNonDup(char *string, int length) {
  int i;
  int cs[256];
  for (i = 0; i < length; i++) {
    cs[string[i]]++;
  }

  for (i = 0; i < length; i++) {
    if (cs[string[i]] == 1) {
        return string[i];
    }
  }

  return ' ';
}

int main(int argc, char **argv) {
  const char string[] = "hello hellen";
  printf("First non-duplicate of %s is %c\n", string, firstNonDup(string, sizeof(string)));
}
