package CLI::JSON::MD;
use 5.014;
use strict;
use warnings;
use utf8;

use JSON::XS;
use Data::Dumper;
use Path::Class;
use Mouse;

has fn => (
    is  => 'ro',
);
no Mouse;

sub _out {
    my ($str) = @_;
    print $str;
}

sub _build_line {
    my ($key, $value, $tab) = @_;
    my $type = ref $value;
    unless ($type) {
        if ($value =~ /^\d+$/) {
            $type = 'Int';
        } else {
            $type = 'Sring';
        }
    }


    sprintf "%s%s%s: (%s)\n", " " x $tab, "* ", $key, $type;
}

sub _dump_data {
    my($self, $hash, $tab) = @_;
    for my $key(keys %$hash) {
        my $value = $hash->{$key};
        my $str = _build_line($key, $value, $tab);
        _out($str);

        if(ref $value eq 'HASH') {
            $self->_dump_data($hash->{$key}, $tab + 2);
        }
        if (ref $value eq 'ARRAY') {
            if (scalar @$value > 0 && ref $value->[0] eq 'HASH') {
                $self->_dump_data($value->[0], $tab + 2);
            }
        }

    }
}

sub run {
    my $self = shift;
    my ($file) = @_;

    $file = file($file);
    my $str = $file->slurp;
    my $file_data = decode_json($str);
    my $fn = $file->dir->file('yy.md')->openw;

    $self->_dump_data($file_data, 0);
    $fn->close;
}
1;
