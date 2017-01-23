package WWW::MelbourneBikeShare::Terminal;

use strict;
use warnings;

our @ATTRIBUTES = qw(coordinates featurename id nbbikes nbemptydoc uploaddate
terminalname);

our %ATTRIBUTES = (
	coordinates	=> 'coordinates',
	id		=> 'id',
	featurename	=> 'name',
	nbbikes		=> 'bikes',
	nbemptydoc	=> 'empty',
	terminalname	=> 'terminal',
	uploaddate	=> 'update'
);

{
	no strict 'refs';

	foreach my $attr ( keys %ATTRIBUTES ) {
		*{ __PACKAGE__ . "::$ATTRIBUTES{ $attr }" } = sub {
			my $self = shift;
			return $self->{ $ATTRIBUTES{ $attr } }
		}
	}

}

sub new {
	my ( $class, $d ) = @_;

	my $self = bless {}, $class;

	map { $self->{ $ATTRIBUTES{ $_ } } = $d->{ $_ } } keys %ATTRIBUTES;

	return $self
}

sub lat { $_[0]->__point( 1 ) }

sub lon { $_[0]->__point( 0 ) }

sub distance {
	my ( $self, $lat, $lon ) = @_;

	return unless $lat and $lon;

	return $self->__haversine( $lat, $lon )
}

sub __point { return $_[0]->{ coordinates }->{ coordinates }->[ $_[1] ] }

sub __asin { 
        my $x = shift; 
        atan2( $x, sqrt( 1 - $x * $x ) ) 
}
 
sub __haversine {
        my( $self, $lat, $lon ) = @_; 

	my $tlon = $lon;
        my $radius = 6372.8;
        my $radians = ( 22 / 7 ) / 180;
        my $dlat = ( $self->lat - $lat ) * $radians;
        my $dlon = ( $self->lon - $lon ) * $radians;
        my $a = sin( $dlat / 2 )** 2 
		+ cos( $self->lat * $radians ) 
		* cos( $lat * $radians ) 
                * sin( $dlon / 2 )**2;
        my $c = 2 * __asin( sqrt( $a ) );

        return $radius * $c; 
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

