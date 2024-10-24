# README #

## Alpop Analysis Setup Guide ##

### What is this repository for? ###

* Alpop Analysis API microservice
* Version 0.1.0
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

* Clone the repository:

```sh
git clone git@bitbucket.org:alpop-dev/alpop-analysis.git
cd <path/to>/alpop-analysis
```

* Install dependencies:

```sh
bundle install
```

* Configuration:

  * Ensure you have Ruby installed (version 3.3.5).
  * Create a `.env` file for environment variables.
  * Database configuration:
    * Set up your database (PostgreSQL).

    * Run migrations:

```sh
bundle exec rake db:migrate
```

* How to run tests:

```sh
bundle exec rspec
```

### Contribution guidelines ###

* Writing tests:
  * Ensure all new features have corresponding tests.
* Code review:
  * Submit pull requests for review.
* Other guidelines:
  * Follow the project's coding standards.

### Who do I talk to? ###

* Repo owner or admin
* Alpop development team
