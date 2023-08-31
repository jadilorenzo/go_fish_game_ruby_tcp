# Go Fish

This is a Go Fish project built with Ruby. It uses RSpec for testing and follows a TDD (Test-Driven Development) approach.

## Installation

To run this project locally, make sure you have Ruby installed on your system. Then, follow these steps:

1. Clone the project repository.
2. Navigate to the project directory.
3. Run the following command to install the required dependencies: 
```bundle install```

## Usage

To play the Go Fish game, run the following command:

## Testing

To run the tests for this project, run the following command:
```
rspec
```

## Contributing

If you would like to contribute to this project, feel free to submit a pull request. Please make sure to follow the established coding style and write tests for any new features or bug fixes.

## Models
### `GoFishGame`
Manages: rules of the game/game logic<br>
Collaborators: `CardDeck`

### `CardDeck`
Manages: order of cards outside of `player`'s hands<br>
Collaborators: `CardDeck`

### `PlayingCard`
Manages: rank and suit<br>
Collaborators: `CardDeck`, `Player`

### `GoFishPlayer`
Manages: hand, taking turns, creating books<br>
Collaborators: `Card`, `Game`

## GoFishTCPServer

Player 1:
```
Welcome. 0 players online.
Waiting for more players...
How many players would you like to play with?
Response: 2
```
Player 2:
```
Welcome. 1 player online
How many players would you like to play with?
(1 player waiting for 2 player game)
(1 player waiting for 4 player game)
Response: 2
```
`Game is created...`<br><br>
Player 1:
```
Game started...
It's your turn:
Hand: 
Ace of Spades
King of Diamonds
Queen of Hearts
Jack of Clubs
7 of Clubs
3 of Spades
2 of Hearts
Players: 
Player 2
Who would you like to ask? (Player 2 / 2)
Response: 2
For what rank? (A, K, Q, J, 7, 3, 2 or rank name)
Response: Ace
```

Player 2:
```
Game started...
It's Player 1's turn.
Hand: 
King of Spades
King of Clubs
10 of Clubs
8 of Hearts
8 of Spades
4 of Hearts
3 of Spades
```

`Player 2 doen't have any Aces...`<br><br>

Player 1:
```
Player 2 doen't have any Aces...
Go Fish!
It's Player 2's turn.
Hand:
Ace of Spades
King of Diamonds
Queen of Hearts
Jack of Clubs
7 of Clubs
3 of Spades
2 of Hearts
8 of Diamonds
```

Player 2:

```
Player 1 asked you for Aces.
Player 1 went fishing!
It's your turn:
Hand: 
King of Spades
King of Clubs
10 of Clubs
8 of Hearts
8 of Spades
4 of Hearts
3 of Spades
Players: 
Player 1
Who would you like to ask? (Player 1 / 1)
Response: 1
For what rank? (K, 10, 8, 4, 3 or card name)
Response: 8
```

`Player 1 has 8s!`<br><br>

Player 1:
```
Player 1 has 8s...
It's your turn:
Hand: 
King of Spades
King of Clubs
10 of Clubs
8 of Hearts
8 of Spades
8 of Diamonds
4 of Hearts
3 of Spades
Players: 
Player 1
Who would you like to ask? (Player 1 / 1)
Response: 1
For what rank? (K, 10, 8, 4, 3 or card name)
Response: 3
```