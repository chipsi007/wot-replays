package WR::Plugin::Timing;
use Mojo::Base 'Mojolicious::Plugin';
use Time::HiRes qw/gettimeofday tv_interval/;

sub register {
    my $self = shift;
    my $app  = shift;


    $app->hook(before_dispatch => sub {
        my $c = shift;
        $c->stash('timing' => { start => [ gettimeofday ], hooks => {} });
    });
    
    $app->hook(after_static => sub {
        my $c = shift;
        $c->stash('timing')->{hooks}->{after_static} = tv_interval($c->stash('timing')->{start});
    });

    $app->hook(before_routes => sub {
        my $c = shift;
        $c->stash('timing')->{hooks}->{before_routes} = tv_interval($c->stash('timing')->{start});
    });

    $app->hook(around_action => sub {
        my ($next, $c, $action, $last) = (@_);
        $c->stash('timing')->{hooks}->{around_action} = tv_interval($c->stash('timing')->{start});
        return $next->();
    });

    $app->helper('full_timing_list' => sub {
        my $self = shift;
        my $l    = [];

        for(qw/after_static before_routes around_action/) {
            push(@$l, sprintf('%s: %.4f', $_, $self->stash('timing')->{hooks}->{$_}));
        }
        push(@$l, sprintf('total: %.4f', $self->stash('timing_elapsed')));

        return join(', ', @$L);
    });

    $app->hook(before_render => sub {
        my ($c, $args) = (@_);
        $c->stash('timing_elapsed' => tv_interval($c->stash('timing')->{start}));
    });
}

1;
