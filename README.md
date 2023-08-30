# Go Fish

This is a Go Fish project built with Ruby. It uses RSpec for testing and follows a TDD (Test-Driven Development) approach.

## Installation

To run this project locally, make sure you have Ruby installed on your system. Then, follow these steps:

1. Clone the project repository.
2. Navigate to the project directory.
3. Run the following command to install the required dependencies: `bundle install`

## Usage

To play the Go Fish game, run the following command:

## Testing

To run the tests for this project, run the following command:

## Contributing

If you would like to contribute to this project, feel free to submit a pull request. Please make sure to follow the established coding style and write tests for any new features or bug fixes.

## Models
### `GoFishGame`
Manages: rules of the game/game logic
Collaborators: `CardDeck`

### `CardDeck`
Manages: order of cards outside of `player`'s hands<br>
Collaborators: `CardDeck`

### `PlayingCard`
Manages: rank and suit
Collaborators: `CardDeck`, `Player`

### `GoFishPlayer`
Manages: hand, taking turns, creating books
Collaborators: `Card`, `Game`