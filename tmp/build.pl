use 5.016;
use Path::Class;
use JSON::XS;


my $data = {
    a => 1,
    b => 2,
    result => {
        go => "shen",
        hah => [
            {a => "world",},
        ],
    },
};

my $file = file('tmp/json.json');
my $fn = $file->openw;
my $text = encode_json $data;
print $fn $text;
say $text;
$fn->close;
