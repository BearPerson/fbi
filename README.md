What's this?
============

We're trying to build a message hub: A system that
you can notify whenever something interesting happens
on your project (VCS commit, bug report, ...) and
that can report that it happened to IRC, jabber, twitter,
or whatever you want, in near realtime.

Some systems that do this already exist, for example <http://CIA.vc>.
We're not trying to steal their userbase - we are just coders,
trying to find better ways to do things.

Our goals:

* Simplicity. Individual sources or sinks can be complicated,
  but the overall system design should not be.
* Reliability. You should not need to take the entire system down
  and cause user-visible interruptions just to do an upgrade
* Extensible. People should be able to write new message types,
  sources or sinks without changing much core code
* Compatible. We aim to improve, not replace. Thus, we should
  still support e.g. CIA.vc's XML commit format.


Getting started
===============

Dependencies
------------

You need an AMQP server, e.g. [RabbitMQ][].
You also need the `amqp` and `json` ruby gems installed.

The ruby-amqp project has a pretty good
[Getting started guide][amqp-ruby-gettingstarted].

  [rabbitmq]: [http://www.rabbitmq.com/]
  [amqp-ruby-gettingstarted]: [http://rdoc.info/github/ruby-amqp/amqp/master/file/docs/GettingStarted.textile]

Startup
-------

* Make sure `rabbitmq-server` is running
* inside `src`, run `ruby multiplexer.rb`
* To generate messages, run `ruby sources/test_timer.rb`
* To see messages in the system, run `ruby sinks/tail.rb`

Restarting
----------

For the most part, you can just kill the individual ruby processes
and start them again, in any order.

However, during development you may occasionally change queue configuration,
causing errors along the lines of
"PRECONDITION FAILED - parameters for queue 'fbi.sink-nil' not equivalent".
To get rid of these, do

* `rabbitmqctl stop_app`
* `rabbitmqctl reset`
* `rabbitmqctl start_app`

To restore the AMQP database to an empty state.

If you get "NOT_FOUND - no exchange 'fbi.sinks'", you are attempting
to start a sink before the main multiplexer is running. Don't do that.
