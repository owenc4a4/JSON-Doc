use 5.016;
use strict;
use warnings;
use utf8;

use lib 'lib';

use JSON::XS;
use Data::Dumper;

my $client_data_json = models('home')->file(qw/root api client_data_raw.json/)->slurp;
my $client_data = decode_json($client_data_json);
my $result = $client_data->{result};
my $fh = models('home')->file('yy.md')->openw;

sub _out {
    my ($str) = @_;
    print $fh $str;
}

sub print_value {
    my($hash, $tab) = @_;
    for my $key(keys %$hash) {
        my $value = $hash->{$key};
        _out(sprintf "%s%s%s\n", " " x $tab, "* ", $key);

        if(ref $value eq 'HASH') {
            print_value($hash->{$key}, $tab + 2);
        }
        if (ref $value eq 'ARRAY') {
            if (scalar @$value > 0 && ref $value->[0] eq 'HASH') {
                print_value($value->[0], $tab + 2);
            }
        }

    }
}

print_value($result, 0);
$fh->close;
