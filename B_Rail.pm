package WWW::B_Rail;

$WWW::B_Rail::VERSION = 0.01;

use 5.006;
use strict;
use LWP::Simple;
use HTML::TokeParser;
use WWW::B_Rail::Cities::English;

use vars qw(%params $found);

sub new {
 my $proto = shift;
 my $class = ref($proto) || $proto;
 my $self = {};
 for my $t (qw(LANGUAGE FROM TO DAY MONTH YEAR DOA HOUR MINUTE PARSER))
 { $self->{$t} = ""; }
 $self->{DATA} = {};
 bless($self,$class);
 if (@_) 
 { my %params = ();
   %params = @_;
   for my $key (keys %params)
   { $self->{$key} = $params{$key}; }
 }
 return $self;
}

sub from {
 my $self = shift;
 if (@_) 
 { $self->{FROM} = shift; }
 return $self->{FROM};
}

sub to {
 my $self = shift;
 if (@_) 
 { $self->{TO} = shift; }
 return $self->{TO};
}

sub day {
 my $self = shift;
 if (@_) 
 { $self->{DAY} = shift; }
 return $self->{DAY};
}

sub year {
 my $self = shift;
 if (@_) 
 { $self->{YEAR} = shift; }
 return $self->{YEAR};
}

sub hour {
 my $self = shift;
 if (@_) 
 { $self->{HOUR} = shift; }
 return $self->{HOUR};
}

sub minute {
 my $self = shift;
 if (@_) 
 { $self->{MINUTE} = shift; }
 return $self->{MINUTE};
}

sub doa {
 my $self = shift;
 if (@_) 
 { $self->{DOA} = shift; }
 return $self->{DOA};
}

sub fetch {
 my $self = shift;
 my $departurecity = $cities{uc $self->{FROM}};
 my $arrivalcity = $cities{uc $self->{TO}};
 my $url = "http://193.121.180.17/scripts/Pcgittb.exe?langue=$self->{LANGUAGE}&idO_r=$departurecity&idD_r=$arrivalcity&idV_r=0&hh=$self->{HOUR}&mn=$self->{MINUTE}&j=$self->{DAY}&m=$self->{MONTH}&a=$self->{YEAR}&DoA=$self->{DOA}&reseau=sncb&nombre=0";
 my $page = get($url);
 $self->{PARSER} = HTML::TokeParser->new(\$page) || die "Can't open location: $!\n";
 my ($departure, $arrival, $time, $connections,$trains,$tag,$id);
 while($tag = $self->{PARSER}->get_tag())
 { if ($tag->[0] eq "input" && $tag->[1]{type} eq "checkbox" && $tag->[1]{name} eq "ch0")
   { $id = $tag->[1]{value};
     if ($id)
     { $self->{PARSER}->get_tag("td"); 
       $departure = $self->{PARSER}->get_text; 
       $self->{PARSER}->get_tag("td");
       $arrival = $self->{PARSER}->get_text; 
       $self->{PARSER}->get_tag("td");
       $time = $self->{PARSER}->get_text; 
       $self->{PARSER}->get_tag("td");
       $connections = $self->{PARSER}->get_text; 
       $self->{PARSER}->get_tag("td");
       $trains = $self->{PARSER}->get_text; 
       $self->{DATA}{$id} = {DEPARTURE=>$departure,ARRIVAL=>$arrival, TIME=>$time,CONNECTIONS=>$connections,TRAINS=>$trains};
       for(1..4)
       { $self->{PARSER}->get_tag("tr");  
         $self->{PARSER}->get_tag("td"); 
         my $t = $self->{PARSER}->get_tag("input"); 
         $id = $t->[1]{value};
         $self->{PARSER}->get_tag("td"); 
         $departure = $self->{PARSER}->get_text; 
         $self->{PARSER}->get_tag("td");
         $arrival = $self->{PARSER}->get_text; 
         $self->{PARSER}->get_tag("td");
         $time = $self->{PARSER}->get_text; 
         $self->{PARSER}->get_tag("td");
         $connections = $self->{PARSER}->get_text; 
         $self->{PARSER}->get_tag("td");
         $trains = $self->{PARSER}->get_text; 
         $self->{DATA}{$id} = {DEPARTURE=>$departure,ARRIVAL=>$arrival, TIME=>$time,CONNECTIONS=>$connections,TRAINS=>$trains};
       }
       last;
     }
   }
 }
 return $self->{DATA};
}

1;
__END__
=head1 NAME

WWW::B_Rail - Perl extension for b-rail.be

=head1 SYNOPSIS

  use WWW::B_Rail;

  my $brail = new WWW::B_Rail(LANGUAGE=>3,
                              FROM=>"LOUVAIN",
			      TO=>"DENDERMONDE",
			      DAY=>12,
			      MONTH=>4,
			      YEAR=>2002,
			      DOA=>1, #Departure or Arrival
			      HOUR=>20,
			      MINUTE=>0);
  %times = %{$brail->fetch};
  for $key (keys %times) 
  { %data = %{$times{$key}};
    for $foo (keys %data)
    { print $foo,"->",$data{$foo},"\n"; }
  }

=head1 DESCRIPTION

WWW::B_Rail is a Perl extension to consult the Belgian Railways website for
timetables.

=head1 EXPORT

None by default.

=head1 METHODES

=over 3

=item from($city)

=back

Define the departure station

=over 3

=item to($city)

=back

Define the arrival station

=over 3

=item day($day)

=back

Define the requested day

=over 3

=item month($month)

=back

Define the requested month

=over 3

=item year($year)

=back

Define the requested year

=over 3

=item hour($hour)

=back

Define the requested hour

=over 3

=item minute($minute)

=back

Define the requested minute

=over 3

=item doa($departureorarrival)

=back

Set either departure (0) or arrival (1) settings

=over 3

=item fetch()

=back

Fetch the specified data. Returns a reference to a hash containing references 
to hashes.

=head1 AUTHOR

Hendrik Van Belleghem  <lt> beatnik - at - quickndirty - dot - org <gt>

=head1 SEE ALSO

=cut

=head1 LICENSE

WWW::B_Rail is released under the GPL. See COPYING and COPYRIGHT for more info