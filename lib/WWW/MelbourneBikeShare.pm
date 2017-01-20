package WWW::MelbourneBikeShare;

use strict;
use warnings;

use LWP;
use JSON;
use WWW::MelbourneBikeShare::Terminal;

our $VERSION = 0.01;

sub new {
	my ( $class, %args ) = @_;

	my $self = bless {}, $class;

	$self->__init( %args );

	return $self
}

sub __init {
	my ( $self, %args ) = @_;

	$self->{ __ua } = LWP::UserAgent->new();
	$self->{ __uri } = 'https://data.melbourne.vic.gov.au/resource/qnjw-wgaj.json';
	$self->{ __cache }->{ timeout } = $args{ cache } ||= 900;
	$self->{ __cache }->{ present } = 0;
	$self->{ __cache }->{ last_update } = 0;

	$self->__get_service_data;
}

sub __cache_is_valid {
	my $self = shift;

	$self->{ __cache }->{ present } or return 0;

	( ( time - $self->{ __cache }->{ last_update } ) < $self->{ __cache }->{ timeout } )
		or return 0
}

sub __get_service_data {
	my $self = shift;

	return if $self->__cache_is_valid;

	$self->__process_service_data(
		$self->__get( 
			$self->__get_service_uri 
		)
	);
}

sub __process_service_data {
	my ( $self, $d ) = @_;

	@{ $self->{ __cache }->{ data } } = 
		map { WWW::MelbourneBikeShare::Terminal->new( $_ ) } @{ $d };

	$self->{ __cache }->{ present } = 1;
	$self->{ __cache }->{ last_update } = time;
}

sub __get {
        my ( $self, $url ) = @_; 

        my $r = $self->{ __ua }->get( $url );

        if ( $r->is_success ) { 
                $self->{ error } = ''; 
                return from_json( $r->content );
        }
        else {
                $self->{ error } = "Unable to retrieve $url: "
                        . $r->status_line . "\n";
                return 0
        }
}

sub __get_service_uri {
	my $self = shift;

	return 'https://data.melbourne.vic.gov.au/resource/qnjw-wgaj.json';
}

sub id {
	my ( $self, $id ) = @_;
	
	$id or return;

	for ( $self->terminals ) {
		return $_ if $_->id eq $id
	}
}

sub __data {
	my $self = shift;

	$self->__get_service_data;

	return @{ $self->{ __cache }->{ data } }
}

sub terminals {
	return $_[0]->__data
}

sub list {
	return map { $_->id } $_[0]->terminals
}

sub closest {
	my ( $self, $lat, $lon ) = @_;

	my @t = map  { $_->[0] }
		sort { $a->[1] <=> $b->[1] }
		map  { [ $_, __haversine( $lat, $lon, $_->lat, $_->lon ) ] } 
		     $self->terminals;

	return $t[0]
}

sub __asin { 
	my $x = shift; 
	atan2( $x, sqrt( 1 - $x * $x ) ) 
}
 
sub __haversine {
	my( $lat1, $lon1, $lat2, $lon2 ) = @_;

	my $radius = 6372.8;
	my $radians = ( 22 / 7 ) / 180;
	my $dlat = ( $lat2 - $lat1 ) * $radians;
	my $dlon = ( $lon2 - $lon1 ) * $radians;
	$lat1 *= $radians;
	$lat2 *= $radians;
	my $a = sin( $dlat / 2 )** 2 + cos( $lat1 ) * cos( $lat2 ) 
		* sin( $dlon / 2 )**2;
	my $c = 2 * __asin( sqrt( $a ) );

	return $radius * $c;
}

1;

#        {   
#                "coordinates" : 
#                {   
#                        "type" : "Point", 
#                        "coordinates": [ 144.946051,-37.842174 ]
#                },  
#                "featurename" : "Gasworks Arts Park - Pickles St - Albert Park",
#                "id" : "30",
#                "nbbikes" : "1",
#                "nbemptydoc" : "10",
#                "terminalname" : "60023",
#                "uploaddate" : "2017-01-20T01:30:06.000"
#        }, 

__END__

=head1 NAME

WWW::MelbourneBikeShare - The great new WWW::MelbourneBikeShare!



=head1 SYNOPSIS

Quick summary of what the module does.

	use WWW::MelbourneBikeShare;

	my $mbs = WWW::MelbourneBikeShare->new();

	$mbs->nearest();

	$mbs->list();

	$mbs->by_available_bikes()
	$mbs->by_empty_docks()
    ...

=head1 METHODS

=head2 function1

=head2 function2

=head1 AUTHOR

Luke Poksitt, C<< <ltp at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-melbournebikeshare at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-MelbourneBikeShare>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::MelbourneBikeShare


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-MelbourneBikeShare>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-MelbourneBikeShare>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-MelbourneBikeShare>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-MelbourneBikeShare/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Luke Poksitt.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut
