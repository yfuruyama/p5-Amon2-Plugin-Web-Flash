# NAME

Amon2::Plugin::Web::Flash - Amon2 plugin for showing message like rails flash

# SYNOPSIS

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

# DESCRIPTION

Amon2::Plugin::Web::Flash is a Amon2 plugin for showing some useful messages or notifications to the user.
This module ensures that messages will be shown only once.

# LICENSE

Copyright (C) Yuuki Furuyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Yuuki Furuyama <addsict@gmail.com>
