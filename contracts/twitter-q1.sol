// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Twitter {
    // ----- START OF DO-NOT-EDIT ----- //
    struct Tweet {
        uint tweetId;
        address author;
        string content;
        uint createdAt;
    }

    struct User {
        address wallet;
        string name;
        uint[] userTweets;
    }

    mapping(address => User) public users;
    mapping(uint => Tweet) public tweets;
    uint256 public nextTweetId;

    // ----- END OF DO-NOT-EDIT ----- //

    function registerAccount(string calldata _name) external {
        // Vérifier que le nom n'est pas une chaîne vide
        require(bytes(_name).length > 0, "Name cannot be an empty string");

        // Créer un nouvel User struct
        User storage newUser = users[msg.sender];
        newUser.wallet = msg.sender;
        newUser.name = _name;

        // emit AccountRegistered(msg.sender, _name);
    }

    function postTweet(
        string calldata _content
    ) external accountExists(msg.sender) {
        uint tweetId = nextTweetId;
        Tweet storage newTweet = tweets[tweetId];
        newTweet.tweetId = tweetId;
        newTweet.author = msg.sender;
        newTweet.content = _content;
        newTweet.createdAt = block.timestamp;

        User storage user = users[msg.sender];
        user.userTweets.push(tweetId);

        nextTweetId++;
    }

    function readTweets(address _user) external view returns (Tweet[] memory) {
        uint[] memory userTweetIds = users[_user].userTweets;
        Tweet[] memory userTweets = new Tweet[](userTweetIds.length);

        for (uint i = 0; i < userTweetIds.length; i++) {
            userTweets[i] = tweets[userTweetIds[i]];
        }

        return userTweets;
    }

    modifier accountExists(address _user) {
        require(
            bytes(users[_user].name).length > 0,
            "This wallet does not belong to any account."
        );
        _;
    }
}
