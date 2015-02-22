package Amon2::Plugin::Web::Flash;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";


sub init {
    my ($class, $c, $conf) = @_;
     $c->can('session') or die '$c->session interface not found';

    unless ($c->can('flash')) {
        Amon2::Util::add_method($c, 'flash', sub {
            my ($c, $key, $message) = @_;
            if ($message) {
                $class->_set_message($c, $key, $message);
            } else {
                return $class->_get_and_delete_message($c, $key);
            }
        });
    }
}

sub _set_message {
    my ($class, $c, $key, $message) = @_;

    my $v = $class->_get_message($c, $key);
    if ($v) {
        push @$v, $message;
    } else {
        $v = [$message];
    }

    $c->session->set($key, $v);
}

sub _get_and_delete_message {
    my ($class, $c, $key) = @_;
    my $v = $class->_get_message($c, $key);
    if ($v) {
        if ($c->session->can('remove')) {
            $c->session->remove($key);
        } elsif ($c->session->can('delete')) {
            $c->session->delete($key);
        }
    }
    return $v;
}

sub _get_message {
    my ($class, $c, $key) = @_;
    return $c->session->get($key);
}


1;
__END__

=encoding utf-8

=head1 NAME

Amon2::Plugin::Web::Flash - Amon2 plugin for showing message like rails flash

=head1 SYNOPSIS

    use Amon2::Lite;

    __PACKAGE__->load_plugin('Web::Flash');

    post '/entries' => sub {
        my $c = shift;
        $c->flash('notice', 'Created a new entry!');
        return $c->redirect('/');
    };

    get '/' => sub {
        my $c = shift;
        my $messages = $c->flash('notice');
        return $c->render('index.tt', +{ messages => $messages });
    };

    __PACKAGE__->to_app();

=head1 DESCRIPTION

Amon2::Plugin::Web::Flash is a Amon2 plugin for showing some useful messages or notifications to the user.
This module ensures that messages will be shown only once.

=head1 LICENSE

Copyright (C) Yuuki Furuyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Yuuki Furuyama E<lt>addsict@gmail.comE<gt>

=cut

