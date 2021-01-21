# SmartContract-Voting

## Le jugement majoritaire

### Le vote

Les électeurs attribuent à chaque candidat, une mention parmi une liste de 7 mentions :

- Excellent
- Très bien
- Bien
- Assez Bien
- Passable
- Insuffisant
- A rejeter

### Le dépouillement

Pour chaque candidat, on calcule le pourcentage de chaque mention. On récupère ensuite la mention majoritaire, c'est la mention qui est approuvée par au moins 50 %.

Le gagnant de l'élection est celui qui possède la mention majoritaire la plus haute.
En cas d'égalité on départage avec la différence de pourcentage.

## Installation

npm cache clean -f
rm -rf node_modules
rm package-lock.json
npm install github:barrysteyn/node-scrypt#fb60a8d3c158fe115a624b5ffa7480f3a24b03fb as mentioned earlier
npm install to install the rest of the dependencies



## Déploiement

https://medium.com/swlh/develop-test-and-deploy-your-first-ethereum-smart-contract-with-truffle-14e8956d69fc
truffle migrate --network kovan
truffle test --reset --network kovan

# Méthodes externes au contrat

```
ElectionHelper
    function endElection(uint _electionId) external isAdmin(msg.sender) {
    function getElectionWinner(uint _electionId) external view returns (uint) {
```

```
CandidateHelper
    function getCandidateName(uint _electionId, uint _candidateId) external view returns (string memory) {
    function getCandidatesCount(uint _electionId) external view returns (uint) {
    function getCandidateAverageNote(uint _electionId, uint _candidateId) external view returns (uint) {
    function calculatePercentageOfNote(uint _electionId, uint _candidateId, uint _note) external view returns(uint){
```

```
ElectionFactory
    function addAdmin(address _userAddress) external isAdmin(msg.sender) {
    function deleteAdmin(address _userAddress) external isAdmin(msg.sender) {
    function isUserAdmin(address userAddress) external view returns(bool){
    function getElectionsCount() external view returns (uint) {
    function createElection(string memory _title, string[] memory _candidatesNames) external isAdmin(msg.sender) returns (uint) {
    elections(uint _electionId);
```

```
VoteHelper
    function voteToElection(uint _electionId, uint[] calldata _notes) external hasNotVoted(_electionId) {
```