#include "String.h"

String String_make (char* data) {
  String s;
  s.data = data;
  return s;
}
