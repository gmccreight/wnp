# Design Goals

## Fast Tests

First and foremost, I want the tests to run extremely quickly.  Even the
integration tests.  This is the primarly design goal.  All else is secondary.
If the tests take more than a second to run on a top-of-the-line computer,
then we're not meeting our goal.

## Readily Refactorable

A secondary, but also critically important, goal is that the codebase be
ready-to-refactor at all times.  I guess this means aiming for 100% test
coverage, but I'm not going to be pedantic about it.  Basically, the point of
this goal is that I can't often get several hours of hacking time set aside,
but I can get half and hour here and half an hour there.  I want the code to
facilitate making very quick changes and refactorings.

## Fun!

This can't be overstated.  Nobody's paying me to work on this, so it had better
be gosh-darn fun!

## Easily installable

I'm going to try to get all of this done with Ruby 2 core and Sinatra.  We'll
see how that goes.

## Easy to back up

One of my takeaways from pageoftext.com is that the data model made it very
easy to back up the site, even as the data grew large.  It's very easy to rsync
gigs of data as long as it is split up nicely.  This project goes even further
than pageoftext.com in that direction, using the same object directory model as
git.  That model uses a cryptographically solid hash function, SHA-1, to get a
very even key distribution, then uses the first two characters of the 40 hex
character code as the directory name.  In other words, the data will be nicely
distributed into a large number of buckets.  Unlike git, however, the objects
are not content-addressible, rather the hash is a hash of the data's key.

## Runs on EC2 micro instance

If you get a reserved instance, a micro is like $6/mo.  Awesome!  We should
run on that.

## Collaboration

### You and groups

You are you.  You are also part of a group.  You are part of *many* groups.
You join and leave groups.  Some things you create for the group, others for
yourself.  Some things you always want to be in charge of, other things you
want to cede control of to others.  In other words, you and your groups are
very fluid, but many systems are rigid.  I'm looking at you, Google Docs!

### The public at large

Sometimes you want to share something with people that you don't want to have
to have sign up for the site.

#### Easy-to-remember URLs

The best way to share is an easy-to-remember URL (like on pageoftext.com)

#### Obviously unguessable URLs

If you really want to force people to type in something long, you can use this
option, too.

## Round-trip Markdown

The web front end should have round-trip Markdown.  In other words, you should
be able to use Markdown markup, or actually type in the rendered text, and have
it update the Markdown.

## Realtime group editing

We're gonna punt on this one for now, I think.  Too much to think through.

## Very flexible tagging

### Tag renaming

Sometimes you had the wrong name for a concept, or your understanding of a
concept is emerging over time.  Wouldn't it be great to be able to rename tags
in bulk?  Only some tags?  Etc.

### Tag searching

It would be great to be able to search for tags and see their surrounding context.

### Tag relationships

Is a tag really closely related to another tag?  How about creating a relationship
between them and specifying the strength of the relationship.

### Tag creation (and typo reduction)

When creating a tag, you should suggest tags that have a similar name to the
one you are currently filling in (and also, you should show related tags)



---

# Learning Goals

## Markdown

Part of the reason for this site using markdown is that I'd like be become
fluent in it.

## Sinatra

I've always wanted to have a project where Sinatra makes sense.  I think this
is one.

## Ruby 2

I'm actively looking for new features and functionality from Ruby 2 to use
in the code.  I'll highlight them with the [tag:ruby2:gem] tag.

## Minitest

I wanted to see what all the fuss is about, so we're using it instead of rspec.