#!/usr/bin/env perl

while (<>) {
  if ($_ =~ m/\$HEX\[([A-Fa-f0-9]+)\]/) {
      print pack("H*", $1), "\n"
  } else {
      print $_;
  }
}
