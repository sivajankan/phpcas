#!/usr/bin/perl

use Data::Dumper;
use strict;

my $php_setenv_string;

foreach my $key (keys %ENV) {
  # Ignore any $key which doesn't start with PHP_
  if ($key =~ /^PHP_/) {
    my $new_key = $key;
    $new_key =~ s/^PHP_//;
    my $newline = sprintf("    SetEnv %s \"%s\"\n", $new_key, $ENV{$key});
    #printf("    SetEnv %s \"%s\"\n", $new_key, $ENV{$key});
    $php_setenv_string = $php_setenv_string . $newline;
  }
}

my $conf_file = "/etc/apache2/conf-enabled/app.conf";
# my $conf_file = "app.conf";

open my $in,  '<', $conf_file or die "Can't read old file: $!";
open my $out, '>', $conf_file . ".new" or die "Can't write new file: $!";

while( <$in> ) {
  if (/#ENVIRONMENT_VAR_REPLACEMENT_TARGET/) {
    print $out $php_setenv_string;
  } else {
    print $out $_;
  }
}

close $out;

unlink $conf_file;
rename $conf_file . ".new", $conf_file;
