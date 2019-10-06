
def main (argc: int, argv: char**): int = {
  var c: int = 0;
  while (c < 5) {
    printf("Hello world!\n");
    c += 1;
    break;
  };
  return 0;
}

