# Carbon Neutral Map

This is the source code for the [Carbon Netural Map](https://carbonneutralmap.org.uk) website.

## Getting Started

### Dependencies

- ruby - [rbenv](https://github.com/rbenv/rbenv) is a good way of getting it.
- nodejs - [nvm](https://github.com/nvm-sh/nvm) is another good way of getting it
- postgres

### Installation

- Clone the repo :-)
- run `gem install bundler` (if you don't have it already)
- run `bundle` from the root of the project
- run `npm install -g yarn`
- run `yarn` from the root of the project
- run `./nuke` to setup the database (if you run this again it will delete the database, handy but be careful)
- run `rails s` and visit [http://localhost:3000](http://localhost:3000)

## Scripts

- `./nuke` - Delete and Create a local test database
- `./run_tests` - Run the tests
