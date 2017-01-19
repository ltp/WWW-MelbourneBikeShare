package WWW::MelbourneBikeShare::Terminal;

use strict;
use warnings;

our @ATTRIBUTES = qw(A
coordinates
featurename
id
nbbikes
nbemptydoc
uploaddate
terminalname
);
foreach

sub new {
	my ( $class, $d ) = @_;

	my $self = bless {}, $class;

	return $self
}

1;

__END__

    {
      'id' => '9',
      'terminalname' => '60006',
      'coordinates' => {
			 'type' => 'Point',
			 'coordinates' => [
					    '144.963095',
					    '-37.807699'
					  ]
		       },
      'uploaddate' => '2017-01-20T02:30:05.000',
      'featurename' => 'RMIT - Swanston St / Franklin St - City',
      'nbemptydoc' => '4',
      'nbbikes' => '3'
    }

