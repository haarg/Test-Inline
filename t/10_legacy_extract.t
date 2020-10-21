# Check Test::Inline::Extract support for older test styles

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use File::Slurper ();
use File::Spec::Functions ':ALL';
use Test::More tests => 7;
use Test::Inline::Extract ();





#####################################################################
# Test the examples from Inline.pm
{
	my $inline_file = File::Slurper::read_text(
		catfile( 't', 'data', '10_legacy_extract', 'Inline.pm' ),
		'latin1', 'auto',
		);
	ok( $inline_file, 'Loaded Inline.pm examples' );

	my $Extract = Test::Inline::Extract->new( \$inline_file );
	isa_ok( $Extract, 'Test::Inline::Extract' );

	my $elements = $Extract->elements;
	is( ref($elements), 'ARRAY', '->elements returns an ARRAY ref' );
	is( scalar(@$elements), 3, '->elements returns three elements' );
	is( $elements->[0], 'package My::Pirate;', 'First element matches expected' );
	is( $elements->[1], <<'END_ELEMENT', 'Second element matches expected' );
=begin testing

my @p = is_pirate('Blargbeard', 'Alfonse', 'Capt. Hampton', 'Wesley');
is(@p,  2,   "Found two pirates.  ARRR!");

=end testing
END_ELEMENT
	is( $elements->[2], <<'END_ELEMENT', 'Third element matches expected' );
=for example begin

use LWP::Simple;
getprint "http://www.goats.com";

=for example end
END_ELEMENT
}
