use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'WWW::B_Rail',
    'VERSION_FROM' => 'B_Rail.pm', # finds $VERSION
    'PREREQ_PM' => {
         'LWP::Simple' 		=> '1.35',
         'HTML::TokeParser'     => '2.24',
     },
     'dist' => {COMPRESS=>'gzip',SUFFIX=>'gz'},
);
