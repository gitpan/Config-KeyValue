#!perl -T

use strict;
use warnings;
use Test::More tests => 8;

BEGIN {
	use_ok( 'Config::KeyValue' );
}


my $cfg = Config::KeyValue->new();
isa_ok($cfg, 'Config::KeyValue');

undef $@;
eval { $cfg->load_file('this/file/does/not/exist'); };
like($@, qr/^could not open file for reading/, 'error on non-existent file');

my $config_file = 't/config';

undef $@;
eval { $cfg->load_file($config_file); };
is($@, '', 'no error when reading existing file');

my $exp = {
  'one_key'           => 'multiple values',
  'simple_key'        => 'simple_value',
  'trailing_comment'  => 'trailing comment value'
};
my $got = $cfg->load_file($config_file);
is_deeply($got, $exp);

is( $cfg->get('one_key'),           'multiple values'         );
is( $cfg->get('simple_key'),        'simple_value'            );
is( $cfg->get('trailing_comment'),  'trailing comment value'  );

