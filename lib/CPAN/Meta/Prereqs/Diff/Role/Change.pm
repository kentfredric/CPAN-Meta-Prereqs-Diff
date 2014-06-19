use 5.008;    # utf8
use strict;
use warnings;
use utf8;

package CPAN::Meta::Prereqs::Diff::Role::Change;

our $VERSION = '0.001001';

# ABSTRACT: A base behavior for prerequisite changes

# AUTHORITY

use Moo::Role qw( has requires );

=attr C<phase>

The dependency phase ( such as: C<runtime>,C<configure> )

=attr C<type>

The dependency type ( such as: C<requires>,C<suggests> )

=attr C<module>

The depended upon module

=cut

has 'phase'  => ( is => ro =>, required => 1, );
has 'type'   => ( is => ro =>, required => 1, );
has 'module' => ( is => ro =>, required => 1, );

=requires C<is_addition>

=requires C<is_removal>

=requires C<is_change>

=requires C<describe>

=cut

requires is_addition =>;
requires is_removal  =>;
requires is_change   =>;
requires describe    =>;

no Moo;

1;

