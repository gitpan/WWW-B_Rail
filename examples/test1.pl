#!/usr/bin/perl

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

