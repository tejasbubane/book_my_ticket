# README

![Tests](https://github.com/tejasbubane/book_my_ticket/actions/workflows/ci.yml/badge.svg)

Simple event ticket booking system built with Ruby on Rails.

* Ruby version: 3.4.1

* Database creation: `bundle exec rails db:create`

* System requirements: Postgresql database running

* Database initialization: `bundle exec rails db:migrate`

* How to run the test suite: `bundle exec rspec`


# System design and challenges

### Concurrency Handling:

Handles case when multiple users try to book more than available tickets. Multiple levels of checks added in increasing level of complexity:

* **Code level checks:** Limit ticket quantity select dropdown numbers to only available tickets. Check in TicketBookingService to skip if booking not possible.

* **Validation:** ActiveRecord validation to check if sold tickets does not exceed total available tickets. This comes in handy in cases where user has stale browser page open.

* **[Postgres Level Constraint](https://www.postgresql.org/docs/current/ddl-constraints.html):** Add a [DB-level check constraint](https://api.rubyonrails.org/v8.0.1/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_check_constraint) when multiple users book in parallel.

* **Row-level lock:** Use [Rails pessimistic locking](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Pessimistic.html) when updating sold ticket count.

### Caching:

* **Fragment Caching:** Use Rails' inbuilt [fragment caching](https://guides.rubyonrails.org/caching_with_rails.html#fragment-caching) for caching event details partials.

# Software design

* **Error handling with monads:** [TicketBookingService](app/services/ticket_booking_service.rb) uses [dry-monads](https://dry-rb.org/gems/dry-monads/1.6/result/) to elegantly handle `Success` and `Failure` cases.

* **Query Object:** [EventsQuery](app/queries/events_query.rb) encapsulates code for fetching created, booked and all events.

* **Custom matcher:** Making tests more readable with [this RSpec custom matcher](spec/support/event_matcher.rb) for checking if data element with event ID exists on the page.
