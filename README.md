## NAME

WWW::MelbourneBikeShare - Simple interface to the Melbourne Bike Share open
data set.

## SYNOPSIS

This module provides a simple interface to the Melbourne Bike Share open data 
set ([https://data.melbourne.vic.gov.au/Transport-Movement/Melbourne-bike-share/tdvh-n9dv](https://data.melbourne.vic.gov.au/Transport-Movement/Melbourne-bike-share/tdvh-n9dv)).

The Melbourne Bike Share open data set provides up to date information on the 
number of available bikes and slots available at each Melbourne Bike Share
terminal.  The data set also provides terminal metadata including; the terminal 
friendly name, the terminal ID, the terminal geographical coordinates, and a
time stamp indicating the time at which the terminal data was last updated.

	use WWW::MelbourneBikeShare;

	my $mbs = WWW::MelbourneBikeShare->new;

	# Get a list of all Melbourne Bike Share terminals as an array of
	# WWW::MelbourneBikeShare::Terminal objects.

	my @terminals = $mbs->terminals;

	# Print the ID, name, and number of bikes available at each terminal.
	
	map { 
		printf( "%-3s %-65 %-4s\n", $_->id, $_->name, $_->bikes )
	} @terminals;

	# Do the same thing, but order the list by the number of available bikes.
	map {
		printf( "%-3s %-65 %-4s\n", $_->id, $_->name, $_->bikes 
	} $mbs->by_available_bikes;

	# Or, by proximity to our current location.
	map { 
		printf( "%-3s %-65 %-4s\n", $_->id, $_->name, $_->bikes 
	} $mbs->by_distance( -37.816181, 144.952688 );

	# Get our closest terminal.
	my $t = $mbs->nearest( -37.816181, 144.952688 );

	# And print some information about it.
	print "Our closest terminal is " . $t->name
		." (ID ". $t->id . ") "
		." located approximately ". $t->distance( -37.816181, 144.952688 )
		."km away at ". $t->lat ", ". $t->lon .".\n\n"
		."The terminal currently has ". $t->bikes ." bikes available and "
		. $t->empty . " empty slots.\n\n";



## METHODS

### new ( cache => $CACHE\_TIME )

Constructor method - creates a new WWW::MelbourneBikeShare object.  

Accepts one optional parameter: __cache__ which allows the caller to specify the
maximum cache time for retrieved data.

The data set is currently updated every fifteen minutes and typically within a
short period following the quarter hour interval (e.g. 09:00, 09:15, 09:30, 09:45).
If no cache parameter is supplied to the constructor, then a maximum cache 
duration of 900s will be used - this reduces the volume of requests required to
be made to the data provider.

Under most circumstances, it should not be necessary to provide a cache 
argument to the constructor as the default value should be sufficient.  If you
explicitly want to refresh the cache (e.g. you are using a local time source to
determine the update interval) then you may explicitly invalidate the cache by
callling the ["refresh"](#refresh) method.

### refresh

Explicitly invalidate the local cache and cause the data set to be retrieved 
from the data provider.

### terminals

Get a list of all Melbourne bike share terminals as an array of 
[WWW::MelbourneBikeShare::Terminal](https://metacpan.org/pod/WWW::MelbourneBikeShare::Terminal) objects.  The order of the terminals is
the same as is returned in the data set by the provider.

### by\_id 

Get a list of all Melbourne bike share terminals as an array of 
[WWW::MelbourneBikeShare::Terminal](https://metacpan.org/pod/WWW::MelbourneBikeShare::Terminal) objects ordered by id. Note that the __id__
is different to the terminal id value returned by the __terminal__ method.

### by\_terminal

Get a list of all Melbourne bike share terminals as an array of 
[WWW::MelbourneBikeShare::Terminal](https://metacpan.org/pod/WWW::MelbourneBikeShare::Terminal) objects ordered by terminal id.

### by\_available\_bikes 

Get a list of all Melbourne bike share terminals as an array of 
[WWW::MelbourneBikeShare::Terminal](https://metacpan.org/pod/WWW::MelbourneBikeShare::Terminal) objects ordered by the number of available
bikes.

### by\_available\_docks 

Get a list of all Melbourne bike share terminals as an array of 
[WWW::MelbourneBikeShare::Terminal](https://metacpan.org/pod/WWW::MelbourneBikeShare::Terminal) objects ordered by the number of available
bike docks.

### by\_distance ( $LAT, $LON )

Get a list of all Melbourne bike share terminals as an array of 
[WWW::MelbourneBikeShare::Terminal](https://metacpan.org/pod/WWW::MelbourneBikeShare::Terminal) objects ordered by distance from the 
provided geographical coordinates.

### id ( $ID )

Return the terminal with the given ID as a [WWW::MelbourneBikeShare::Terminal](https://metacpan.org/pod/WWW::MelbourneBikeShare::Terminal)
object.

### terminal

Return the terminal with the given terminal ID as a 
[WWW::MelbourneBikeShare::Terminal](https://metacpan.org/pod/WWW::MelbourneBikeShare::Terminal) object.

### closest  ( $LAT, $LON )
Return the geographically nearest terminal as a 
[WWW::MelbourneBikeShare::Terminal](https://metacpan.org/pod/WWW::MelbourneBikeShare::Terminal) object via distance from the provided
geographical coordinates.

## AUTHOR

Luke Poskitt, `<ltp at cpan.org>`

## BUGS

Please report any bugs or feature requests to `bug-www-melbournebikeshare at rt.cpan.org`, or through
the web interface at [http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-MelbourneBikeShare](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-MelbourneBikeShare).  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

## SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::MelbourneBikeShare

You can also look for information at:

- RT: CPAN's request tracker (report bugs here)

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-MelbourneBikeShare](http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-MelbourneBikeShare)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/WWW-MelbourneBikeShare](http://annocpan.org/dist/WWW-MelbourneBikeShare)

- CPAN Ratings

    [http://cpanratings.perl.org/d/WWW-MelbourneBikeShare](http://cpanratings.perl.org/d/WWW-MelbourneBikeShare)

- Search CPAN

    [http://search.cpan.org/dist/WWW-MelbourneBikeShare/](http://search.cpan.org/dist/WWW-MelbourneBikeShare/)

- Melbourne Bike Share open data set

    [https://data.melbourne.vic.gov.au/Transport-Movement/Melbourne-bike-share/tdvh-n9dv](https://data.melbourne.vic.gov.au/Transport-Movement/Melbourne-bike-share/tdvh-n9dv)

## SEE ALSO

[WWW::MelbourneBikeShare::Terminal](https://metacpan.org/pod/WWW::MelbourneBikeShare::Terminal)

## LICENSE AND COPYRIGHT

Copyright 2017 Luke Poskitt.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

[http://www.perlfoundation.org/artistic_license_2_0](http://www.perlfoundation.org/artistic_license_2_0)

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
